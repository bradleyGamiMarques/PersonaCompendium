terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
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

resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  name = "APIGatewayCloudWatchLogsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy" "api_gateway_cloudwatch_policy" {
  name = "APIGatewayCloudWatchLogsPolicy"
  role = aws_iam_role.api_gateway_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_api_gateway_account" "cloudwatch_role" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

// AWS API Gateway
resource "aws_api_gateway_rest_api" "persona_compendium" {
  name        = "persona_compendium_${var.stage}"
  description = "API Gateway for Persona Compendium services"
  endpoint_configuration {
    types = ["EDGE"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

