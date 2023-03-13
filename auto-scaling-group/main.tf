module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_autoscaling_group" "app_asg" {
  availability_zones = ["us-east-1a", "us-east-1b"]
  name = "App_ASG_${module.shared_vars.env_suffix}"
  max_size = 3
  min_size = 1
  health_check_grace_priod = 400
  health_check_type = "ELB"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${var.launchtemplate-name}"
  target_group_arns = ["${target-group}"]
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier = ["${module.shared_vars.public_subnet_id}", "subnet-02d7d3fc9888b1735"]

  tag {
    key = "Environment"
    value = "${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  }
}