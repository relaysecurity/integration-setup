terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "relay_security_account_id" {
  description = "The account ID of the Relay Security AWS account that is allowed to assume this role"
  type        = string
  default     = "715841372611"
}

variable "external_id" {
  description = "The external ID that Relay Security uses to assume this role for your tenant"
  type        = string
}

variable "enable_actions" {
  description = "Whether to enable additional EC2 actions for Relay Security"
  type        = bool
}

variable "cloudtrail_sns_arn" {
  description = "Optional ARN of the CloudTrail SNS topic to allow subscription actions"
  type        = string
}

resource "aws_iam_role" "relay_security" {
  name = "RelaySecurityIntegration"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.relay_security_account_id}:root"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = aws_iam_role.relay_security.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_iam_role_policy_attachment" "view_only" {
  role       = aws_iam_role.relay_security.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_role_policy" "remediation_actions" {
  count = var.enable_actions ? 1 : 0
  name  = "RelaySecurityRemediationActions"
  role  = aws_iam_role.relay_security.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:ModifyInstanceAttribute",
          "ec2:TerminateInstances",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudtrail_sns" {
  count = var.cloudtrail_sns_arn != "" ? 1 : 0
  name  = "RelaySecurityCloudTrailSns"
  role  = aws_iam_role.relay_security.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Subscribe",
          "sns:Unsubscribe"
        ]
        Resource = var.cloudtrail_sns_arn
      }
    ]
  })
}
