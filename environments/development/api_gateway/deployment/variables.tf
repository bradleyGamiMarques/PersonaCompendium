variable "stage" {
  description = "Deployment environment stage"
  type        = string
}

variable "rest_api_id" {
  description = "Rest api id of api gateway"
  type        = string
}

variable "combined_hash" {
  description = "filesha1 hash of resources for triggering redeploy"
  type        = string
}

variable "resource_v1" {
  description = "v1 resource"
}

variable "resource_p3r" {
  description = "p3r resource"
}

variable "resource_persona" {
  description = "persona resource"
}

variable "resource_persona_name" {
  description = "persona_name resource"
}

variable "resource_arcana" {
  description = "arcana resource"
}

variable "v1_get_p3r_persona_by_name_method" {
  description = "v1_get_p3r_persona_by_name_method"
}

variable "v1_get_p3r_personas_by_arcana_method" {
  description = "v1_get_p3r_personas_by_arcana_method"
}

variable "v1_get_p3r_persona_by_name_lambda_integration" {
  description = "v1_get_p3r_persona_by_lambda_integration"
}

variable "v1_get_p3r_personas_by_arcana_lambda_integration" {
  description = "v1_get_p3r_personas_by_arcana_lambda_integration"
}
