# resource "aws_instance" "web_app" {
#   ami                         = var.custom_ami # Custom AMI ID
#   instance_type               = "t2.micro"
#   subnet_id                   = element(aws_subnet.public[*].id, 0) # Launch in the first public subnet
#   vpc_security_group_ids      = [aws_security_group.app_sg.id]
#   associate_public_ip_address = true
#   disable_api_termination     = false # No protection against accidental termination
#   # iam_instance_profile        = aws_iam_instance_profile.s3_instance_profile.name
#   iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "web-app-instance"
#   }


#   user_data = <<-EOF
#     #!/bin/bash
#     echo "DB_NAME=${aws_db_instance.postgres_instance.db_name}" >> /etc/environment
#     echo "DB_USER=${aws_db_instance.postgres_instance.username}" >> /etc/environment
#     echo "DB_PASSWORD=${aws_db_instance.postgres_instance.password}" >> /etc/environment
#     echo "DB_HOST=${aws_db_instance.postgres_instance.address}" >> /etc/environment
#     echo "DB_DIALECT=${var.db_dialect}" >> /etc/environment

#     echo "AWS_REGION=${var.region}" >> /etc/environment
#     echo "S3_BUCKET=${aws_s3_bucket.private_bucket.bucket}" >> /etc/environment
#     source /etc/environment
#     sudo apt install -y postgresql-client
#     sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
#     sudo cp /home/csye6225/app/cloudwatch-config.json /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json
#     sudo chown csye6225:csye6225 /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json
#     sudo chmod 644 /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json

#     # Apply CloudWatch Agent Configuration
#     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
#         -a fetch-config \
#         -m ec2 \
#         -c file:/opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json \
#         -s

#     # Enable and start CloudWatch Agent service
#     sudo systemctl enable amazon-cloudwatch-agent
#     sudo systemctl restart amazon-cloudwatch-agent


#   EOF


#   provisioner "local-exec" {
#     command = "echo 'EC2 instance created with AMI: ${var.custom_ami}'"
#   }
# }
