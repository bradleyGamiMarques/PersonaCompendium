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

module "persona_3_reload_personas_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_personas_dev"
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
    {
      name = "Strength"
      type = "N"
    },
    {
      name = "Magic"
      type = "N"
    },
    {
      name = "Endurance"
      type = "N"
    },
    {
      name = "Agility"
      type = "N"
    },
    {
      name = "Luck"
      type = "N"
    }
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
    {
      name               = "StrengthIndex"
      hash_key           = "Strength"
      range_key          = "PersonaLevel"
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    },
    {
      name               = "MagicIndex"
      hash_key           = "Magic"
      range_key          = "PersonaLevel"
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    },
    {
      name               = "EnduranceIndex"
      hash_key           = "Endurance"
      range_key          = "PersonaLevel"
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    },
    {
      name               = "AgilityIndex"
      hash_key           = "Agility"
      range_key          = "PersonaLevel"
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    },
    {
      name               = "LuckIndex"
      hash_key           = "Luck"
      range_key          = "PersonaLevel"
      projection_type    = "ALL"
      non_key_attributes = []
      read_capacity      = null
      write_capacity     = null
    },
  ]
}

module "persona_3_reload_skills_table" {
  source         = "../../modules/dynamodb_table"
  table_name     = "p3r_skills_dev"
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
  table_name     = "p3r_persona_skills_dev"
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
  table_name     = "p3r_persona_weaknesses_dev"
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
  table_name     = "p3r_persona_resistances_dev"
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
  table_name     = "p3r_persona_blocks_dev"
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
  table_name     = "p3r_persona_repels_dev"
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
  table_name     = "p3r_persona_inherits_dev"
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
