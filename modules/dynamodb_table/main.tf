resource "aws_dynamodb_table" "table" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.sort_key
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes

      # Read and Write capacity units need to be specified here if your table's billing_mode is PROVISIONED
      # Otherwise, these should be omitted for PAY_PER_REQUEST
      # read_capacity  = global_secondary_index.value.read_capacity
      # write_capacity = global_secondary_index.value.write_capacity
    }
  }
}
