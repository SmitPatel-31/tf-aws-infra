resource "aws_launch_template" "web_app" {
  name_prefix   = "csye6225"
  image_id      = var.custom_ami
  instance_type = "t2.micro"
  key_name      = "demo"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]

  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${var.db_secret_name} --region ${var.region} --query SecretString --output text | jq -r .password)

    echo "DB_NAME=${aws_db_instance.postgres_instance.db_name}" >> /etc/environment
    echo "DB_USER=${aws_db_instance.postgres_instance.username}" >> /etc/environment
    echo "DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
    echo "DB_HOST=${aws_db_instance.postgres_instance.address}" >> /etc/environment
    echo "DB_DIALECT=${var.db_dialect}" >> /etc/environment

    echo "AWS_REGION=${var.region}" >> /etc/environment
    echo "S3_BUCKET=${aws_s3_bucket.private_bucket.bucket}" >> /etc/environment
    source /etc/environment
    sudo apt install -y postgresql-client
    sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
    sudo cp /home/csye6225/app/cloudwatch-config.json /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json
    sudo chown csye6225:csye6225 /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json
    sudo chmod 644 /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json

    # Apply CloudWatch Agent Configuration
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config \
        -m ec2 \
        -c file:/opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json \
        -s

    # Enable and start CloudWatch Agent service
    sudo systemctl enable amazon-cloudwatch-agent
    sudo systemctl restart amazon-cloudwatch-agent

  EOF
  )

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ec2_key.arn
      volume_size = 20
    }
  }
}

resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity    = 3
  min_size            = 3
  max_size            = 5
  vpc_zone_identifier = flatten([for subnet in aws_subnet.public : subnet.id])

  launch_template {
    id      = aws_launch_template.web_app.id
    version = aws_launch_template.web_app.latest_version

  }

  health_check_type         = "ELB"
  health_check_grace_period = 250

  tag {
    key                 = "Demo"
    value               = "web-app-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = var.scale_up_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = var.scale_down_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Alarm when CPU usage is above 10%"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale-down-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 8
  alarm_description   = "Alarm when CPU usage is below 8%"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }
}


resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.id
  lb_target_group_arn    = aws_lb_target_group.web_tg.arn
}