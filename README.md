# Importing an Existing AWS Lambda Function into Terraform
 
## Objective
This project demonstrates how to import an existing AWS Lambda function (originally created manually in the AWS Console) into Terraform using the `import` block. The scope covers the Lambda's source code, its execution role, the IAM policy attached to that role, and the CloudWatch Log Group. By codifying these resources, the project transitions from manual AWS setup to fully managed Infrastructure as Code (IaC). Note: the state file is managed locally instead of using a remote backend such as Terraform Cloud or an S3 bucket, to keep things simple.
 
### Skills Learned
- Terraform imports: migrating existing AWS resources into Terraform state.
- IAM role and policy management: defining trust policies and attaching execution policies.
- CloudWatch integration: managing log groups for Lambda functions.
- Archive packaging: bundling Lambda source code into zip files.
- Best practices: using default tags for resource tracking and governance; replacing hardcoded values with dynamic references; migrating IAM policy statements into policy documents; managing resources consistently through imports and data sources.
- Critical thinking in IaC: detecting and resolving drift between imported resources and Terraform definitions.
### Tools/Skills Used
- **Terraform** — Infrastructure as Code framework.
- **AWS Lambda** — serverless compute function being imported.
- **AWS IAM** — role and policy management for Lambda execution.
- **AWS CloudWatch** — log group management for Lambda monitoring.
- **Terraform import block** — to bring existing AWS resources into Terraform state.
- **Terraform data sources** — to define trust policies and reference existing configuration.
- **Archive File provider** — to package Lambda source code into a zip file.
- **AWS Provider** — configured for `us-east-2` with default tags.
- **Terraform workflow** — `terraform init` (initialize providers), `terraform plan` (confirm imports and validate configuration), `terraform apply` (manage Lambda, IAM, and CloudWatch resources fully through Terraform).
## Steps
 
<img width="1536" height="1024" alt="architecture overview" src="https://github.com/user-attachments/assets/1046e70d-265f-4e76-9ed8-91f345e51cc0" />

Overview diagram of the full import workflow: the manually created Lambda, IAM role, IAM policy, and CloudWatch log group are each brought into Terraform state via an `import` block, then fully defined in Terraform configuration, tracked in a local `terraform.tfstate`, and from then on managed entirely as code.
 
**1. Create the Lambda function manually in the AWS Console**
 
<img width="1904" height="866" alt="1" src="https://github.com/user-attachments/assets/62157f65-a6ec-47d1-b5ca-7ddae91efec5" />
<img width="1756" height="669" alt="2" src="https://github.com/user-attachments/assets/16496dd5-6dd0-4c3d-ac1f-821e8dc3d097" />
<img width="1640" height="812" alt="3" src="https://github.com/user-attachments/assets/c87d0550-5f6b-44e1-b375-67c0e2bac0f7" />
<img width="1327" height="482" alt="4" src="https://github.com/user-attachments/assets/1b8a21e0-d97c-4696-a1b8-3edc4b838fdc" />
<img width="493" height="241" alt="5" src="https://github.com/user-attachments/assets/d526e916-e1c8-4e73-9bbb-c489fb297188" />

As we can see, the Lambda function not only created an execution role but also a logging group. We want to import all of these components into Terraform, rather than just the function itself, since managing the function alone would not be sufficient.
 
**2. Import the Lambda function into Terraform** (`aws_lambda_function.this`)
 
<img width="1173" height="598" alt="6" src="https://github.com/user-attachments/assets/af641a7a-f1af-4d55-9058-b99a4ddd2f85" />
<img width="572" height="132" alt="9" src="https://github.com/user-attachments/assets/64ae20e5-76c3-44f4-b8d6-486c3aeb3813" />

Theimport `id` is the `function_name` of our Lambda function

<img width="800" height="148" alt="8" src="https://github.com/user-attachments/assets/33fba007-0dda-4f71-ba18-489b72a53a20" />
<img width="789" height="68" alt="10" src="https://github.com/user-attachments/assets/5762c6d5-e8a6-46ed-9fe3-b9e2810c5a54" />
<img width="841" height="505" alt="11" src="https://github.com/user-attachments/assets/a766681c-72bb-4b4e-bd74-e1295883d1f7" />

`terraform plan -generate-config-out=path` creates a plan and outputs a starter `.tf` file with resource definitions based on the current state. It's mainly used after importing resources to quickly scaffold configuration, but the generated code usually needs cleanup.
 
<img width="510" height="388" alt="12" src="https://github.com/user-attachments/assets/1a054cbf-7ca6-4458-8d00-69211a5dfa86" />

We constantly checked the Terraform Registry documentation and followed it closely to guide our implementation.


