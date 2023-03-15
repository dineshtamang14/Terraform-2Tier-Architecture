module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_autoscaling_group" "app_asg" {
  name = "App_ASG_${module.shared_vars.env_suffix}"
  max_size = 2
  min_size = 1
  health_check_grace_period = 400
  health_check_type = "ELB"
  desired_capacity = 1
  force_delete = true
  target_group_arns = ["${var.target-group}"]
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier = ["${module.shared_vars.public_subnet_id}", "subnet-02d7d3fc9888b1735"]

  launch_template {
    id      = "${var.launchtemplate-id}"
    version = "${var.latest_version}"
  }

  tag {
    key = "Environment"
    value = "${module.shared_vars.env_suffix}"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "application server"
    propagate_at_launch = true
  }
}