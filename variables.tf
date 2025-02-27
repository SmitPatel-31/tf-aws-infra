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