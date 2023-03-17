module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_db_instance" "wordpress_database" {
  identifier           = "wordpress-database-${module.shared_vars.env_suffix}"
  allocated_storage    = 10
  db_name              = "wordpress_db"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  storage_type         = "gp2"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = ["${var.db_sg}"]

  tags = {
    Name = "mysql-db"
    Environment = "${module.shared_vars.env_suffix}"
  }
}