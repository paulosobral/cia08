variable "project" {
    type = string
    default = "turma08"
}

variable "cidr_block" {
  type = string
  default = "10.0.101.0/24"
}

variable "instance_type_app" {
  type = map
  default = {
    dev = "t2.micro"
    qa = "t3.large"
    prod = "t3.medium"
  }
}

variable "instance_type_mongodb" {
  type = string
  default = "t2.small"
}
variable "vpc_name" {
  type = string
  default = "turma-08"
}