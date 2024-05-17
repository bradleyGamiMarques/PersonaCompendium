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
