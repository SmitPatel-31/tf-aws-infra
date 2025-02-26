resource "aws_instance" "web_app" {
  ami                         = var.custom_ami  # Custom AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.public[*].id, 0)  # Launch in the first public subnet
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  disable_api_termination     = false  # No protection against accidental termination

  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "web-app-instance"
  }

  provisioner "local-exec" {
    command = "echo 'EC2 instance created with AMI: ${var.custom_ami}'"
  }
}
