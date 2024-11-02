variable "resource_group_name" {
  type    = string
  default = "rg-$${service}-$${environment}-$${location}-$${number_01}"
}

variable "service_name" {
  type    = string
  default = "demo"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "number_01" {
  type    = number
  default = 1
}

locals {
  resource_group_name = templatestring(var.resource_group_name, {
    service     = var.service_name,
    environment = var.environment,
    location    = var.location,
    number_01   = var.number_01
  })
}

output "example" {
  value = local.resource_group_name
}