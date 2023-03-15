module "shared_vars" {
  source = "../shared_vars"
}

# launch template for application server
resource "aws_launch_template" "App-LT_13_2023" {
  name = "app-lt_13_2023_${module.shared_vars.env_suffix}"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      delete_on_termination = true
      volume_type = "gp2"
    }
  }

  image_id = "${var.ami-id}"
  instance_type = "${var.instance-type[module.shared_vars.env_suffix]}"
  key_name = "application-server-key"

  iam_instance_profile {
    name = "ec2_instance_role_prod"
  }

  # vpc_security_group_ids = ["${var.application-server-sg}"]

  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups = ["${var.application-server-sg}"]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "application server"
      Environment = "${module.shared_vars.env_suffix}"
    }
  }

  user_data = filebase64("${var.userdatapath}")
}