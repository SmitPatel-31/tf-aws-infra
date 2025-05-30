resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }

  provisioner "local-exec" {
    command = "echo 'VPC created with CIDR: ${var.vpc_cidr}'"
  }
}
