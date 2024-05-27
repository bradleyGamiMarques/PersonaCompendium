output "get_p3r_persona_by_name_log_group_name" {
  value = aws_cloudwatch_log_group.get_p3r_persona_by_name_log_group.name
}

output "get_p3r_personas_by_arcana_log_group_name" {
  value = aws_cloudwatch_log_group.get_p3r_personas_by_arcana_log_group.name
}
