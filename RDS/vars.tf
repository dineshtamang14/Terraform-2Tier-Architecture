variable "db_sg" {
    type = string
    default = "sg-066e6e45f7b79cde2"
    description = "mysql database security group"
}

variable "db_username" {
    type = string
    default = "admin"
    sensitive = true
}

variable "db_password" {
    type = string
    default = "admin123"
    sensitive = true
}