module "shared_vars" {
  source = "../shared_vars"
}

# application load balancer 
resource "aws_lb" "prodapp-alb" {
  name = "app-alb-${module.shared_vars.env_suffix}"
  internal = false 
  load_balancer_type = "application"
  security_groups = ["${var.ExternalElbSGId}"]
  subnets = ["${module.shared_vars.public_subnet_id}", "subnet-02d7d3fc9888b1735"]

  enable_deletion_protection = false

  tags = {
    Environment = "${module.shared_vars.env_suffix}"
  }
}

# Target Groups for application load balancer
resource "aws_lb_target_group" "App-Tg-Prod" {
  name = "app-tg-${module.shared_vars.env_suffix}"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = "${module.shared_vars.vpcid}"

  # Disable round robin

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }

  health_check {
    interval = "20"
    path = "/"
    protocol = "HTTP"
    healthy_threshold = "2"
    unhealthy_threshold = "5"
    timeout = "15"
    matcher = "200"
  }
}