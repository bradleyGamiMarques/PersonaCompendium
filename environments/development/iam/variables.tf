variable "lambda_execution_role_id" {
  description = "id for lambda_execution_role"
}

variable "aws_region" {
  description = "Region where resources are located"
}

variable "aws_account_id" {
  description = "aws_account_id"
}

variable "p3r_personas_table_name" {
  description = "Name of the DynamoDB table where Persona 3 Reload Persona data is stored"
}

variable "get_p3r_persona_by_name_log_group_name" {
  description = "name of the log group for get_p3r_persona_by_name"
}

variable "get_p3r_personas_by_arcana_log_group_name" {
  description = "name of the log group for get_p3r_persona_by_name"
}
