provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-vamsee"
    key            = "terraform/parameter/statefile"
    region         = "us-west-1"
    encrypt        = true
  }
}

module "kms" {
  source = "./modules/kms"
}

module "ssm" {
  source          = "./modules/ssm"
  kms_key_id      = module.kms.kms_key_arn
  parameter_name  = "/myapp/db-password"
  parameter_value = "SuperSecret123!"
}

module "sns" {
  source = "./modules/sns"
  email  = "jorepalli.vamsee@hcltech.com"
}

module "eventbridge" {
  source        = "./modules/eventbridge"
  sns_topic_arn = module.sns.sns_topic_arn
}

module "lambda" {
  source      = "./modules/lambda"
  kms_key_arn = module.kms.kms_key_arn
}
