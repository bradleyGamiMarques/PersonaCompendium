variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "billing_mode" {
  type        = string
  description = "The billing mode of the DynamoDB table"
}

variable "read_capacity" {
  type        = number
  description = "The read capacity units for the DynamoDB table"
}

variable "write_capacity" {
  type        = number
  description = "The write capacity units for the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "The hash key of the DynamoDB table"
}

variable "sort_key" {
  type        = string
  description = "The range key of the DynamoDB table"
}

variable "attributes" {
  description = "A list of attributes. Each attribute should have a name and type."
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "global_secondary_indexes" {
  description = "A list of maps defining global secondary indexes"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}
