output "rds_instance_arn" {
    value = "${aws_db_instance.wordpress_database.arn}"
    sensitive = true
    description = "mysql database instance name"
    depends_on = []
}