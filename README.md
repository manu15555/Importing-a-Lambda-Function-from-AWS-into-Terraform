Importing an AWS Lambda Function into Terraform
## Objective

This project demonstrates how to import an existing AWS Lambda function (originally created manually in the AWS Console) into Terraform using the import block. The scope includes the Lambda’s source code, its execution role, the IAM policy attached to that role, and the CloudWatch Log Group. By codifying these resources, the project transitions from manual AWS setup to fully managed Infrastructure as Code (IaC). Please note that our state file is being managed locally instead of using a remote backend such as Terraform Cloud or an S3 bucket to keep things simple.
### Skills Learned

- Terraform imports: Migrating existing AWS resources into Terraform state.

- IAM role and policy management: Defining trust policies and attaching execution policies.

- CloudWatch integration: Managing log groups for Lambda functions.

- Archive packaging: Bundling Lambda source code into reproducible zip files.

- Best practices: Using default tags for resource tracking and governance.

- Critical thinking in IaC: Detecting and resolving drift between imported resources and Terraform definitions.

### Tools/Skills Used

- Terraform: Infrastructure as Code framework.

- AWS Lambda: Serverless compute function being imported.

- AWS IAM: Role and policy management for Lambda execution.

- AWS CloudWatch: Log group management for Lambda monitoring.

- Terraform import block: To bring existing AWS resources into Terraform state.

- Terraform data sources: To define trust policies and reference existing configurations.

- Archive File: To package Lambda source code into a zip file.

- AWS Provider: Configured for us-east-2 region with default tags.

- Run Terraform workflow:

--terraform init: initialize providers.

--terraform plan: confirm imports and validate configuration.

--terraform apply: manage Lambda, IAM, and CloudWatch resources fully through Terraform.

## Steps
- 1: Create the Lambda Function manually in the AWS Console.

- 2: Import the Lambda Function into Terraform (aws_lambda_function.this).

- 3: Import the Function Code using data.archive_file to package index.mjs into lambda.zip.

- 4: Import the Function Role (aws_iam_role.lambda_execution_role).

- 5: Import the Role Policy (aws_iam_policy.lambda_execution_role).

- 6: Refactor the Imported Policy with data.aws_iam_policy_document to define CloudWatch logging permissions.

- 7: Import the Log Group (aws_cloudwatch_log_group.lambda) for Lambda logs.

- 8: Add default tags in the provider block (ManagedBy=Terraform, Project=Project03-import-lambda) to enforce best practices.

