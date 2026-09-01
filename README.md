# QR Code App AWS Infrastructure (`qr-code-app-infra`)

Automated AWS infrastructure deployment for the **QR Code Generator Application** using **Terraform**.

---

## App code

- https://github.com/rocketonthemoon/qr-code-app

## Overview

This repository contains modularized Infrastructure-as-Code (IaC) written in Terraform to provision a high-availability, containerized microservices architecture on AWS.

The architecture provisions a public-facing Application Load Balancer (ALB) routing traffic to Next.js frontend tasks and Python FastAPI backend tasks running on AWS ECS Fargate inside private subnets, linked via ECS Service Connect for private inter-service communication.

---

## Infrastructure Architecture

```
                                  +------------------------------------+
                                  |       Internet Traffic (HTTP)      |
                                  +------------------------------------+
                                                    |
                                                    v
                                  +------------------------------------+
                                  |     Application Load Balancer      |
                                  |         (Public Subnets)           |
                                  +------------------------------------+
                                                    |
                                                    v
                                  +------------------------------------+
                                  |    ECS Fargate Frontend App Task   |
                                  |         (Private Subnets)          |
                                  +------------------------------------+
                                                    |
                                        Service Connect (Port 8000)
                                                    v
                                  +------------------------------------+
                                  |      ECS Fargate API Task          |
                                  |         (Private Subnets)          |
                                  +------------------------------------+
                                                    |
                                                    v
                                  +------------------------------------+
                                  |        Amazon S3 Bucket            |
                                  |      (QR Code PNG Storage)         |
                                  +------------------------------------+
```

---

## Repository Directory Structure

```text
qr-code-app/
├── environments/
│   └── dev/                        # Environment configuration for Development
│       ├── main.tf                 # Environment root module calls
│       ├── variables.tf            # Input variable declarations
│       ├── locals.tf               # Environment variables mappings for ECS containers
│       ├── outputs.tf              # Environment outputs
│       ├── terraform.tfvars        # Active variable values (gitignored)
│       └── terraform.tfvars.example# Example variable template
└── modules/
    ├── alb/                        # Application Load Balancer, SG & Target Groups
    ├── ecs/                        # ECS Cluster, Fargate Task Definitions, Services & Service Connect
    ├── iam/                        # IAM Roles & Policies for ECS Execution and Task Roles
    ├── networking/                 # VPC, Public/Private Subnets, IGW, NAT Gateway & Route Tables
    ├── s3-bucket/                  # S3 Bucket for QR Code images with AES256 encryption
    └── secretmanager/              # Secrets Manager for private registry credentials (GHCR)
```

---

## Modules Overview

- **[`alb`](modules/alb/Readme.md):** Provisions an AWS Application Load Balancer in public subnets with HTTP listener rules and target groups routing to frontend app tasks on port `3000`.
- **[`ecs`](modules/ecs/Readme.md):** Manages the ECS Fargate cluster, CloudWatch log groups (`/ecs/qr-code-app-dev-app` and `/ecs/qr-code-app-dev-api`), Fargate task definitions, and ECS Service Connect for private service discovery.
- **[`iam`](modules/iam/Readme.md):** Defines the ECS task execution role (Secrets Manager & CloudWatch logging) and task role (S3 bucket read/write permissions).
- **[`networking`](modules/networking/Readme.md):** Creates a custom VPC (`10.0.0.0/16`) spanning 2 Availability Zones, containing 2 public subnets, 2 private subnets, an Internet Gateway, and a NAT Gateway with an Elastic IP.
- **[`s3-bucket`](modules/s3-bucket/Readme.md):** Configures an S3 bucket with default AES256 server-side encryption and public access block enabled.
- **[`secretmanager`](modules/secretmanager/Readme.md):** Manages registry credentials in AWS Secrets Manager for pulling private container images from GitHub Container Registry.

---

## Prerequisites

- **Terraform:** `>= 1.0.0`
- **AWS Provider:** `>= 6.62.0`
- **AWS CLI:** Configured with appropriate AWS credentials (`aws configure`)

---

## Deployment Instructions

### 1. Change to the target environment directory

```bash
cd environments/dev
```

### 2. Configure variables

Copy the example variables template and populate it with your environment values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill in required credentials and values in `terraform.tfvars`:
- `registry_username`: Container registry username (e.g. GitHub username)
- `registry_password`: Container registry personal access token / password
- `app_container_image`: Frontend container image URI
- `api_container_image`: API container image URI

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Deployment Plan

```bash
terraform plan
```

### 5. Apply Infrastructure Changes

```bash
terraform apply
```

---

## Destruction / Cleanup Notes

To destroy deployed resources:

```bash
terraform destroy
```

> [!NOTE]
> AWS Secrets Manager retains deleted secrets in a recovery window (default 7 days) even after `terraform destroy` completes.
