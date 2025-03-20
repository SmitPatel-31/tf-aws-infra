# Terraform Infrastructure Setup

## Overview
This project provisions cloud infrastructure using Terraform. It automates the setup of networking, IAM policies, an S3 bucket, and an RDS database instance.

## Learning Objectives
The objective of this assignment is to:
- Auto-configure a web application with database server details.
- Enable auto-start for the service without manual intervention.
- Implement Infrastructure as Code (IaC) using Terraform.
- Configure IAM roles and policies.
- Set up an S3 bucket with encryption and lifecycle policies.
- Deploy an RDS instance with a secure security group and parameter group.

## Project Structure
```
.
├── provider.tf          # AWS provider configuration
├── variables.tf         # Terraform variables
├── vpc.tf              # VPC definition
├── subnets.tf          # Public and private subnets
├── internet_gateway.tf # Internet gateway setup
├── route_tables.tf     # Route tables and associations
├── data_sources.tf     # Data sources for availability zones
├── iam.tf              # IAM roles and policies
├── rds.tf              # RDS instance configuration
├── s3.tf               # S3 bucket setup
├── .github/
│   └── workflows/
│       └── terraform-ci.yml  # GitHub Actions workflow for Terraform CI
└── README.md          # Documentation
```

## Infrastructure Components

### 1. IAM Roles & Policies
- Define necessary permissions for the infrastructure.
- Create IAM roles and policies required for EC2, RDS, and S3.

### 2. S3 Bucket
- Create a private S3 bucket with a UUID as the bucket name.
- Enable default encryption for secure storage.
- Implement a lifecycle policy to transition objects from `STANDARD` to `STANDARD_IA` after 30 days.
- Ensure Terraform can delete the bucket even if it is not empty.

### 3. Security Groups
#### Database Security Group:
- Allow TCP traffic on **port 5432** (PostgreSQL) or **3306** (MySQL/MariaDB).
- Restrict access to only allow traffic from the application security group.
- Block public access to the database.

### 4. RDS Parameter Group
- Create a parameter group for PostgreSQL, MySQL, or MariaDB.
- Attach it to the RDS instance.

### 5. RDS Instance
- Deploy an RDS instance with the following configuration:
  - **Engine**: PostgreSQL/MySQL/MariaDB
  - **Instance Class**: Cheapest available
  - **Multi-AZ Deployment**: No
  - **Instance Identifier**: `csye6225`
  - **Master Username**: `csye6225`
  - **Master Password**: Securely stored in a secrets manager
  - **Subnet Group**: Private subnets only
  - **Public Accessibility**: No
  - **Database Name**: `csye6225`
  - **Security Group**: Attach the database security group

## Deployment Instructions

### Prerequisites
Ensure you have the following installed:
- Terraform
- AWS CLI (configured with the appropriate IAM credentials)

### Steps to Deploy
1. **Initialize Terraform**
   ```sh
   terraform init
   ```
2. **Validate Configuration**
   ```sh
   terraform validate
   ```
3. **Plan Deployment**
   ```sh
   terraform plan
   ```
4. **Apply Deployment**
   ```sh
   terraform apply -auto-approve
   ```
5. **Verify Infrastructure**
   - Check AWS Console to confirm resources are provisioned correctly.
   - Use `aws s3 ls` to verify the S3 bucket.
   - Use `aws rds describe-db-instances` to check the RDS instance.

### Destroy Infrastructure
To tear down the infrastructure when no longer needed:
```sh
terraform destroy -auto-approve
```

## CI/CD Pipeline
- **GitHub Actions** is used for Continuous Integration (CI) to validate Terraform configurations.
- The workflow file (`terraform-ci.yml`) runs Terraform `fmt`, `validate`, and `plan` on pull requests.

## Notes
- Ensure IAM roles and policies are correctly configured to avoid permission issues.
- Keep RDS credentials secure by storing them in AWS Secrets Manager.
- Avoid exposing the database to the public for security reasons.


