module "turma08" {
    source = "terraform-aws-modules/vpc/aws"
    name = var.vpc_name
    cidr = "10.0.0.0/16"

    azs = ["us-west-2a", "us-west-2a"]
    public_subnets = var.cidr_subnet_public

    enable_nat_gateway = false
    enable_vpn_gateway = false
    enable_dns_hostnames = true

    tags = var.labels
}
