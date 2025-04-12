data "aws_kms_alias" "ec2_key_alias" {
  name = "alias/EC2"
}

data "aws_kms_key" "ec2_key" {
  key_id = data.aws_kms_alias.ec2_key_alias.target_key_id
}

data "aws_kms_alias" "rds_key_alias" {
  name = "alias/RDS"
}
data "aws_kms_key" "rds_key" {
  key_id = data.aws_kms_alias.rds_key_alias.target_key_id
}
data "aws_kms_alias" "s3_key_alias" {
  name = "alias/s3"
}
data "aws_kms_key" "s3_key" {
  key_id = data.aws_kms_alias.s3_key_alias.target_key_id
}

data "aws_kms_alias" "secret_manager_alias" {
  name = "alias/Secret-Manager"
}

data "aws_kms_key" "secret_manager" {
  key_id = data.aws_kms_alias.secret_manager_alias.target_key_id
}
