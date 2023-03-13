variable "ExternalElbSGId" {
    type = string
    default = "sg-04290eebeb75cae50"
    description = "Security group for the application load balancer"
}

variable "DMZSubnetIds" {
    type = list
    default = ["subnet-046ceaa47fcdadf11", "subnet-01473e0018860cdff"]
    description = "subnet for the application load balancer"
}

variable "VPCId" {
    type = string
    default = "vpc-075e85e43a3ad0bee"
    description = "vpc id for the target group"
}