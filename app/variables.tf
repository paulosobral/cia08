variable "project" {
    type = string
    default = "turma08"
}

variable "env" {
    type = string
    default = "dev"
}

variable "cidr_block" {
  type = string
  default = "10.0.101.0/24"
}

variable "vpc_name" {
  type = string
  default = "turma-08"
}