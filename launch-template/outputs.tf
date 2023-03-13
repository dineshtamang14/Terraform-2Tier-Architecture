outputs "launchtemplate-name" {
  value = "${aws_launch_template.App-LC_13_2023.name}"
  sensitive = false
  description = "launch template name"
  depends_on = []
}