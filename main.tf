data "aws_caller_identity" "current" {}

# get shared subnet-set vpc object
data "aws_vpc" "shared_vpc" {
  # provider = aws.share-host
  tags = {
    Name = "${var.business_unit}-${var.environment}"
  }
}

data "aws_subnets" "local_account" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.shared_vpc.id]
  }
}

data "aws_subnet" "local_account" {
  for_each = toset(data.aws_subnets.local_account.ids)
  id       = each.value
}

# get shared subnet-set private (az (a) subnet)
data "aws_subnet" "private_az_a" {
  # provider = aws.share-host
  tags = {
    Name = "${var.business_unit}-${var.environment}-${var.subnet_set}-private-${var.region}a"
  }
}

# get core_vpc account protected subnets security group
data "aws_security_group" "core_vpc_protected" {
  provider = aws.share-host

  tags = {
    Name = "${var.business_unit}-${var.environment}-int-endpoint"
  }
}

# get core_vpc account S3 endpoint
data "aws_vpc_endpoint" "s3" {
  provider     = aws.share-host
  vpc_id       = data.aws_vpc.shared_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  tags = {
    Name = "${var.business_unit}-${var.environment}-com.amazonaws.${var.region}.s3"
  }

}

# S3
resource "aws_kms_key" "bastion_s3" {
  #checkov:skip=CKV2_AWS_64: Policy defined in separate resource
  count               = var.custom_s3_kms_arn != "" ? 0 : 1
  enable_key_rotation = true

  tags = merge(
    var.tags_common,
    {
      Name = "bastion_s3"
    },
  )
}

resource "aws_kms_alias" "bastion_s3" {
  count         = var.custom_s3_kms_arn != "" ? 0 : 1
  name_prefix   = "alias/modernisation-platform-bastion"
  target_key_id = aws_kms_key.bastion_s3[0].id
}

resource "aws_kms_key_policy" "bastion_s3" {
  count = var.custom_s3_kms_arn != "" ? 0 : 1

  key_id = aws_kms_key.bastion_s3[0].id
  policy = jsonencode({
    Id = "bastion-key-access"
    Statement = [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : aws_kms_key.bastion_s3[0].arn
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.bastion_role.arn
        }

        Resource = aws_kms_key.bastion_s3[0].arn
      },
    ]
    Version = "2012-10-17"
  })
}

resource "random_string" "random6" {
  length  = 6
  special = false
}

#tfsec:ignore:avd-aws-0132 - The bucket policy is attached to the bucket
module "s3-bucket" {
  #checkov:skip=CKV2_AWS_64: "Ensure KMS key Policy is defined - not needed here"
  source = "github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket?ref=474f27a3f9bf542a8826c76fb049cc84b5cf136f" #v8.2.1

  providers = {
    # Since replication_enabled is false, the below provider is not being used.
    # Therefore, just to get around the requirement, we pass the aws.share-tenant.
    # If replication was enabled, a different provider would be needed.
    aws.bucket-replication = aws.share-tenant
  }
  bucket_name         = "${var.bucket_name}-${var.tags_prefix}-${lower(random_string.random6.result)}"
  replication_enabled = false
  force_destroy       = true

  custom_kms_key = var.custom_s3_kms_arn != "" ? var.custom_s3_kms_arn : ""

  lifecycle_rule = [
    {
      id      = "log"
      enabled = var.log_auto_clean
      prefix  = "logs/"

      tags = {
        rule      = "log"
        autoclean = var.log_auto_clean
      }

      transition = [
        {
          days          = var.log_standard_ia_days
          storage_class = "STANDARD_IA"
          }, {
          days          = var.log_glacier_days
          storage_class = "GLACIER"
        }
      ]

      expiration = {
        days = var.log_expiry_days
      }

      noncurrent_version_transition = [
        {
          days          = var.log_standard_ia_days
          storage_class = "STANDARD_IA"
          }, {
          days          = var.log_glacier_days
          storage_class = "GLACIER"
        }
      ]

      noncurrent_version_expiration = {
        days = var.log_expiry_days
      }
    }
  ]

  tags = merge(
    var.tags_common,
    {
      Name = var.instance_name
    },
  )
}

resource "aws_s3_object" "bucket_public_keys_readme" {
  bucket = module.s3-bucket.bucket.id

  key        = "public-keys/README.txt"
  content    = "Drop here the ssh public keys of the instances you want to control"
  kms_key_id = local.kms_key_arn

  tags = merge(
    var.tags_common,
    {
      Name = "bastion-${var.app_name}-README.txt"
    }
  )

}

resource "aws_s3_object" "user_public_keys" {
  for_each = var.public_key_data

  bucket     = module.s3-bucket.bucket.id
  key        = "public-keys/${each.key}.pub"
  content    = each.value
  kms_key_id = local.kms_key_arn

  tags = merge(
    var.tags_common,
    {
      Name = "bastion-${var.app_name}-${each.key}-publickey"
    }
  )

}

# Security Groups
resource "aws_security_group" "bastion_linux" {
  description = "Configure bastion access - ingress should be only from Systems Session Manager (SSM)"
  name_prefix = "${replace(var.instance_name, "_", "-")}-${var.app_name}"
  vpc_id      = data.aws_vpc.shared_vpc.id

  tags = merge(
    var.tags_common,
    {
      Name = "${replace(var.instance_name, "_", "-")}-${var.app_name}"
    }
  )
}

