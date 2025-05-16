variable "kms_key_id" {}
variable "parameter_name" {}
variable "parameter_value" {}

resource "aws_ssm_parameter" "secure_param" {
  name        = var.parameter_name
  type        = "SecureString"
  value       = var.parameter_value
  key_id      = var.kms_key_id
  overwrite   = true
}

output "parameter_name" {
  value = aws_ssm_parameter.secure_param.name
}