<img width="556" height="38" alt="12a" src="https://github.com/user-attachments/assets/c6e64331-9504-489a-b97b-6d27d5226fde" />
<img width="515" height="36" alt="12b" src="https://github.com/user-attachments/assets/6b54b468-b607-4ed3-8a43-40976595495b" />

The `index.handler` comes directly from the AWS Lambda function. Within the index file, it is clearly specified that we are exporting a function called `handler`.
 
<img width="1127" height="228" alt="13" src="https://github.com/user-attachments/assets/c0a14ae3-4f52-43b5-b102-160648b74965" />
<img width="835" height="604" alt="13a" src="https://github.com/user-attachments/assets/5cd4195b-268f-4078-ba15-7d271f45fec3" />

*Note: we changed the runtime version to `nodejs22.x`, since Terraform does not support `nodejs24.x`.*
 
**3. Import the function code** using `data.archive_file` to package `index.mjs` into `lambda.zip`
 
<img width="582" height="140" alt="14" src="https://github.com/user-attachments/assets/60902b55-65c8-4a84-89d7-9731f995d7d4" />

We fixed this error, which appears when running `terraform apply` or `terraform plan`.
 
<img width="597" height="98" alt="15" src="https://github.com/user-attachments/assets/f012d5ad-dfea-4f43-894c-2a95d925f653" />

The Terraform Registry documentation helped us address this issue.
 
<img width="963" height="462" alt="16" src="https://github.com/user-attachments/assets/e5d7b74b-09dc-439a-a3ba-4dd7ae10bc96" />

Next, we bundled our JavaScript function into a ZIP archive and configured the archive provider, since it is required.
 
<img width="469" height="189" alt="17" src="https://github.com/user-attachments/assets/78f5b8a7-13a2-42c8-9c99-ef214125541e" />


<img width="532" height="29" alt="aaaaaa" src="https://github.com/user-attachments/assets/a7fd0f71-00d7-403f-8179-0e0c9781289e" />

And we had to run `terraform init` again to install this new provider ( `archive` )


<img width="434" height="106" alt="18" src="https://github.com/user-attachments/assets/b10c28fd-534d-4b96-a3ef-74918d3b39c8" />




<img width="277" height="89" alt="19" src="https://github.com/user-attachments/assets/097c4766-f1ee-47e2-9125-28badc6b7f0c" />

We created a file called `index.mjs`, which is empty for now, and moved it into a subfolder called `build` to keep the project better organized. 
We also copied the `data source` from the Terraform registry documentation, this `data source` packages our Lambda function into a ZIP file and references it within the function definition.

This `data source` doesn't read something that already exists in AWS: It actually generates a file. It uses the archive provider to zip up our source code, since that's the format Lambda needs for deployment.

`type = "zip"`: compression format.

`source_file`: the code file that goes inside the zip (index.mjs).

`output_path`: where the resulting zip is saved.

`zip` is what aws_lambda_function references via `filename = "lambda.zip"`, we can use whatever name we want for this `.zip file` which will be generated with this `data source` but we used `lambda.zip` for consistency and easy reference.


 
<img width="489" height="104" alt="20" src="https://github.com/user-attachments/assets/85eb5721-da0b-49fa-a5e2-b22b7dde7c7a" />
<img width="506" height="88" alt="21" src="https://github.com/user-attachments/assets/b127b054-d564-478d-bca3-49acb4fa67fe" />


We made a quick change here to `path.root` instead. It's generally recommended and good practice to use `path.root` instead of `path.module`:



`path.root`: always points to the root of the Terraform configuration, ensuring consistency across modules.


`path.module`: refers only to the current module's directory, which can cause confusion in nested modules.

 
<img width="514" height="68" alt="22" src="https://github.com/user-attachments/assets/e6893308-ff2a-489c-b429-e067b185a56f" />


Now we can replace the `filename` with our `lambda.zip` file in our `aws_lambda_function` resource block.


<img width="452" height="32" alt="23" src="https://github.com/user-attachments/assets/3407e367-8451-4059-ae29-de73334faea0" />

Even though we run `terraform plan`, it will not go through since our `index.mjs` (which is our `source_file`), is empty and we still need to put our Lambda code into this file.

<img width="746" height="170" alt="24" src="https://github.com/user-attachments/assets/7528e260-f0d3-4628-b57b-9598f09081fd" />




<img width="674" height="39" alt="25" src="https://github.com/user-attachments/assets/f21003c5-1ecc-41c9-96ed-7b14e175a9c0" />

We copied our Lambda code into the `index.mjs` file, which was previously empty.

And we also replaced the hardcoded value in our `source_code_hash` that our `generated.tf file` previously generated, and replaced it with `data.archive_file.lambda_code.output_base64sha256`. We are basically replacing a fixed value (which we would have to update by hand every time our code changes) with a dynamic reference to the real hash of the zip generated by `archive_file`.


