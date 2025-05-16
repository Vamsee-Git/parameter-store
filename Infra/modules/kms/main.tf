resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for encrypting SSM parameters"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

output "kms_key_arn" {
  value = aws_kms_key.ssm_key.arn
}
