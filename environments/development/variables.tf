variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "persona_compendium_terraform_state_bucket" {
  description = "Name of the S3 bucket that holds our .tfstate file"
  type        = string
}

variable "key" {
  description = "Path to .tfstate file in S3"
  type        = string
}

variable "stage" {
  description = "Deployment environment stage"
  type        = string
}

variable "api_gateway_configuration_file" {
  description = "Path to the API Gateway configuration file"
  default     = "./api_gateway/main.tf"
}

variable "api_gateway_resources_file" {
  description = "Path to the API Gateway resources configuration file"
  default     = "./api_gateway/resources/main.tf"
}

variable "api_gateway_methods_file" {
  description = "Path to the API Gateway methods configuration file"
  default     = "./api_gateway/methods/main.tf"
}

variable "api_gateway_integrations_file" {
  description = "Path to the API Gateway integrations configuration file"
  default     = "./api_gateway/integrations/main.tf"
}
