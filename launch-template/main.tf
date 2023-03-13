module "shared_vars" {
  source = "../shared_vars"
}

# launch template for application server
resource "aws_launch_template" "App-LC_13_2023" {
  name = "App-LC_13_2023_${module.shared_vars.env_suffix}"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
    }
  }

  # ec2 stop, terminate protection
  disable_api_stop        = false
  disable_api_termination = false

  ebs_optimized = false

  iam_instance_profile {
    name = "ec2_instance_role_prod"
  }

  image_id = "${var.ami-id}"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "${var.instance-type[module.shared_vars.env_suffix]}"

  key_name = "application-server-key"

  network_interfaces {
    associate_public_ip_address = true
  }

  vpc_security_group_ids = ["${var.application-server-sg}"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "application server"
      Environment = "${module.shared_vars.env_suffix}"
    }
  }

  user_data = filebase64("${var.userdatapath}")
}