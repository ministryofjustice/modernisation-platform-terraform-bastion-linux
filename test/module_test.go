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

	bastionKMS := terraform.OutputMap(t, terraformOptions, "bastion_kms_key")
	bastionLaunchTemplate := terraform.OutputMap(t, terraformOptions, "bastion_launch_template")
	bastionSecurityGroup := terraform.OutputMap(t, terraformOptions, "bastion_security_group")
	bastionS3Bucket := terraform.OutputMap(t, terraformOptions, "bastion_s3_bucket")

	assert.Regexp(t, regexp.MustCompile(`[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}`), bastionKMS["bastion_0"])
	assert.Regexp(t, regexp.MustCompile(`[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}`), bastionKMS["bastion_1"])

	assert.Regexp(t, regexp.MustCompile(`lt-[a-f0-9]{17}`), bastionLaunchTemplate["bastion_0"])
	assert.Regexp(t, regexp.MustCompile(`lt-[a-f0-9]{17}`), bastionLaunchTemplate["bastion_1"])

	assert.Regexp(t, regexp.MustCompile(`sg-[a-f0-9]{17}`), bastionSecurityGroup["bastion_0"])
	assert.Regexp(t, regexp.MustCompile(`sg-[a-f0-9]{17}`), bastionSecurityGroup["bastion_1"])

	assert.Regexp(t, regexp.MustCompile(`bastion-\d-testing-test-[a-z0-9]{6}`), bastionS3Bucket["bastion_0"])
	assert.Regexp(t, regexp.MustCompile(`bastion-\d-testing-test-[a-z0-9]{6}`), bastionS3Bucket["bastion_1"])
}
