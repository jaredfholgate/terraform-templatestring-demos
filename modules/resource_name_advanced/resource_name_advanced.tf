variable "resource_group_names" {
  type = map(string)
  default = {
    dev  = "rg-$${service}-$${environment_dev}-$${location}-$${number_01}"
    qa   = "rg-$${service}-$${environment_test}-$${location}-$${number_01}"
    prd1 = "rg-$${service}-$${environment_prod}-$${location}-$${number_01}"
    prd2 = "rg-$${service}-$${environment_prod}-$${location}-$${number_02}"
    prd3 = "rg-$${service}-$${environment_prod}-$${location}-$${number_03}"
  }
}

variable "service_name" {
  type    = string
  default = "demo"
}

variable "environments" {
  type = map(string)
  default = {
    dev  = "dev"
    test = "test"
    prod = "prod"
  }
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "seed_number" {
  type    = number
  default = 1
}

variable "number_padding" {
  type    = number
  default = 3
}

variable "total_numbers_to_create" {
  type    = number
  default = 10
}

locals {
  numbers      = range(var.seed_number, var.seed_number + var.total_numbers_to_create)
  number_map   = { for number in local.numbers : "number_${format("%02d", number)}" => format("%0${var.number_padding}d", number) }
  environments = { for env, env_name in var.environments : "environment_${env}" => env_name }
  replacements = merge(local.number_map, local.environments, {
    service  = var.service_name,
    location = var.location,
  })

  resource_group_names = { for key, value in var.resource_group_names : key => templatestring(value, local.replacements) }
}

output "example" {
  value = local.resource_group_names
}