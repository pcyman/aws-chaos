module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.2.0"

  name                             = "${local.username}-vpc"
  cidr_block                       = "10.0.0.0/16"
  vpc_egress_only_internet_gateway = true
  az_count                         = 2

  subnets = {
    public = {
      name_prefix               = "${local.username}-public-subnet"
      netmask                   = 24
      nat_gateway_configuration = "all_azs"
      tags = {
        Tier = "Public"
      }
    }
    private = {
      name_prefix             = "${local.username}-private-subnet"
      netmask                 = 24
      connect_to_public_natgw = true
      tags = {
        Tier = "Private"
      }
    }
  }

  tags = {
    Owner = local.username
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_attributes.id]
  }

  depends_on = [module.vpc]

  tags = {
    Tier = "Private"
  }
}
