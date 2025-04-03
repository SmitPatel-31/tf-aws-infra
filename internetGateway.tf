resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway_name
  }
  provisioner "local-exec" {
    command = "echo 'Internet Gateway created'"
  }
}

### route_tables.tf
