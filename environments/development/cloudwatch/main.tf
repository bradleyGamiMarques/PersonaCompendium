resource "aws_cloudwatch_log_group" "get_p3r_persona_by_name_log_group" {
  name              = "get_p3r_persona_by_name_log_group_${var.stage}"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "get_p3r_personas_by_arcana_log_group" {
  name              = "get_p3r_personas_by_arcana_log_group_${var.stage}"
  retention_in_days = 7
}
