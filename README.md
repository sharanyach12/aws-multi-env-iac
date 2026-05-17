# aws-multi-env-iac

Production-grade Terraform and CloudFormation templates for deploying scalable, secure AWS infrastructure across multiple environments (DEV / QA / UAT / PROD).

Built from real-world patterns used at enterprise scale — designed to be reusable, environment-agnostic, and CI/CD-ready.

---

## What this repo covers

- Multi-environment VPC architecture with public/private subnets, NAT gateways, and route tables
- EC2 Auto Scaling Groups with Launch Templates and ALB integration
- RDS Aurora clusters with multi-AZ failover and automated backups
- S3 buckets with lifecycle policies, versioning, and encryption
- IAM roles, policies, and instance profiles following least-privilege principles
- Security Groups and NACLs for defense-in-depth network security
- CloudFormation nested stacks for modular, reusable infrastructure

---

## Architecture overview

```
                        AWS Account
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
        DEV               QA / UAT          PROD
          │                 │                 │
     ┌────▼─────────────────▼─────────────────▼────┐
     │                    VPC                       │
     │   ┌─────────────┐       ┌─────────────┐      │
     │   │ Public Subnet│       │Private Subnet│      │
     │   │  (ALB, NAT) │       │ (EC2, RDS)  │      │
     │   └──────┬──────┘       └──────┬──────┘      │
     │          │    Security Groups  │              │
     │          └──────────┬──────────┘              │
     │                     │                         │
     │              ┌──────▼──────┐                  │
     │              │  RDS Aurora │                  │
     │              │  (Multi-AZ) │                  │
     │              └─────────────┘                  │
     └────────────────────────────────────────────────┘
```

---

## Repo structure

```
aws-multi-env-iac/
├── terraform/
│   ├── modules/
│   │   ├── vpc/                  # VPC, subnets, IGW, NAT, route tables
│   │   ├── ec2/                  # Launch template, ASG, ALB
│   │   ├── rds/                  # Aurora cluster, parameter groups
│   │   ├── s3/                   # Buckets, policies, lifecycle rules
│   │   └── iam/                  # Roles, policies, instance profiles
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── terraform.tfvars
│   │   ├── qa/
│   │   ├── uat/
│   │   └── prod/
│   └── backend.tf                # S3 remote state + DynamoDB locking
├── cloudformation/
│   ├── vpc-stack.yaml
│   ├── ec2-stack.yaml
│   └── rds-stack.yaml
└── README.md
```

---

## Key design decisions

**Environment parity** — All environments use the same module definitions with environment-specific `tfvars`. No environment-specific logic in the module code itself.

**Remote state** — Terraform state stored in S3 with DynamoDB locking to prevent concurrent modifications across teams.

**Least-privilege IAM** — Every EC2 instance uses a scoped instance profile. No wildcard actions in production policies.

**Security Groups over NACLs** — SGs handle application-layer rules; NACLs provide a secondary subnet-level defense layer.

**Auto Scaling** — EC2 ASGs configured with target tracking scaling policies on CPU and request count metrics.

---

## Tech stack

| Tool | Purpose |
|---|---|
| Terraform >= 1.3 | Primary IaC — all environments |
| AWS CloudFormation | Legacy stack compatibility |
| AWS VPC | Network isolation per environment |
| AWS EC2 + ASG | Compute with auto scaling |
| AWS RDS Aurora | Managed relational database |
| AWS S3 | Object storage + Terraform remote state |
| AWS IAM | Identity and access management |

---

## How to deploy

```bash
# 1. Configure AWS credentials
aws configure

# 2. Initialize Terraform with remote backend
cd terraform/environments/dev
terraform init

# 3. Preview changes
terraform plan -var-file="terraform.tfvars"

# 4. Apply
terraform apply -var-file="terraform.tfvars"
```

---

## Outcomes from production use

- Reduced new environment provisioning time from **2 days → under 2 hours**
- Eliminated manual infrastructure drift across 4 environments
- Reusable modules adopted across 3 separate application teams
- Zero critical security findings across all environments

---

## Related repos

- [cicd-pipeline-aws](https://github.com/sharanyachinthakuntla/cicd-pipeline-aws) — Jenkins + CodePipeline CI/CD deploying to this infrastructure
- [grafana-observability-stack](https://github.com/sharanyachinthakuntla/grafana-observability-stack) — Monitoring stack for these environments

---

## Author

**Sharanya Chinthakuntla** — AWS DevOps Engineer · Atlanta, GA
[LinkedIn](https://linkedin.com/in/sharanya-chinthakuntla) · [Email](mailto:Sharanyachinthakuntla99@gmail.com)
