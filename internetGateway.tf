resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
  provisioner "local-exec" {
    command = "echo 'Internet Gateway created'"
  }
}

### route_tables.tf
