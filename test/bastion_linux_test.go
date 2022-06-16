package main

import (
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Creation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
	})

    // Would fail if lifecycle.prevent_destroy is set on the bucket
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	bastionSecurityGroup := terraform.Output(t, terraformOptions, "bastion_security_group")
	bastionLaunchTemplate := terraform.Output(t, terraformOptions, "bastion_launch_template")
	bastionS3Bucket := terraform.Output(t, terraformOptions, "bastion_s3_bucket")

	assert.Regexp(t, regexp.MustCompile(`^sg-*`), bastionSecurityGroup)

	assert.Regexp(t, regexp.MustCompile(`^sg-*`), bastionLaunchTemplate)
	assert.Equal(t, "terminate", bastionLaunchTemplate)
	assert.Equal(t, "t3.micro", bastionLaunchTemplate)

	assert.Regexp(t, regexp.MustCompile(`^arn:aws:s3:::s3-bucket-*`), bastionS3Bucket)
	assert.Regexp(t, regexp.MustCompile(`^s3-bucket-*`), bastionS3Bucket)
}
