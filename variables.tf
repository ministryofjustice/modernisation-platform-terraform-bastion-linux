##Main
variable "region" {
  type        = string
  description = ""
}

variable "app_name" {
  type        = string
  description = "Name of application"
  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-.]{1,61}[A-Za-z0-9]$", var.app_name))
    error_message = "Invalid name for application supplied in variable app_name."
  }
}

variable "instance_name" {
  type        = string
  description = "Name of instance"
  default     = "bastion_linux"
}

variable "instance_type" {
  type        = string
  description = "Type of instance"
  default     = "t3.micro"
}

variable "business_unit" {
  type        = string
  description = "Fixed variable to specify business-unit for RAM shared subnets"
}

variable "subnet_set" {
  type        = string
  description = "Fixed variable to specify subnet-set for RAM shared subnets"
}

variable "environment" {
  type        = string
  description = "application environment"
}

##Bastion
variable "public_key_data" {
  type        = map(any)
  description = "User public keys for specific environment"
}

variable "extra_user_data_content" {
  type        = string
  default     = ""
  description = "Extra user data content for Bastion ec2"
}

variable "allow_ssh_commands" {
  type        = bool
  description = "Allow SSH commands to be specified"
  validation {
    condition     = (var.allow_ssh_commands == true || var.allow_ssh_commands == false)
    error_message = "Variable allow_ssh_commands must be boolean."
  }
}

variable "volume_size" {
  type        = number
  default     = 8
  description = "Size of the volume in gibibytes (GiB)"
}

## S3
variable "bucket_name" {
  type        = string
  description = "Bucket used for bucket log storage and user public keys"
  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-.]{1,61}[A-Za-z0-9]$", var.bucket_name))
    error_message = "The S3 bucket name is not valid in variable bucket_name."
  }
}

#### Logs
variable "log_auto_clean" {
  type        = string
  description = "Enable or not the lifecycle"
  validation {
    condition     = (var.log_auto_clean == "Enabled" || var.log_auto_clean == "Disabled")
    error_message = "Variable log_auto_clean must be string of either \"Enabled\" or \"Disabled\"."
  }
}

variable "log_standard_ia_days" {
  type        = number
  description = "Number of days before moving logs to IA Storage"
}

variable "log_glacier_days" {
  type        = number
  description = "Number of days before moving logs to Glacier"
}

variable "log_expiry_days" {
  type        = number
  description = "Number of days before logs expiration"
}

## Tags / Prefix
variable "tags_common" {
  description = "MOJ required tags"
  type        = map(string)
}

variable "tags_prefix" {
  description = "prefix for name tags"
  type        = string
}
variable "autoscaling_cron" {
  description = "Cron expressions for scale up and scale down"
  type        = map(string)
  default = {
    "up"   = "0 5 * * *"  # 5.00 UTC or 6.00 BST
    "down" = "0 20 * * *" # 20.00 UTC or 21.00 BST
  }
}

variable "custom_s3_kms_arn" {
  description = "KMS ARN for S3 bucket encryption"
  type        = string
  default     = ""
}
