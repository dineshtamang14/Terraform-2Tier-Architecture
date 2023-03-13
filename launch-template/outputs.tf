output "launchtemplate" {
  value = "${aws_launch_template.App-LT_13_2023.id}"
  sensitive = false
  description = "launch template id"
  depends_on = []
}

output "latest_version" {
  value = "${aws_launch_template.App-LT_13_2023.latest_version}"
  sensitive = false
  description = "launch template latest_version"
  depends_on = []
}