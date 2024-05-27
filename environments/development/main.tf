terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  api_gateway_config_file_hash       = filesha1(var.api_gateway_configuration_file)
  api_gateway_resources_file_hash    = filesha1(var.api_gateway_resources_file)
  api_gateway_methods_file_hash      = filesha1(var.api_gateway_methods_file)
  api_gateway_integrations_file_hash = filesha1(var.api_gateway_integrations_file)
}
locals {
  combined_hash = sha1(join("", [local.api_gateway_config_file_hash, local.api_gateway_resources_file_hash, local.api_gateway_methods_file_hash, local.api_gateway_integrations_file_hash]))
}
// DynamoDB Tables
module "persona_3_reload_personas_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_personas_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "Arcana"
  sort_key       = "PersonaLevel"
  attributes = [
    {
      name = "Arcana"
      type = "S"
    },
    {
      name = "PersonaLevel"
      type = "N"
    },
    {
      name = "PersonaName"
      type = "S"
    },
  ]
  global_secondary_indexes = [
    {
      name               = "PersonaIndex"
      hash_key           = "PersonaName"
      range_key          = null
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    },
  ]
}

module "persona_3_reload_skills_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_skills_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "Skill"
  sort_key       = null
  attributes = [
    {
      name = "Skill"
      type = "S"
    },
    {
      name = "SkillCategory"
      type = "S"
    },
    {
      name = "CategoryOrder"
      type = "N"
    }
  ]
  global_secondary_indexes = [
    {
      name               = "SkillCategoryIndex"
      hash_key           = "SkillCategory"
      range_key          = "CategoryOrder"
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    }
  ]
}
module "persona_3_reload_persona_skills_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_persona_skills_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "Skill"
  sort_key       = "PersonaLevel"
  attributes = [
    {
      name = "Skill"
      type = "S"
    },
    {
      // Example Key: Orpheus#3
      name = "PersonaLevel"
      type = "S"
    }
  ]
}

module "persona_3_reload_persona_weaknesses_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_persona_weaknesses_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "SkillCategory"
  sort_key       = "PersonaName"
  attributes = [
    {
      name = "SkillCategory"
      type = "S"
    },
    {
      // Example Key: Orpheus
      name = "PersonaName"
      type = "S"
    }
  ]
}

module "persona_3_reload_persona_resistances_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_persona_resistances_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "SkillCategory"
  sort_key       = "PersonaName"
  attributes = [
    {
      name = "SkillCategory"
      type = "S"
    },
    {
      // Example Key: Orpheus
      name = "PersonaName"
      type = "S"
    }
  ]
}
module "persona_3_reload_persona_blocks_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_persona_blocks_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "SkillCategory"
  sort_key       = "PersonaName"
  attributes = [
    {
      name = "SkillCategory"
      type = "S"
    },
    {
      // Example Key: Orpheus
      name = "PersonaName"
      type = "S"
    }
  ]
}
module "persona_3_reload_persona_repels_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_persona_repels_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "SkillCategory"
  sort_key       = "PersonaName"
  attributes = [
    {
      name = "SkillCategory"
      type = "S"
    },
    {
      // Example Key: Orpheus
      name = "PersonaName"
      type = "S"
    }
  ]
}
module "persona_3_reload_persona_inherits_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_persona_inherits_${var.stage}"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "SkillCategory"
  sort_key       = "PersonaName"
  attributes = [
    {
      name = "SkillCategory"
      type = "S"
    },
    {
      // Example Key: Orpheus
      name = "PersonaName"
      type = "S"
    }
  ]
}

// Lambda Execution Role
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

