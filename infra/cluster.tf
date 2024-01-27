module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${local.username}-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_attributes.id
  subnet_ids = data.aws_subnets.private.ids

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.kill_pod.arn
      username = "fis-pod-manager"
      groups   = ["system:masters"]
    },
  ]

  eks_managed_node_groups = {
    main = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      labels = {
        "chaos/node-label" : "main"
      }
      tags = {
        "node-label" : "main"
      }
    }
    stuff = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      labels = {
        "chaos/node-label" : "stuff"
      }
      tags = {
        "node-label" : "stuff"
      }
    }
  }

  tags = {
    Owner = local.username
  }
}
