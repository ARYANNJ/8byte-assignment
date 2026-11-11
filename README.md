# 8byte-assignment
Assignment sent by 8Byte for Devops role


# Approach Documentation:

# Goal:
Part 1: Infrastructure Provisioning: Use Terraform to provision a VPC, RDS (PostgreSQL), and application hosting (EC2/ECS/EKS) on AWS.
Part 2: Deployment Automation: Create CI/CD pipelines (GitHub Actions/GitLab/Jenkins) including test suites, Docker image handling, and staging/production deployment logic.
Part 3: Monitoring & Logging: Set up centralized logging and infrastructure/application metrics with at least two dashboards.

# Architectural approach
Single application needs to be deployed on EC2/ECS/EKS
as the days are 3 we will be going with ECS and for better management we will went with ECS-EC2 self managed

# Environment Separation – AWS Account Strategy

The infrastructure is separated across three independent AWS accounts to maintain isolation between environments and centralize account management.

# 1. Development Account

The Development account hosts development infrastructure and application workloads. It is used for feature development, testing, integration, and validating infrastructure changes before they are promoted to production.

Developers and CI/CD pipelines receive access to this account through dedicated IAM roles with permissions limited to development resources.

# 2. Production Account

The Production account hosts live application workloads and production data. It is kept isolated from the Development account to reduce the risk of accidental changes, unauthorized access, and cross-environment impact.

Production deployments use a separate IAM role and deployment permissions. Access is more restrictive, and production changes should follow an approval process.

# 3. Billing and Management Account

The Billing/Management account is responsible for centralized AWS Organizations management and consolidated billing across the organization.

It provides a central place to manage member accounts, organizational policies, and billing visibility. Application workloads are not deployed in this account.

# Environment Isolation and Access Control

Using separate AWS accounts provides a strong security boundary between Development and Production. Resources, IAM permissions, networking, and application data are managed independently within each account.

The CI/CD pipeline authenticates to the relevant AWS account using GitHub Actions OIDC and assumes an account-specific IAM role. This avoids storing long-lived AWS access keys in GitHub secrets.

The Development deployment role is restricted to Development resources, while the Production deployment role has access only to approved Production resources. This prevents a development pipeline from directly modifying production infrastructure.

This account structure provides better security isolation, controlled deployments, independent resource management, and centralized billing governance.

# Basic Architecture

The primary objective of this architecture is to deploy a containerized application on AWS while minimizing infrastructure costs as much as possible for this assessment.

We will use a simple AWS architecture consisting of one VPC, four subnets, one Internet Gateway, one NAT Gateway, two route tables, one ECS cluster, one ECS service, one ECR repository, and one RDS MySQL instance.

# Network Architecture

We will create a single VPC with a CIDR block of `10.0.0.0/16`.

The VPC will contain four subnets distributed across two Availability Zones. Two subnets will be public, and the remaining two will be private.

The public subnets will host the Application Load Balancer and NAT Gateway. The private subnets will host the ECS application and RDS database.

An Internet Gateway will be attached to the VPC to provide internet connectivity to resources in the public subnets.

We will create two route tables: one public and one private. Both public subnets will be associated with the public route table, while both private subnets will use the private route table.

The public route table will route internet-bound traffic (`0.0.0.0/0`) through the Internet Gateway.

The private route table will route outbound internet traffic through a single NAT Gateway deployed in one of the public subnets. Using only one NAT Gateway instead of one per Availability Zone will help reduce infrastructure costs. However, this introduces an Availability Zone dependency.

# Application Architecture

We will use Amazon ECS with the EC2 launch type to deploy our containerized application.

A single ECS cluster will be created, containing EC2 instances that provide the compute capacity required to run application containers.

One ECS service will manage the application deployment and maintain the desired number of running tasks.

The application Docker image will be stored in a single private Amazon ECR repository. GitHub Actions will build the Docker image, scan it for vulnerabilities, and push it to ECR.

The ECS task definition will reference the image stored in ECR. Whenever a new version is deployed, the task definition will be updated to use the new image tag.

An internet-facing Application Load Balancer will be deployed in the public subnets to receive incoming application traffic and forward requests to the ECS service running in the private subnets.

# Database Architecture

Amazon RDS for MySQL will be used as the application's database.

The database will be deployed in the private subnets using a DB subnet group containing both private subnets. For cost optimization, we will initially use a Single-AZ deployment rather than Multi-AZ.

The database will not be publicly accessible. Only the ECS application will be allowed to communicate with RDS on port `3306`, enforced through security groups.

# Cost Optimization

Since this infrastructure is intended for an assessment, we will prioritize minimizing unnecessary AWS costs.

We will use a single NAT Gateway instead of deploying one in each Availability Zone, ECS EC2 launch type instead of Fargate, a single ECS cluster and service, one ECR repository, and a Single-AZ RDS instance.

We will also start with minimal EC2 and RDS instance sizes based on the application's resource requirements.

The objective is to demonstrate a functional AWS deployment with proper network isolation, container management, database connectivity, and CI/CD automation without introducing unnecessary infrastructure complexity.

# CI/CD Approach

We will use GitHub Actions to implement the CI/CD pipeline. Separate workflows will be maintained for the development and production environments to ensure proper environment isolation and independent deployment control.

Considering the limited time available for this assessment and the GitHub Actions usage limits, we will initially implement only the development environment. The same deployment approach and workflow structure can later be replicated for production with the appropriate AWS resources and IAM permissions.

