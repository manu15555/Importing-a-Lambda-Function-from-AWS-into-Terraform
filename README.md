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

 <img width="1904" height="866" alt="1" src="https://github.com/user-attachments/assets/62157f65-a6ec-47d1-b5ca-7ddae91efec5" />
 
 
 <img width="1756" height="669" alt="2" src="https://github.com/user-attachments/assets/16496dd5-6dd0-4c3d-ac1f-821e8dc3d097" />
 
 
<img width="1640" height="812" alt="3, greenshot" src="https://github.com/user-attachments/assets/c87d0550-5f6b-44e1-b375-67c0e2bac0f7" />


<img width="1327" height="482" alt="4, greenshot" src="https://github.com/user-attachments/assets/1b8a21e0-d97c-4696-a1b8-3edc4b838fdc" />


<img width="493" height="241" alt="5" src="https://github.com/user-attachments/assets/d526e916-e1c8-4e73-9bbb-c489fb297188" />

As we can see, the Lambda function not only created an execution role but also a logging group. We want to import all of these components into Terraform, rather than just the function itself, since managing the function alone would not be sufficient

- 2: Import the Lambda Function into Terraform (aws_lambda_function.this).

  <img width="1173" height="598" alt="6, grenshot" src="https://github.com/user-attachments/assets/af641a7a-f1af-4d55-9058-b99a4ddd2f85" />
<img width="525" height="146" alt="7" src="https://github.com/user-attachments/assets/37641573-626f-44da-9dc3-0680fae1f4fe" />
<img width="800" height="148" alt="8" src="https://github.com/user-attachments/assets/33fba007-0dda-4f71-ba18-489b72a53a20" />
<img width="572" height="132" alt="9" src="https://github.com/user-attachments/assets/64ae20e5-76c3-44f4-b8d6-486c3aeb3813" />
<img width="789" height="68" alt="10" src="https://github.com/user-attachments/assets/5762c6d5-e8a6-46ed-9fe3-b9e2810c5a54" />
<img width="841" height="505" alt="11, greenshot" src="https://github.com/user-attachments/assets/a766681c-72bb-4b4e-bd74-e1295883d1f7" />

terraform plan -generate-config-out=path creates a plan and outputs a starter .tf file with resource definitions based on the current state. It’s mainly used after importing resources to quickly scaffold configuration, but the generated code usually needs cleanup.

We constantly checked the Terraform Registry documentation and followed it closely to guide our implementation.

<img width="510" height="388" alt="12" src="https://github.com/user-attachments/assets/1a054cbf-7ca6-4458-8d00-69211a5dfa86" />
<img width="556" height="38" alt="12a" src="https://github.com/user-attachments/assets/c6e64331-9504-489a-b97b-6d27d5226fde" />
<img width="515" height="36" alt="12b" src="https://github.com/user-attachments/assets/6b54b468-b607-4ed3-8a43-40976595495b" />

The index.handler comes directly from the AWS Lambda function. Within the index file, it is clearly specified that we are exporting a function called handler.

<img width="1127" height="228" alt="13, greenshot" src="https://github.com/user-attachments/assets/c0a14ae3-4f52-43b5-b102-160648b74965" />
<img width="835" height="604" alt="13a, greenshot" src="https://github.com/user-attachments/assets/5cd4195b-268f-4078-ba15-7d271f45fec3" />


Please note that we've changed the runtime version for nodejs22.x since Terraform does not support the nodejs24.x version.

- 3: Import the Function Code using data.archive_file to package index.mjs into lambda.zip.

<img width="582" height="140" alt="14" src="https://github.com/user-attachments/assets/60902b55-65c8-4a84-89d7-9731f995d7d4" />


We are going to fix this error that appears when running terraform apply or terraform plan.


  
<img width="597" height="98" alt="15" src="https://github.com/user-attachments/assets/f012d5ad-dfea-4f43-894c-2a95d925f653" />


The Terraform Registry documentation will help us address this issue.


<img width="963" height="462" alt="16" src="https://github.com/user-attachments/assets/e5d7b74b-09dc-439a-a3ba-4dd7ae10bc96" />


Next, we will bundle our JavaScript function into a ZIP archive and configure the archive provider since it is required.

<img width="469" height="189" alt="17" src="https://github.com/user-attachments/assets/78f5b8a7-13a2-42c8-9c99-ef214125541e" />
<img width="434" height="106" alt="18" src="https://github.com/user-attachments/assets/b10c28fd-534d-4b96-a3ef-74918d3b39c8" />
<img width="277" height="89" alt="19" src="https://github.com/user-attachments/assets/097c4766-f1ee-47e2-9125-28badc6b7f0c" />

We create the index.mjs file and move it into a subfolder to keep the project better organized. This data source packages our Lambda function into a ZIP file and leverages it within the function definition.


<img width="489" height="104" alt="20" src="https://github.com/user-attachments/assets/85eb5721-da0b-49fa-a5e2-b22b7dde7c7a" />
<img width="506" height="88" alt="21" src="https://github.com/user-attachments/assets/b127b054-d564-478d-bca3-49acb4fa67fe" />

