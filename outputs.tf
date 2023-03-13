output "application-lb-url" {
  value = "${module.loadbalancer_module.alb_url}"
  sensitive = false
  description = "application load balancer url"
  depends_on = []
}