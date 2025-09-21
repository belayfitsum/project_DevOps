terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
       version = ">= 5.0"
    }
  }

  ###########################################################################################
  # Backend block, bucket is manually created. The key variable will create a new directory #
  ###########################################################################################

  backend "s3" {
    bucket  = "my-terraform-tfstate12"
    key     = "infra.tfstate"
    region  = "eu-central-1"
    encrypt = true
    dynamodb_table = "express-postgres-api-tf-lock"
  }
}


##########################################################################################
# Provider block , authenticating through the only default profile in credentials folder 
##########################################################################################

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
      Project = var.project
      contact = var.contact
      ManageBy = "Terraform/setup"
    }
    
  }
  # profile ="default"
}
