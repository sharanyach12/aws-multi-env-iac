# VPC Module
# Creates VPC, public/private subnets, IGW, NAT gateway, and route tables

variable "environment" {
  description = "Environment name (dev, qa, uat, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
