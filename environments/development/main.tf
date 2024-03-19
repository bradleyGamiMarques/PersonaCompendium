terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
  profile = "bradley-marques-developer"
  region  = "us-west-1"
}

module "persona_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "persona_table_development"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = null
  write_capacity = null
  hash_key       = "Persona"
  sort_key       = "Arcana"
  attributes = [
    {
      name = "Persona"
      type = "S"
    },
    {
      name = "Arcana"
      type = "S"
    },
    {
      name = "Level"
      type = "N"
    }
  ]
  global_secondary_indexes = [
    {
      name               = "ArcanaLevelIndex"
      hash_key           = "Arcana"
      range_key          = "Level"
      projection_type    = "ALL"
      non_key_attributes = []
    }
  ]
}
