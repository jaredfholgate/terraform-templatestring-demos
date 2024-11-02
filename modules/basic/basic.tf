locals {
  templated_string = "Hello $${world_placeholder}"

  replacements = {
    world_placeholder = "World"
  }

  final_string = templatestring(local.templated_string, local.replacements)
}

output "example" {
  value = local.final_string
}