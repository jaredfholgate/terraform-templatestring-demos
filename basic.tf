locals {
  basic_templated_string = "Hello $${world_placeholder}"
  
  basic_replacements = {
    world_placeholder = "World"
  }

  basic_final_string = templatestring(local.basic_templated_string, local.basic_replacements)
}

output "basic" {
  value = local.basic_final_string
}