provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = var.region
}

data "aws_availability_zones" "azs" {}  ## return zones available 

module "demo2-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.4.0"
    name = "demo2-vpc"
    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnet_cidr_blocks
    public_subnets = var.public_subnet_cidr_blocks
    azs = data.aws_availability_zones.azs.names
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true 

    tags = {
        "kubernetes.io/cluster/demo2-eks-cluster" = "shared "
    }
    public_subnet_tags = {
        "kubernetes.io/cluster/demo2-eks-cluster" = "shared "
        "kubernetes.io/role/elb" = 1
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/demo2-eks-cluster" = "shared "
        "kubernetes.io/role/internal-elb" = 1
    }

}