module "cloudwatch" {
  source = "./cloudwatch"
  stage  = var.stage
}
module "iam" {
  source                                    = "./iam"
  lambda_execution_role_id                  = aws_iam_role.lambda_execution_role.id
  aws_region                                = var.aws_region
  aws_account_id                            = data.aws_caller_identity.current.account_id
  p3r_personas_table_name                   = module.persona_3_reload_personas_table.table_name
  get_p3r_persona_by_name_log_group_name    = module.cloudwatch.get_p3r_persona_by_name_log_group_name
  get_p3r_personas_by_arcana_log_group_name = module.cloudwatch.get_p3r_personas_by_arcana_log_group_name
}
module "lambdas" {
  source                                    = "./lambda"
  lambda_execution_role_arn                 = aws_iam_role.lambda_execution_role.arn
  dynamodb_table_name                       = module.persona_3_reload_personas_table.table_name
  get_p3r_persona_by_name_log_group_name    = module.cloudwatch.get_p3r_persona_by_name_log_group_name
  get_p3r_personas_by_arcana_log_group_name = module.cloudwatch.get_p3r_personas_by_arcana_log_group_name
}
module "api_gateway_configuration" {
  source = "./api_gateway"
  stage  = var.stage
}

module "api_gateway_resources" {
  source           = "./api_gateway/resources"
  rest_api_id      = module.api_gateway_configuration.rest_api_id
  root_resource_id = module.api_gateway_configuration.root_resource_id
}

module "api_gateway_methods" {
  source                   = "./api_gateway/methods"
  rest_api_id              = module.api_gateway_configuration.rest_api_id
  persona_name_resource_id = module.api_gateway_resources.persona_name_resource_id
  personas_resource_id     = module.api_gateway_resources.personas_resource_id
}

module "api_gateway_integrations" {
  source                                             = "./api_gateway/integrations"
  rest_api_id                                        = module.api_gateway_configuration.rest_api_id
  persona_name_resource_id                           = module.api_gateway_resources.persona_name_resource_id
  personas_resource_id                               = module.api_gateway_resources.personas_resource_id
  v1_get_p3r_personas_by_arcana_http_method          = module.api_gateway_methods.v1_get_p3r_personas_by_arcana_http_method
  v1_get_p3r_persona_by_name_http_method             = module.api_gateway_methods.v1_get_p3r_persona_by_name_http_method
  persona_name_path                                  = module.api_gateway_resources.persona_name_path
  personas_path                                      = module.api_gateway_resources.personas_path
  aws_account_id                                     = data.aws_caller_identity.current.account_id
  aws_region                                         = var.aws_region
  v1_get_p3r_persona_by_name_lambda_function_name    = module.lambdas.v1_get_p3r_persona_by_name_function_name
  v1_get_p3r_persona_by_name_lambda_invoke_arn       = module.lambdas.v1_get_p3r_persona_by_name_invoke_arn
  v1_get_p3r_personas_by_arcana_lambda_function_name = module.lambdas.v1_get_p3r_personas_by_arcana_function_name
  v1_get_p3r_personas_by_arcana_lambda_invoke_arn    = module.lambdas.v1_get_p3r_personas_by_arcana_invoke_arn
}

module "api_gateway_deployment" {
  source                                           = "./api_gateway/deployment"
  stage                                            = var.stage
  rest_api_id                                      = module.api_gateway_configuration.rest_api_id
  v1_get_p3r_persona_by_name_method                = module.api_gateway_methods.v1_get_p3r_persona_by_name
  v1_get_p3r_personas_by_arcana_method             = module.api_gateway_methods.v1_get_p3r_personas_by_arcana
  v1_get_p3r_persona_by_name_lambda_integration    = module.api_gateway_integrations.v1_get_p3r_persona_by_name_lambda_integration
  v1_get_p3r_personas_by_arcana_lambda_integration = module.api_gateway_integrations.v1_get_p3r_personas_by_arcana_lambda_integration
  resource_v1                                      = module.api_gateway_resources.resource_v1
  resource_p3r                                     = module.api_gateway_resources.resource_p3r
  resource_persona                                 = module.api_gateway_resources.resource_persona
  resource_persona_name                            = module.api_gateway_resources.resource_persona_name
  resource_arcana                                  = module.api_gateway_resources.resource_arcana
  combined_hash                                    = local.combined_hash
}
