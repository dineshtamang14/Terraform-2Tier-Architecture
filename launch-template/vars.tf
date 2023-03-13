variable "ami-id" {
    type = string
    default = "ami-005f9685cb30f234b"
    description = "amazon linux 2 ami id"
}

variable "instance-type" {
    type = map
    default = {
        "default" : "t2.micro",
        "staging" : "t2.small",
        "production" : "t2.medium"
    }
    description = "instance type based on environment variables"
}

variable "application-server-sg" {
    type = string
    default = ""
    description = "application server security group name"
}