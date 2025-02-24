# Infrastructure as Code (IaC) with Terraform

## Overview
This repository contains Terraform configurations to provision AWS infrastructure, including VPCs, subnets, route tables, and an internet gateway. Additionally, it includes a GitHub Actions workflow to enforce Terraform best practices before merging changes.

## Directory Structure
```
.
├── provider.tf          # AWS provider configuration
├── variables.tf         # Terraform variables
├── vpc.tf              # VPC definition
├── subnets.tf          # Public and private subnets
├── internet_gateway.tf # Internet gateway setup
├── route_tables.tf     # Route tables and associations
├── data_sources.tf     # Data sources for availability zones
├── .github/
│   └── workflows/
│       └── terraform-ci.yml  # GitHub Actions workflow for Terraform CI
└── README.md          # Documentation
```

## Getting Started

1. **Initialize Terraform:**
   ```sh
   terraform init
   ```

2. **Validate Terraform configuration:**
   ```sh
   terraform validate
   ```

3. **Format Terraform code:**
   ```sh
   terraform fmt -recursive
   ```

4. **Plan and apply changes:**
   ```sh
   terraform plan
   terraform apply
   ```

## GitHub Actions CI Pipeline
A GitHub Actions workflow is set up to automatically validate Terraform code on each pull request.
