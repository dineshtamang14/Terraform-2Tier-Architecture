output "lb_url" {
  value = "${aws_lb.prodapp-alb.dns_name}"
  sensitive = false
  description = "application load balancer url"
  depends_on = []
}

output "target_group" {
  value = "${aws_lb_target_group.App-Tg-Prod.arn}"
  sensitive = false
  description = "target group arn"
  depends_on = []
}