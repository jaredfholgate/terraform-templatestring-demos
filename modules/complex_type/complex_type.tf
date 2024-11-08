variable "complex_object" {
  type = any
  default = {
    resource_group_names = {
      dev  = "rg-$${service}-$${environment_dev}-$${location}-$${number_01}"
      qa   = "rg-$${service}-$${environment_test}-$${location}-$${number_01}"
      prd1 = "rg-$${service}-$${environment_prod}-$${location}-$${number_01}"
      prd2 = "rg-$${service}-$${environment_prod}-$${location}-$${number_02}"
      prd3 = "rg-$${service}-$${environment_prod}-$${location}-$${number_03}"
    }
    nested_object = {
      name                = "level-01-$${service}-$${environment_dev}-$${location}-$${number_01}"
      custom_replacements = "level-01-custom-$${custom_01}-$${custom_02}-$${custom_03}"
      nested_object = {
        name = "level-02-$${service}-$${environment_dev}-$${location}-$${number_01}"
        nested_object = {
          name = "level-03-$${service}-$${environment_dev}-$${location}-$${number_01}"
          nested_object = {
            name = "level-04-$${service}-$${environment_dev}-$${location}-$${number_01}"
          }
        }
      }
    }
  }
}

variable "custom_replacements" {
  type = map(any)
  default = {
    custom_01 = "hello"
    custom_02 = "world"
    custom_03 = 123
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
  # Create a map of numbers to be used in the replacements.
  numbers    = range(var.seed_number, var.seed_number + var.total_numbers_to_create)
  number_map = { for number in local.numbers : "number_${format("%02d", number)}" => format("%0${var.number_padding}d", number) }
}

locals {
  # Rename the environments map key to match the format of the resource_group_names map.
  environments = { for env, env_name in var.environments : "environment_${env}" => env_name }
}

locals {
  # Form the final replacements map. The custom replacements are added last to the merge method so they can override any other key if desired.
  replacements = merge(local.number_map, local.environments, {
    service  = var.service_name,
    location = var.location,
  }, var.custom_replacements)
}

locals {
  # This is the crux of the example. We are converting the complex object to a JSON string, templating it, and then converting it back to a complex object.
  complex_object_json           = jsonencode(var.complex_object)
  complex_object_json_templated = templatestring(local.complex_object_json, local.replacements)
  complex_object                = jsondecode(local.complex_object_json_templated)
  # NOTE: We are not doing this on a single line due to a bug in Terraform that causes it to fail. Try it if you don't beleive me. :)
}

output "example" {
  value = local.complex_object
}
