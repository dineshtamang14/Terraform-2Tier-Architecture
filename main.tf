terraform {
    backend "s3" {
      bucket = "dinesh-terraform-state"   # "infrastructure-remote-state"
      key = "Terraform-Course/aws_project.tfstate"
      region = "us-east-1"
    }
}

provider "aws" {  # Recommended way of defining provider
    region = "us-east-1"
    shared_config_files      = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]
    // profile = "Dinesh-Tamang"
}
