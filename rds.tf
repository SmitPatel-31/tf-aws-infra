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
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  multi_az               = false
  publicly_accessible    = false
  db_name                = "cloud"
  username               = "cloud"
  password               = "Cloud123!"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  parameter_group_name   = aws_db_parameter_group.postgres_params.name
  skip_final_snapshot    = true

  tags = {
    Name = "csye6225-postgres"
  }
}