resource "aws_security_group_rule" "bastion_linux_egress_1" {
  security_group_id = aws_security_group.bastion_linux.id

  description = "${var.instance_name}_to_local_subnet_CIDRs"
  type        = "egress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "TCP"
  cidr_blocks = [for s in data.aws_subnet.local_account : s.cidr_block]
}

resource "aws_security_group_rule" "bastion_linux_egress_2" {
  security_group_id = aws_security_group.bastion_linux.id

  description              = "${var.instance_name}_egress_to_interface_endpoints"
  type                     = "egress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "TCP"
  source_security_group_id = data.aws_security_group.core_vpc_protected.id
}

resource "aws_security_group_rule" "bastion_linux_egress_3" {
  security_group_id = aws_security_group.bastion_linux.id

  description     = "${var.instance_name}_egress_to_s3_endpoint"
  type            = "egress"
  from_port       = "443"
  to_port         = "443"
  protocol        = "TCP"
  prefix_list_ids = [data.aws_vpc_endpoint.s3.prefix_list_id]
}


# IAM
data "aws_iam_policy_document" "bastion_assume_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion_role" {
  name_prefix        = "${var.instance_name}_ec2_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_policy_document.json

  tags = merge(
    var.tags_common,
    {
      Name = "${var.instance_name}_ec2_role"
    },
  )
}

#wildcards permissible for access to log bucket objects
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "bastion_policy_document" {

  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject"
    ]
    resources = ["${module.s3-bucket.bucket.arn}/logs/*"]
  }

  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = ["${module.s3-bucket.bucket.arn}/public-keys/*"]
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [module.s3-bucket.bucket.arn]

    condition {
      test = "ForAnyValue:StringEquals"
      values = [
        "public-keys/",
        "logs/"
      ]
      variable = "s3:prefix"
    }
  }

  statement {
    actions = [

      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [local.kms_key_arn]
  }
}

resource "aws_iam_policy" "bastion_policy" {
  name_prefix = var.instance_name
  policy      = data.aws_iam_policy_document.bastion_policy_document.json
}

resource "aws_iam_role_policy_attachment" "bastion_s3" {
  policy_arn = aws_iam_policy.bastion_policy.arn
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_role_policy_attachment" "bastion_managed" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_role.name
}

#wildcards permissible read access to specific buckets
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "bastion_ssm_s3_policy_document" {

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::aws-ssm-${var.region}/*",
      "arn:aws:s3:::aws-windows-downloads-${var.region}/*",
      "arn:aws:s3:::amazon-ssm-${var.region}/*",
      "arn:aws:s3:::amazon-ssm-packages-${var.region}/*",
      "arn:aws:s3:::${var.region}-birdwatcher-prod/*",
      "arn:aws:s3:::aws-ssm-distributor-file-${var.region}/*",
      "arn:aws:s3:::aws-ssm-document-attachments-${var.region}/*",
      "arn:aws:s3:::patch-baseline-snapshot-${var.region}/*"
    ]
  }
}

resource "aws_iam_policy" "bastion_ssm_s3_policy" {
  name_prefix = "${var.instance_name}_ssm_s3"
  policy      = data.aws_iam_policy_document.bastion_ssm_s3_policy_document.json
}

resource "aws_iam_role_policy_attachment" "bastion_host_ssm_s3" {
  policy_arn = aws_iam_policy.bastion_ssm_s3_policy.arn
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name_prefix = "${replace(var.instance_name, "_", "-")}-ec2-profile"
  role        = aws_iam_role.bastion_role.name
  path        = "/"
}

## Bastion
resource "aws_launch_template" "bastion_linux_template" {
  name_prefix = "${var.instance_name}_template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      encrypted   = true
    }
  }

  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.bastion_profile.id
  }

  image_id                             = "resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type

  metadata_options {
    http_endpoint               = "enabled" # defaults to enabled but is required if http_tokens is specified
    http_put_response_hop_limit = 1         # default is 1, value values are 1 through 64
    http_tokens                 = "required"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    device_index                = 0
    security_groups             = [aws_security_group.bastion_linux.id]
    subnet_id                   = data.aws_subnet.private_az_a.id
    delete_on_termination       = true
  }

  placement {
    availability_zone = "${var.region}a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags_common,
      {
        Name = var.instance_name
      }
    )
  }

  user_data = base64encode(
    templatefile(
      "${path.module}/templates/user_data.sh.tftpl",
      {
        aws_region              = var.region
        bucket_name             = module.s3-bucket.bucket.id
        extra_user_data_content = var.extra_user_data_content
        allow_ssh_commands      = var.allow_ssh_commands
      }
    )
  )
}

resource "aws_autoscaling_group" "bastion_linux_daily" {
  launch_template {
    id      = aws_launch_template.bastion_linux_template.id
    version = "$Latest"
  }
  availability_zones        = ["${var.region}a"]
  name_prefix               = "${var.instance_name}_daily"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags_common

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_schedule" "bastion_linux_scale_down" {
  scheduled_action_name  = "${var.instance_name}_scale_down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.autoscaling_cron["down"]
  autoscaling_group_name = aws_autoscaling_group.bastion_linux_daily.name
}

resource "aws_autoscaling_schedule" "bastion_linux_scale_up" {
  scheduled_action_name  = "${var.instance_name}_scale_up"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 1
  recurrence             = var.autoscaling_cron["up"]
  autoscaling_group_name = aws_autoscaling_group.bastion_linux_daily.name
}
