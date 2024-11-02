module "basic" {
  source = "./modules/basic"
}

module "resource_name_basic" {
  source = "./modules/resource_name_basic"
}

module "resource_name_advanced" {
  source = "./modules/resource_name_advanced"
}

module "complex_type" {
  source = "./modules/complex_type"
}

output "basic" {
  value = module.basic.example
}

output "resource_name_basic" {
  value = module.resource_name_basic.example
}

output "resource_name_advanced" {
  value = module.resource_name_advanced.example
}

output "complex_type" {
  value = module.complex_type.example
}