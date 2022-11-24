terraform {
  required_providers {
    aws = {
      version               = "~> 4.0"
      source                = "hashicorp/aws"
      configuration_aliases = [aws.share-host, aws.share-tenant]
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.4"
    }
  }
  required_version = ">= 1.0.1"
}
