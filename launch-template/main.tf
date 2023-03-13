module "shared_vars" {
  source = "../shared_vars"
}

# launch template for application server
resource "aws_launch_template" "App-LC_13_2023" {
  name = "foo"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  # ec2 stop, terminate protection
  disable_api_stop        = false
  disable_api_termination = false

  ebs_optimized = false

  iam_instance_profile {
    name = "test"
  }

  image_id = "ami-test"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = "test"

  network_interfaces {
    associate_public_ip_address = true
  }

  vpc_security_group_ids = ["sg-12345678"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "application server"
      Environment = "production"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}