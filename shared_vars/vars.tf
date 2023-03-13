# creating a local shared able variables
locals {
  env = "${terraform.workspace}"

  # vpc Environment Variable
  vpcid_env = {
    default = "vpc-075e85e43a3ad0bee"
    staging = "vpc-075e85e43a3ad0bee"
    production = "vpc-075e85e43a3ad0bee"
  }

  vpcid = "${lookup(local.vpcid_env, local.env)}"


    # subnet Environment variable
    private_subnet_env = {
        default = "subnet-02d7d3fc9888b1735"
        staging = "subnet-02d7d3fc9888b1735"
        production = "subnet-02d7d3fc9888b1735"
    }

  private_subnet_id = "${lookup(local.private_subnet_env, local.env)}"

      public_subnet_env = {
        default = "subnet-046ceaa47fcdadf11"
        staging = "subnet-046ceaa47fcdadf11"
        production = "subnet-046ceaa47fcdadf11"
    }

  public_subnet_id = "${lookup(local.public_subnet_env, local.env)}"
}