`source_code_hash` tells Terraform "this is what the Lambda code looks like right now". Its hash `(output_base64sha256)` is how Terraform detects code changes and knows to redeploy.










<img width="746" height="170" alt="24" src="https://github.com/user-attachments/assets/7528e260-f0d3-4628-b57b-9598f09081fd" />


<img width="700" height="710" alt="30" src="https://github.com/user-attachments/assets/b0153b13-8ee5-4fc9-937e-4254cc597819" />









We changed the code from (`"Hello World"`) to (`"Hello World from Terraform"`) to verify that we're actually managing our Lambda code through Terraform and we run `terraform apply`.

<img width="560" height="207" alt="27" src="https://github.com/user-attachments/assets/1e5672cc-9b1b-4605-b209-98ae3515a03d" />

We will get this message in the AWS Console that the function's code was updated and deployed in another editor (Terraform). Once we accept it, we will be able to see the changes we made in Terraform.


<img width="1911" height="750" alt="30a" src="https://github.com/user-attachments/assets/c269da8d-0788-4ed4-b3bb-dd7f97349ce2" />

As we can see, the changes are reflected in the AWS Console, while the code itself is managed through Terraform (`0 to add, 1 to change, 0 to destroy`, as mentioned when we run plan).
 
**4. Import the function role** (`aws_iam_role.lambda_execution_role`)

*Quick note: 
`assume_role_policy` defines who can take on the role, not what they can do with it.
`aws_iam_policy`: defines what actions the role can perform once assumed, e.g. writing logs.*


<img width="1152" height="524" alt="31" src="https://github.com/user-attachments/assets/6fc9ac1e-d101-48de-9d82-d0eba93c3137" />
<img width="548" height="109" alt="32" src="https://github.com/user-attachments/assets/0ead3267-1013-4b8f-8bba-68770b2e1946" />

The `id` represents the IAM role associated with our Lambda function.
 
<img width="773" height="24" alt="33" src="https://github.com/user-attachments/assets/30bd72f6-1ae8-41fa-9529-6b223c745519" />

We used the `generated.tf` file again (generated earlier via the command above), since this file is always meant to be temporary — we only need the configuration it provides, then delete or adjust it depending on what we want to keep.
 
<img width="841" height="502" alt="34" src="https://github.com/user-attachments/assets/aec978e5-b25f-4e76-ab86-fa4f50aaf50e" />
<img width="390" height="17" alt="35" src="https://github.com/user-attachments/assets/9b2706df-6000-4815-840d-4df4eb606182" />

The `assume_role_policy` indicates the principals permitted to assume the Lambda function's IAM role. Since AWS expects this as a JSON string, `jsonencode()` converts our HCL block (maps and lists) into that JSON string automatically. 


<img width="707" height="144" alt="35a" src="https://github.com/user-attachments/assets/6c8128dc-f395-46f2-8d91-2f467447a104" />

The role is updated to avoid hardcoding, ensuring it's referenced dynamically instead.


<img width="748" height="408" alt="36" src="https://github.com/user-attachments/assets/223306e6-7f09-47fd-9a3c-dcaa7e657c12" />

We copied the content from our `generated.tf` file once deleted and copied its content into `iam.tf`. As mentioned before, we only kept the code we needed.



**5. Import the role policy** (`aws_iam_policy.lambda_execution_role`)

*As mentioned before, `aws_iam_policy` defines what actions the role can perform once assumed, in this case, what actions our Lambda can perform once the role is assumed.*

<img width="663" height="264" alt="38" src="https://github.com/user-attachments/assets/c8e86743-b41b-4d21-a422-529fb05ccc36" />
<img width="730" height="290" alt="39" src="https://github.com/user-attachments/assets/82d00175-0f40-4e7b-8378-fac0edceeb69" />

We will use a data source for an `iam_policy_document`, and the statement from the policy will be copied and pasted from our `aws_iam_role` into our `aws_iam_policy_document`, replacing and changing some of the content. It will be basically be saying: "whichever role has this policy document attached as an `assume_role_policy`, will allow Lambda to assume this role". In other words, Lambda would be able to assume any role that has this `iam_policy_ document` attached as the `assume_role_policy`. We could be more strict about which Lambdas could assume this role, but it is okay for this use case since we only have one Lambda for now.  

<img width="723" height="71" alt="40" src="https://github.com/user-attachments/assets/cc97ddba-5319-4ef8-968c-55714d1a5857" />


We replaced all the value of `assume_role_policy` with the `data.aws_iam_policy_document` source and deleted the `jsonencode()` function, to avoid hardcoding.
 
<img width="1636" height="546" alt="41" src="https://github.com/user-attachments/assets/52544eef-2c3d-4701-9d2b-1efbe8517ecb" />

