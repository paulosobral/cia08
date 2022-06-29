module "turma08_app" {
    source = "./modules/turma08_app"
    cidr_block = var.cidr_block
    vpc_name = "turma-08"
    project = "turma-08-modulo"
    env = var.env
    create_zone_dns = "true"
}

output "ip_app" {
    value = module.turma08_app.app_public_ip
}

variable "cidr_block" {
    type = string
    default = "10.0.101.0/24"
}

variable "env" {
  type = string
}

variable "create_zone_dns" {
  type = bool
  default = true
}