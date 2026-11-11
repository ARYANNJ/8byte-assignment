# Infrastructure Access Control and Terraform State Management

## 1. Infrastructure Deployment Architecture

The infrastructure deployment process is designed to ensure that developers cannot directly modify AWS infrastructure from their local machines.

The workflow follows a controlled deployment model:

1. **Code Changes:** Developers make changes to Terraform configuration files and commit them to the GitHub repository.
2. **Terraform Plan:** Developers can execute `terraform plan` to review the proposed infrastructure changes. This allows them to identify what Terraform intends to create, modify, or destroy.
3. **Terraform Apply:** Direct execution of `terraform apply` from local machines is restricted. Infrastructure changes must be applied through the GitHub Actions pipeline.(They will raise PR to other engineer to check)
4. **GitHub Actions:** The pipeline authenticates with AWS, executes Terraform validation and planning, and applies the changes through the authorized deployment role.

This approach provides centralized control over infrastructure modifications, improves change traceability, and ensures that infrastructure changes are executed through a consistent deployment process.

## 2. AWS Authentication and Access Management

The recommended approach for AWS authentication is to use **AWS IAM Identity Center (SSO)**. This allows users to authenticate through a centralized identity provider and receive temporary AWS credentials based on their assigned permission sets.

However, enabling the required IAM Identity Center capabilities for our intended setup would introduce additional costs, as our current AWS account setup is based on the Free plan. Since the objective is to keep the assessment infrastructure cost-effective, we will not introduce a paid Identity Center arrangement for this implementation.

Instead, we will use IAM access keys with least-privilege permissions for authorized local Terraform operations.

The access keys will be configured locally and will not be committed to GitHub or stored in the repository.

For GitHub Actions, we will use **OpenID Connect (OIDC)** to authenticate with AWS. The workflow will assume a dedicated IAM role without requiring long-lived AWS access keys to be stored as GitHub secrets.

The IAM role will have only the permissions required for Terraform operations and will be restricted to the relevant AWS account and environment.

## 3. Terraform State Management

Terraform state is stored remotely in an Amazon S3 bucket rather than on individual developer machines.

Both Development and Production environments use separate state files within the same S3 bucket.

The backend configuration follows this structure:

- Development: `env/dev/terraform.tfstate`
- Production: `env/prod/terraform.tfstate`

This separation ensures that each environment maintains its own infrastructure state and that changes in one environment do not directly modify the state of the other.

The S3 backend is configured with encryption enabled and native state locking using `use_lockfile = true`. State locking helps prevent concurrent Terraform operations from modifying the same state file simultaneously.

Access to the state bucket is restricted through IAM permissions. Terraform state may contain sensitive infrastructure information, so access should be limited to authorized users and deployment roles.