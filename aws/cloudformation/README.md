# Relay Security IAM Role - CloudFormation Template

This CloudFormation template creates an IAM role that allows Relay Security to access your AWS account for security detection and remediation purposes.

## Prerequisites

- AWS CLI installed and configured
- Appropriate AWS permissions to create IAM roles and policies

## Template Parameters

- `ExternalId` (Required): The external ID provided by Relay Security for your tenant
- `EnableActions` (Optional): Whether to enable remediation actions for Relay Security. Defaults to 'false'.

## Deployment Instructions

### Using AWS CLI

1. Deploy the template using the AWS CLI:

```bash
aws cloudformation create-stack \
  --stack-name relay-security-role \
  --template-body file://relay-security-role.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=ExternalId,ParameterValue=your-external-id \
    ParameterKey=EnableActions,ParameterValue=true
```

2. To update an existing stack:

```bash
aws cloudformation update-stack \
  --stack-name relay-security-role \
  --template-body file://relay-security-role.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=ExternalId,ParameterValue=your-external-id \
    ParameterKey=EnableActions,ParameterValue=true
```

### Using AWS Console

1. Open the AWS CloudFormation console
2. Click "Create stack" and choose "With new resources (standard)"
3. Upload the `relay-security-role.yaml` template
4. Enter the stack name (e.g., "relay-security-role")
5. Provide the required parameters:
   - ExternalId: Your Relay Security external ID
   - EnableActions: Choose whether to enable remediation actions
6. Review and create the stack

## Outputs

The template outputs the ARN of the created IAM role, which you'll need to provide to Relay Security.

## Security Considerations

- The role can only be assumed by the Relay Security account
- An external ID is required for role assumption
- The role has read-only access by default
- Remediation actions are optional and controlled by the `enable_actions` variable
