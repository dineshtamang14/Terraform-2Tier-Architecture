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

# importing rds for wordpress
module "rds" {
  source = "./RDS"
}

# importing launch template
module "launchtemplate" {
  source = "./launch-template"
  rds_arn = "${module.rds.rds_instance_arn}"
  
  depends_on = [
    module.rds
  ]
}

# importing load balancer module
module "loadbalancer_module" {
  source = "./application-loadbalancer"

  depends_on = [
    module.launchtemplate,
    module.rds
  ]
}

# importing listener module
module "listener" {
  source = "./listeners"
  application-lb = "${module.loadbalancer_module.alb_arn}"
  target-group = "${module.loadbalancer_module.target_group}" 
  depends_on = [
    module.loadbalancer_module,
    module.rds
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
    module.loadbalancer_module,
    module.rds
  ]
}