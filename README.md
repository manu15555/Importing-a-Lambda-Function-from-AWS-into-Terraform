Importing an AWS Lambda Function into Terraform
## Objective

This project demonstrates how to import an existing AWS Lambda function—originally created manually in the AWS Console into Terraform using the import block. The scope includes the Lambda’s source code, its execution role, and the IAM policy attached to that role. By codifying these resources, the project transitions from manual AWS setup to fully managed Infrastructure as Code (IaC).

### Skills Learned

- Advanced understanding of SIEM concepts and practical application.
- Proficiency in analyzing and interpreting network logs.
- Ability to generate and recognize attack signatures and patterns.
- Enhanced knowledge of network protocols and security vulnerabilities.
- Development of critical thinking and problem-solving skills in cybersecurity.

### Tools/Skills Used

- Terraform: Infrastructure as Code framework.

- AWS Lambda: Serverless compute function being imported.

- AWS IAM: Role and policy management for Lambda execution.

- Terraform import block: To bring existing AWS resources into Terraform state.

- Terraform data sources: To define trust policies and reference existing configurations.

- Archive File: To package Lambda source code into a zip file.

- AWS Provider: Configured for us-east-2 region.

## Steps
- 1: Create the Lambda Function manually.

  

- 2: Configure the Terraform provider for AWS (us-east-2) and Archive.

- 3: Define import blocks for:

--aws_lambda_function.this

--aws_iam_role.lambda_execution_role

--aws_iam_policy.lambda_execution

- 4: Use data "archive_file" to package the Lambda source code (index.mjs) into a zip file (lambda.zip).

- 5: Create Terraform resources for:

--aws_lambda_function with code, handler, runtime, and logging.

--aws_iam_role with assume role policy (data.aws_iam_policy_document).

--aws_iam_policy and aws_iam_role_policy_attachment.
- 6: Run terraform init to initialize providers.

- 7: Run terraform plan to confirm imports and validate configuration.

- 8: Apply changes with terraform apply to manage the Lambda and IAM resources fully through Terraform.
