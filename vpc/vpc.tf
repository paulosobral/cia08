module "turma08" {
    source = "terraform-aws-modules/vpc/aws"
    name = "turma-08"
    cidr = "10.0.0.0/16"

    azs = ["us-west-2a", "us-west-2a"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

    enable_nat_gateway = false
    enable_vpn_gateway = false
    enable_dns_hostnames = true

    tags = {}
}