variable "region" {
  description = "AWS region"

}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"

}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}
variable "aws_profile" {
  description = "AWS CLI profile to use"
}

variable "custom_ami" {
  description = "Custom AMI ID for EC2 instance"
  type        = string
}
variable "db_dialect" {
  description = "Database dialect"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
}
variable "db_name" {
  description = "Database name"
  type        = string
}
variable "db_username" {
  description = "Database user"
  type        = string
}


variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "web-alb"

}


variable "health_check_path" {
  description = "Health check path for the load balancer"
  type        = string
  default     = "/healthz"

}


variable "autoscalling_instance_profile_name" {
  description = "Autoscaling instance profile"
  type        = string
  default     = "autoscaling-instance-profile"

}

variable "scale_up_adjustment" {
  description = "Scale up adjustment"
  type        = number
  default     = 1

}

variable "scale_down_adjustment" {
  description = "Scale down adjustment"
  type        = number
  default     = -1

}

variable "ec2_instance_profile_name" {
  description = "EC2 instance profile name"
  type        = string
  default     = "ec2-instance-profile"

}

variable "internet_gateway_name" {
  description = "Name of the internet gateway"
  type        = string
  default     = "main-internet-gateway"

}

variable "db_instance_class" {
  description = "name of the instance class"
  type        = string
  default     = "db.t3.micro"
}


variable "zone_id" {
  description = "Route53 zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Route53"
  type        = string
  default     = "dev.fetchme.me"
}


variable "dns_type" {
  description = "DNS type for Route53"
  type        = string
  default     = "A"

}


variable "db_sg_name" {
  description = "Name of the database security group"
  type        = string
  default     = "database-security-group"
}
variable "demo_zone_id" {
  description = "Route53 zone ID for demo"
  type        = string
}

variable "dev_zone_id" {
  description = "Route53 zone ID for dev"
  type        = string

}

variable "db_secret_name" {
  description = "Name of the database secret"
  type        = string
}