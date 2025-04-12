resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = true
}
resource "aws_secretsmanager_secret" "db_password" {
  name       = var.db_secret_name
  kms_key_id = data.aws_kms_key.secret_manager.arn
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = random_password.db.result
  })
}




resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "private-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "private-subnet-group"
  }
}
resource "aws_db_parameter_group" "postgres_params" {
  name   = "postgres-parameter-group"
  family = "postgres16"

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot" # Fixes the error
  }
  parameter {
    name         = "rds.force_ssl" # Disable SSL enforcement
    value        = "0"
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "postgres-parameter-group"
  }
}

resource "aws_db_instance" "postgres_instance" {
  identifier             = "csye6225-postgres"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  multi_az               = false
  publicly_accessible    = false
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db.result
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  parameter_group_name   = aws_db_parameter_group.postgres_params.name
  skip_final_snapshot    = true

  storage_encrypted = true
  kms_key_id        = data.aws_kms_key.rds_key.arn

  tags = {
    Name = "csye6225-postgres"
  }
}
