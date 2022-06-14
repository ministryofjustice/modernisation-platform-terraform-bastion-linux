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

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	bastionSecurityGroup := terraform.Output(t, terraformOptions, "bastion_security_group")

	assert.Regexp(t, regexp.MustCompile(`^AWSS3BucketReplication*`), bastion_security_group)
}
