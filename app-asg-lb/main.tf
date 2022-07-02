module "turma08_app_asg_lb" {
    source = "./modules/turma08_app_asg_lb"
    cidr_block1 = "10.0.101.0/24"
    cidr_block2 = "10.0.102.0/24"
    vpc_name = "turma-08"
    project = "turma-08-mod"
    env = "dev"
}