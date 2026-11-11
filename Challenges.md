Challenges Faced and Remediation
1. Terraform and Infrastructure Provisioning
- Provider version mismatch: Terraform lock file used AWS provider 6.x while modules required 5.x. Updated provider constraints consistently.
- Terraform dependency cycle: ALB name depended on its own module output. Replaced it with a name built from input variables.
- Terraform formatting failures: Inconsistent formatting caused CI checks to fail. Used terraform fmt -recursive and added formatting checks.
- IAM permission errors: GitHub Actions lacked permissions for ELB and CloudWatch operations. Updated the deployment role with required permissions.
- Incorrect module outputs: Missing or incorrect outputs caused errors in ALB metrics and RDS configuration. Corrected module outputs and verified them using Terraform console.
- Duplicate resources: Multiple modules attempted to create the same CloudWatch log group. Removed duplicate resource management.
- Terraform state and workspace mismatch: Plans showed unexpected resources because of empty state and incorrect workspace selection. Verified the workspace and used TF_WORKSPACE=dev.
- Resource renaming issues: Terraform attempted to recreate existing resources. Identified the need for moved blocks to preserve resource state.
2. Networking and ECS
- ECS instances failed to register: Private subnet instances lacked outbound connectivity. Added a NAT Gateway, private route and S3 gateway endpoint.
- SSM connection failure: Instances could not connect through Session Manager due to missing network access. Fixed outbound connectivity instead of exposing SSH publicly.
- ECS instance resource constraints: A t3.micro could not support the required task resources. Switched to bridge networking with dynamic ports and reduced task memory allocation.
- Deployment failures due to limited capacity: A single ECS instance had no spare capacity for rolling deployments. Adjusted the deployment minimum healthy percentage.
3. Database and Application Configuration
- RDS subnet group conflict: Terraform attempted to recreate a subnet group with the same AWS name. Re-ran the deployment and created moved blocks.
- Incorrect RDS outputs: Database name, host and secret ARN outputs were incorrect or null. Fixed module outputs and verified the returned values.
- Application database configuration failure: The task definition was missing DB_HOST, causing the application to crash. Restored the environment variable and deployed a new revision.
- Application routing issue: The root URL returned 404 because FastAPI had no / route. Used /docs and /health and added a home page route.
4. Docker, Git and CI/CD
- GHCR authentication failures: Image push and pull operations returned 401 and 403 errors. Updated registry authentication and package permissions; the exact cause of the initial push denial was not confirmed.
- Docker base image configuration: The application image was incorrectly referenced as its own base image. Corrected the Dockerfile to use a proper upstream base image.
- Git push rejected: Local and remote branches had diverged. Resolved this using git pull --rebase.
- Accidental token exposure: A token was pasted into the terminal and chat. Revoked the exposed token.
- CI/CD workflow issues: Incorrect Snyk configuration, unpinned actions and incomplete Git history affected the workflow. Corrected the scan configuration, reordered security checks and enabled full Git history for secret scanning.
5. Monitoring Infrastructure
- Insufficient monitoring capacity: A single t3.micro could not support Grafana, Loki and Prometheus. Moved monitoring workloads to a separate t3.small instance.
- Duplicate Terraform module declarations: Copy-pasted blocks caused duplicate resource labels. Introduced unique module names.
- Application-specific service module: Monitoring services inherited unnecessary ALB rules and database secrets. Generalized the module with optional ALB, database secret, networking and volume configurations.
- Terraform variable and resource reference errors: Inconsistent variable names and incorrect count references caused plan failures. Aligned module files and corrected resource references.
- Monitoring connectivity: Stable internal connectivity to Loki and Prometheus remains an open design item. An internal Network Load Balancer was proposed but has not yet been implemented.
