package main

import (
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBastionCreation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
	})

	// Would fail if lifecycle.prevent_destroy is set on the bucket
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	bastionSecurityGroup1 := terraform.Output(t, terraformOptions, "bastion_security_group_1")
	bastionLaunchTemplate1 := terraform.Output(t, terraformOptions, "bastion_launch_template_1")
	bastionS3Bucket1 := terraform.Output(t, terraformOptions, "bastion_s3_bucket_1")

	assert.Regexp(t, regexp.MustCompile(`^sg-*`), bastionSecurityGroup1)
	assert.Contains(t, bastionLaunchTemplate1, "arn:aws:ec2:eu-west-2:")
	assert.Contains(t, bastionLaunchTemplate1, "instance_type:t3.micro")
	assert.Contains(t, bastionS3Bucket1, "arn:aws:s3:::bastion-1-testing-test-")

	bastionSecurityGroup2 := terraform.Output(t, terraformOptions, "bastion_security_group_2")
	bastionLaunchTemplate2 := terraform.Output(t, terraformOptions, "bastion_launch_template_2")
	bastionS3Bucket2 := terraform.Output(t, terraformOptions, "bastion_s3_bucket_2")

	assert.Regexp(t, regexp.MustCompile(`^sg-*`), bastionSecurityGroup2)
	assert.Contains(t, bastionLaunchTemplate2, "arn:aws:ec2:eu-west-2:")
	assert.Contains(t, bastionLaunchTemplate2, "instance_type:t3.micro")
	assert.Contains(t, bastionS3Bucket2, "arn:aws:s3:::bastion-2-testing-test-")
}