Now we will finally import our `role policy` (`lambda execution role`).

`id` = ARN of our execution role.
 
<img width="1014" height="90" alt="42" src="https://github.com/user-attachments/assets/4d851a10-360f-479d-bb87-4a28d84b4c42" />
<img width="837" height="492" alt="43" src="https://github.com/user-attachments/assets/4fc6464c-09a2-4a05-9e5d-a3a874a99192" />
<img width="739" height="200" alt="44" src="https://github.com/user-attachments/assets/6ef6679d-3652-4f3a-9eb0-9551cc025d81" />

We generated a `generated.tf` file once more, defined the Lambda execution role with a trust policy allowing AWS Lambda to assume it, and attached the imported `IAM policy` (`lambda_execution_role`) to the role, granting permissions to write logs to CloudWatch. We will not refactor the `generated.tf` file nor paste any content into our `iam.tf` file yet.
 
**6. Refactor the imported policy** with `data.aws_iam_policy_document` to define CloudWatch logging permissions
 
We migrated the statements defined in the IAM policy into a data source, and removed the principals since we only need to know under which resources the log group can be created.
 
<img width="439" height="87" alt="45" src="https://github.com/user-attachments/assets/461ac489-9e3d-431c-b554-30bca93d9fd2" />
<img width="382" height="84" alt="46" src="https://github.com/user-attachments/assets/3dc2b936-0e8c-4388-be21-94499c4d40dc" />

To avoid hardcoding, it's best practice to reference values through data sources, here we use data sources to retrieve our region and caller identity (account ID).
 
<img width="566" height="23" alt="47" src="https://github.com/user-attachments/assets/6a6aa31b-bf76-4e7e-8306-b4ea5b6be5f0" />
<img width="1092" height="35" alt="48" src="https://github.com/user-attachments/assets/066f1253-aa12-445c-bb94-ce4517de0abe" />
<img width="1568" height="941" alt="49" src="https://github.com/user-attachments/assets/d0af5a36-e701-4948-9246-bff312061d5e" />

We fully migrated our policy into an IAM policy document. The value in the second statement stays hardcoded for now, since the log group hasn't been imported yet. Running `terraform plan` shows no changes, since we're only migrating definitions within Terraform to align with best practices.
 
**7. Import the log group** (`aws_cloudwatch_log_group.lambda`) for Lambda logs
 
The CloudWatch log group is the destination for all logs produced by the Lambda function, in this case, it contains the output from the initial execution of our Lambda. This resource belongs to the CloudWatch service.
 
<img width="1919" height="914" alt="50" src="https://github.com/user-attachments/assets/2372e5a6-2e79-4f25-b82e-6d30c4568dd5" />


Since we want to manage this resource directly from our Terraform project, we used the `import` block (if we only wanted to read its information, we'd use a data source instead).
 
<img width="1656" height="494" alt="51" src="https://github.com/user-attachments/assets/9bd8e4bc-d6c7-45c4-b2fa-456ea24f5dd2" />
<img width="835" height="350" alt="52" src="https://github.com/user-attachments/assets/e82ed381-f043-4150-a14d-a01f99ed90e4" />


 
<img width="750" height="203" alt="53" src="https://github.com/user-attachments/assets/816e9853-65ac-40ce-919c-1da43ea8094f" />

Another `import block` and another `generated.tf` file, same process as before, we pasted its content into `cloudwatch.tf` and kept only what we needed.


We removed code fragments containing `null`, `0`, or `false` values. If those attributes had real values, we'd import them to manage directly from Terraform.

 
<img width="839" height="182" alt="54" src="https://github.com/user-attachments/assets/f6130694-8246-4d70-8b22-3bc521f7d7d8" />


As shown, the values mentioned above (`0`, `null`, `false`) remain in our state file when running `terraform plan`.

 
<img width="700" height="162" alt="55" src="https://github.com/user-attachments/assets/942d5375-f8d5-47ee-8260-4a468b7c8c7f" />


Finally, we replaced the hardcoded value in the second statement of the IAM policy document with a dynamic reference to the log group. The `*` is a wildcard matching any log stream inside that specific log group. Log streams get unique names per Lambda invocation, so you can't know them in advance, the wildcard lets the role write to any stream within that one log group, without opening access to anything else in CloudWatch.


**8. Add default tags** in the provider block (`ManagedBy=Terraform`, `Project=Project03-import-lambda`) to enforce best practices
 
<img width="483" height="186" alt="56" src="https://github.com/user-attachments/assets/34737fc4-a130-4c11-ad59-ea82d5e459a9" />

<img width="1573" height="411" alt="57" src="https://github.com/user-attachments/assets/3dc2c01f-707d-431d-b468-6bb7aafea24d" />


