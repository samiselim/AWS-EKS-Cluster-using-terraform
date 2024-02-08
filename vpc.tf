provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = var.region
}

module "dev-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.4.0"
    name = "dev-vpc"
    cidr = "10.0.0.0/16"

    azs             = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

    single_nat_gateway = true
    enable_nat_gateway = true
    enable_dns_hostnames = true 

    tags = {
        "kubernetes.io/cluster/dev-cluster" = "shared "
    }
    public_subnet_tags = {
        "kubernetes.io/cluster/dev-cluster" = "shared "
        "kubernetes.io/role/elb" = 1
    }
    private_subnet_tags = {
        "kubernetes.io/cluster/dev-cluster" = "shared "
        "kubernetes.io/role/internal-elb" = 1
    }

}