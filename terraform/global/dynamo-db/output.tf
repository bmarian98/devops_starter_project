output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}

output "s3_name" {
  value = module.s3_tfstate.bucket_id
}