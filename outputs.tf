output "application-lb-url" {
  value = "${module.loadbalancer_module.lb_url}"
  sensitive = false
  description = "application load balancer url"
  depends_on = []
}