output "vpcid" {
    value = "${local.vpcid}"
    sensitive = false
    description = "vpc id based on the environment"
    depends_on = []
}

output "private_subnet_id" {
  value = "${local.private_subnet_id}"
  sensitive = false
  description = "private subnet id"
  depends_on = []
}

output "public_subnet_id" {
  value = "${local.public_subnet_id}"
  sensitive = false
  description = "public subnet id"
  depends_on = []
}

output "env_suffix" {
  value = "${local.env}"
  sensitive = false
  description = "Environment Name"
  depends_on = []
}