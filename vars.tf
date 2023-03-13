variable "DMZSubnetIds" {
    type = list
    default = ["subnet-046ceaa47fcdadf11", "subnet-01473e0018860cdff"]
    description = "subnet for the application load balancer"
}