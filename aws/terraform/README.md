# Relay Security AWS IAM Role

This Terraform configuration creates an IAM role that allows Relay Security to access your AWS account for security detection and remediation purposes.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (version 1.0.0 or newer)
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create IAM roles and policies

## Configuration

The configuration creates:

- An IAM role named `RelaySecurity`
- Attached AWS managed policies:
  - `SecurityAudit`
  - `ViewOnlyAccess`
- Optional inline policy for remediation actions (when enabled)

## Required Variables

| Variable         | Description                                                                  | Default    |
| ---------------- | ---------------------------------------------------------------------------- | ---------- |
| `external_id`    | The external ID that Relay Security uses to assume this role for your tenant | _Required_ |
| `enable_actions` | Whether to enable remediation actions for Relay Security                     | _Required_ |

## Optional Variables

| Variable                    | Description                                      | Default      |
| --------------------------- | ------------------------------------------------ | ------------ |
| `relay_security_account_id` | The account ID of the Relay Security AWS account | 715841372611 |

## Usage

1. Initialize Terraform:

   ```bash
   terraform init
   ```

2. Review the planned changes and enter values for the `external_id` & `enable_actions` variables when requested:

   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Security Considerations

- The role can only be assumed by the Relay Security account
- An external ID is required for role assumption
- The role has read-only access by default
- Remediation actions are optional and controlled by the `enable_actions` variable

## Cleanup

To remove all created resources:

```bash
terraform destroy
```
