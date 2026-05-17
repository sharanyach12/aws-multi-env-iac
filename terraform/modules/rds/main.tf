# RDS Aurora Module
# Creates Aurora cluster, subnet groups, parameter groups, and security groups

variable "environment" {
  description = "Environment name (dev, qa, uat, prod)"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.r5.large"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-aurora-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${var.environment}-aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.02.0"
  db_subnet_group_name    = aws_db_subnet_group.this.name
  backup_retention_period = 7
  deletion_protection     = var.environment == "prod" ? true : false
  skip_final_snapshot     = var.environment == "prod" ? false : true
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.environment == "prod" ? 2 : 1
  identifier         = "${var.environment}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
}

output "cluster_endpoint" {
  value = aws_rds_cluster.this.endpoint
}
