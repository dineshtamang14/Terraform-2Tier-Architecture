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

# application load balancer 
resource "aws_lb" "prodapp-alb" {
  name = "App-ALB-Prod"
  internal = false 
  security_groups = ["${var.ExternalElbSGId}"]
  subnets = "${var.DMZSubnetIds}"

  enable_deletion_protection = false

  tags {
    Environment = "production"
  }
}

# Target Groups for application load balancer
resource "aws_lb_target_group" "App-Tg-Prod" {
  name = "App-Tg-Prod"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.VPCId}"
}