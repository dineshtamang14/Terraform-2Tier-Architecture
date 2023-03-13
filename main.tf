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

# importing load balancer module
module "loadbalancer_module" {
  source = "./application-load-balancer"
}

# importing listener module
module "listener" {
  source = "./listeners"
  application-lb = "${module.loadbalancer_module.lb_url}"
  target-group = "${module.loadbalancer_module.target_group}"  
}

# importing launch template
module "launchtemplate" {
  source = "./launch-template"
}

# importing auto scaling group
module "autoscaling-group" {
  source "./auto-scaling-group"
  launchtemplate-name = "${module.launchtemplate.launchtemplate-name}"
  target-group = "${module.loadbalancer_module.target_group}"
}