For this assessment, we will focus on demonstrating an automated development deployment rather than provisioning and maintaining two complete environments, which would introduce additional infrastructure costs.

Development Deployment Workflow

The development workflow will be triggered automatically whenever changes are pushed to the main branch that affect the dev-app directory or its deployment workflow file. It can also be triggered manually using workflow_dispatch.

The workflow consists of the following stages:

1. Source Code Checkout

The pipeline starts by checking out the application source code from GitHub using actions/checkout.

We use fetch-depth: 0 to retrieve the complete Git history, which can be useful for security scanning tools such as TruffleHog when identifying previously committed secrets.

2. Secret Scanning – TruffleHog

We use TruffleHog to scan the repository for accidentally committed secrets, such as API keys, access tokens, passwords, and cloud credentials.

The --only-verified argument ensures that TruffleHog reports credentials that it can verify as valid.

This implements an early security check to help prevent sensitive credentials from being exposed through the source code repository.

3. Dependency Vulnerability Scanning – Snyk

We use Snyk to scan the application's dependencies for known security vulnerabilities.

The Node.js scanning action checks application dependencies against Snyk's vulnerability database and identifies vulnerable packages.

The objective is to identify vulnerable third-party dependencies before building and deploying the application.

The SNYK_TOKEN is stored as a GitHub Actions repository secret and passed securely to the scanning action.

4. Docker Image Build

After the initial security checks, GitHub Actions builds the Docker image using the application's Dockerfile.

The image is tagged using the Git commit SHA.

Using the commit SHA provides traceability between the deployed container image and the source code version from which it was built.

The image is initially built locally on the GitHub Actions runner before being pushed to Amazon ECR.

5. Container Image Vulnerability Scanning – Snyk

After building the Docker image, we use Snyk Container to scan it for known vulnerabilities.

This scan helps identify vulnerabilities in the container's base operating system packages and installed software dependencies.

We configure the scan with a high-severity threshold to focus on high and critical security issues.

This adds another security layer by checking the actual container image rather than relying only on application dependency scanning.

6. AWS Authentication – GitHub OIDC

Once the security scanning stages are completed, GitHub Actions authenticates with AWS using OpenID Connect (OIDC).

Instead of storing long-lived AWS access keys in GitHub Secrets, we configure an IAM role that GitHub Actions can assume through OIDC.

The IAM role will have only the permissions required for the development deployment, including ECR image publishing and ECS service deployment.

This approach reduces the risk associated with storing and managing permanent AWS credentials.

7. Amazon ECR Authentication and Image Push

After successfully assuming the AWS IAM role, the pipeline authenticates with Amazon ECR.

The locally built Docker image is tagged with the ECR repository URI and pushed to the development ECR repository.

We use the Git commit SHA as the image tag to maintain version traceability. A latest tag is also maintained for convenience.

8. ECS Service Deployment

Once the Docker image is pushed successfully to ECR, the pipeline triggers a new deployment of the development ECS service.

The workflow uses the AWS CLI to call aws ecs update-service with the --force-new-deployment option.

ECS then starts a new deployment and replaces running tasks according to the service's deployment configuration.

Finally, aws ecs wait services-stable ensures that the pipeline waits until the ECS service reaches a stable state before completing successfully.

Security Shift Left Approach

Security Shift Left means integrating security checks early in the software development lifecycle instead of waiting until the application reaches production.

In our implementation, security is integrated directly into the CI/CD pipeline through multiple stages.

Source code security: TruffleHog scans the repository for exposed credentials and secrets.

Dependency security: Snyk identifies known vulnerabilities in application dependencies.

Container security: Snyk Container scans the built Docker image for vulnerable packages and components.

Cloud authentication security: GitHub OIDC eliminates the need for long-lived AWS access keys in GitHub Secrets.

Least privilege access: The GitHub Actions IAM role receives only the AWS permissions required for deployment.

By integrating these security checks into the CI/CD process, we aim to identify and address security issues before the application is deployed to the development environment.

The same security approach will be maintained when the production deployment workflow is implemented.


# Base Image Hardening and GitHub Packages

To improve container security, we will maintain a hardened base image and publish it to GitHub Container Registry (GHCR). Application Docker images will use this centrally maintained base image instead of pulling directly from an unverified or frequently changing upstream image.

The base image will be built from a minimal trusted image. Unnecessary packages and tools will be removed to reduce the attack surface.

We will use security scanning tools such as **Snyk Container** or **Amazon Inspector** to identify vulnerabilities in the base image. Identified vulnerabilities will be reviewed and remediated by updating affected packages, removing unnecessary components, or rebuilding the image with patched dependencies.

After remediation, the image will be scanned again. Once it meets the required security criteria, it will be published to GHCR with a versioned tag.

The application build pipeline will pull this hardened base image from GHCR and use it to build the application container. The final application image will also undergo vulnerability scanning before deployment.

A separate workflow can be introduced to periodically check for upstream base image updates, rebuild the hardened image, perform security scans, and publish a new version. We will initially follow a monthly patching cycle, with critical vulnerabilities addressed as soon as possible.

This approach provides:

- A centrally maintained and reusable base image.
- Reduced container attack surface through minimal packages.
- Consistent security standards across application builds.
- Better visibility into vulnerabilities and remediation.
- A controlled process for updating and distributing patched base images.