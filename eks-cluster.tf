provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:eu-west-3:211125306909:cluster/dev-cluster"
}


data "aws_eks_cluster" "dev-cluster" {
  name = "dev-cluster"
  depends_on = [ module.eks ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
   version = "~> 20.0"
  cluster_name = "dev-cluster"

  cluster_endpoint_public_access = true
  create_cni_ipv6_iam_policy = true
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


  vpc_id = module.dev-vpc.vpc_id
  subnet_ids = module.dev-vpc.private_subnets
  control_plane_subnet_ids = module.dev-vpc.intra_subnets
  
  
  tags = {
    environment = "development"
    application = "dev"
  }

    eks_managed_node_groups = {
        nodegroup1 = {
        name          = "nodegroup1"
        min_size      = 1
        max_size      = 5
        desired_size  = 1
        instance_type = "t2.micro"
    }
        nodegroup2 = {
            name          = "nodegroup2"
            min_size      = 1
            max_size      = 5
            desired_size  = 2
            instance_type= "t2.micro"
        }
    }

    
}

