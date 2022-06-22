output "nome_da_vpc" {
    value = module.turma08.public_subnet_arns
}

output "subnet" {
    value = var.cidr_subnet_public[1]
}