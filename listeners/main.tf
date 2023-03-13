# http listener
resource "aws_lb_listener" "App-HTTP-Listener" {
  load_balancer_arn = "${aws_lb.application-lb.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.target-group.arn}"
    type = "forward"
  }
}

# https listener
resource "aws_lb_listener" "App-HTTPS-Listener" {
  load_balancer_arn = "${aws_lb.application-lb.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:us-east-1:120211568300:certificate/05829a3c-4b77-4726-9ff0-b0f47a05479a"

  default_action {
    target_group_arn = "${aws_lb_target_group.target-group.arn}"
    type = "forward"
  }
}