It is generally recommended and a good practice to use path.root instead of path.module:

--path.root always points to the root of the Terraform configuration, ensuring consistency across modules.

--path.module refers only to the directory of the current module, which can lead to confusion when working with nested modules.

<img width="514" height="68" alt="22" src="https://github.com/user-attachments/assets/e6893308-ff2a-489c-b429-e067b185a56f" />
<img width="452" height="32" alt="23" src="https://github.com/user-attachments/assets/3407e367-8451-4059-ae29-de73334faea0" />
<img width="746" height="170" alt="24" src="https://github.com/user-attachments/assets/7528e260-f0d3-4628-b57b-9598f09081fd" />
<img width="674" height="39" alt="25" src="https://github.com/user-attachments/assets/f21003c5-1ecc-41c9-96ed-7b14e175a9c0" />

We copy our Lambda code into the index.mjs file, which was empty and had no content in it.

<img width="600" height="27" alt="26" src="https://github.com/user-attachments/assets/ae454bf9-a72b-4d98-8d02-15605653f9d2" />
<img width="560" height="207" alt="27" src="https://github.com/user-attachments/assets/1e5672cc-9b1b-4605-b209-98ae3515a03d" />
<img width="450" height="86" alt="28" src="https://github.com/user-attachments/assets/8417023e-8b58-426c-b398-9a55c280170a" />
<img width="538" height="49" alt="29, editar con greenshot" src="https://github.com/user-attachments/assets/2e760932-8030-4145-9670-db24fab591cc" />
<img width="700" height="710" alt="30" src="https://github.com/user-attachments/assets/b0153b13-8ee5-4fc9-937e-4254cc597819" />
<img width="1911" height="750" alt="30a, greenshot" src="https://github.com/user-attachments/assets/c269da8d-0788-4ed4-b3bb-dd7f97349ce2" />


As we can see, the changes are reflected in the AWS Console, while the code itself is managed through Terraform (0 to add, 1 to change and 0 to destroy).


- 4: Import the Function Role (aws_iam_role.lambda_execution_role).

<img width="1152" height="524" alt="31" src="https://github.com/user-attachments/assets/6fc9ac1e-d101-48de-9d82-d0eba93c3137" />
<img width="548" height="109" alt="32" src="https://github.com/user-attachments/assets/0ead3267-1013-4b8f-8bba-68770b2e1946" />


The id represents the IAM role associated with our Lambda function.

<img width="773" height="24" alt="33" src="https://github.com/user-attachments/assets/30bd72f6-1ae8-41fa-9529-6b223c745519" />


We use the generated.tf (we generated it using the previously shown command) file again, as this file is always meant to be temporary. We only need the configuration it provides, and then we delete or adjust it depending on what we want to keep.

<img width="841" height="502" alt="34, greenshot" src="https://github.com/user-attachments/assets/aec978e5-b25f-4e76-ab86-fa4f50aaf50e" />
<img width="390" height="17" alt="35" src="https://github.com/user-attachments/assets/9b2706df-6000-4815-840d-4df4eb606182" />

This indicates the principals that are permitted to assume the Lambda function’s IAM role.

<img width="707" height="144" alt="35a" src="https://github.com/user-attachments/assets/6c8128dc-f395-46f2-8d91-2f467447a104" />
<img width="748" height="408" alt="36" src="https://github.com/user-attachments/assets/223306e6-7f09-47fd-9a3c-dcaa7e657c12" />


The role is updated to avoid hardcoding, ensuring that it is dynamically referenced instead.


- 5: Import the Role Policy (aws_iam_policy.lambda_execution_role).

<img width="663" height="264" alt="38" src="https://github.com/user-attachments/assets/c8e86743-b41b-4d21-a422-529fb05ccc36" />
<img width="730" height="290" alt="39" src="https://github.com/user-attachments/assets/82d00175-0f40-4e7b-8378-fac0edceeb69" />


Basically, we are copying the contents of this policy. What we are doing is allowing Lambda to assume any role that has this IAM policy attached, just as defined in the assume role policy.


<img width="723" height="71" alt="40" src="https://github.com/user-attachments/assets/cc97ddba-5319-4ef8-968c-55714d1a5857" />
<img width="1636" height="546" alt="41, greenshot" src="https://github.com/user-attachments/assets/52544eef-2c3d-4701-9d2b-1efbe8517ecb" />
<img width="1014" height="90" alt="42, greenshot" src="https://github.com/user-attachments/assets/4d851a10-360f-479d-bb87-4a28d84b4c42" />
<img width="837" height="492" alt="43, greenshot" src="https://github.com/user-attachments/assets/4fc6464c-09a2-4a05-9e5d-a3a874a99192" />
<img width="739" height="200" alt="44" src="https://github.com/user-attachments/assets/6ef6679d-3652-4f3a-9eb0-9551cc025d81" />




- 6: Refactor the Imported Policy with data.aws_iam_policy_document to define CloudWatch logging permissions.

- 7: Import the Log Group (aws_cloudwatch_log_group.lambda) for Lambda logs.

- 8: Add default tags in the provider block (ManagedBy=Terraform, Project=Project03-import-lambda) to enforce best practices.

