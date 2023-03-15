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


# importing launch template
module "launchtemplate" {
  source = "./launch-template"
}

# importing load balancer module
module "loadbalancer_module" {
  source = "./application-loadbalancer"

  depends_on = [
    module.launchtemplate
  ]
}

# importing listener module
module "listener" {
  source = "./listeners"
  application-lb = "${module.loadbalancer_module.alb_arn}"
  target-group = "${module.loadbalancer_module.target_group}" 
  depends_on = [
    module.loadbalancer_module
  ]
}


# importing auto scaling group
module "autoscaling-group" {
  source = "./autoscaling-group"
  launchtemplate-id = "${module.launchtemplate.launchtemplate}"
  target-group = "${module.loadbalancer_module.target_group}"
  latest_version = "${module.launchtemplate.latest_version}"

  depends_on = [
    module.launchtemplate,
    module.loadbalancer_module
  ]
}