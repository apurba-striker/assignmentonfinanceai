#  Stage 2: Infrastructure as Code (Terraform)

This stage provisions the AWS cloud infrastructure for OnFinance AI using Terraform. It includes VPC, subnets, EKS cluster, RDS database, S3 bucket, and IAM roles.

---

##  Project Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── README.md
└── modules/
    ├── networking/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── eks/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── rds/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── s3/
    │   ├── main.tf
    │   └── outputs.tf
    └── iam/
        ├── main.tf
        └── outputs.tf
```

---

##  Prerequisites

- Terraform v1.4+
- AWS CLI configured with credentials (`aws configure`)
- AWS IAM permissions to provision infrastructure

---

##  How to Deploy

### 1. Initialize Terraform

```bash
terraform init
```

### 2. (Optional) Review the Execution Plan

```bash
terraform plan
```

### 3. Apply the Configuration

```bash
terraform apply
```

>  You will be prompted to enter values like `db_password` (or set via environment variable or `.tfvars` file).

---

## Inputs

See `variables.tf` for the full list of configurable parameters.

You can override default values by creating a file like `terraform.tfvars`:

```hcl
db_password = "your-secure-db-password"
s3_bucket_name = "my-custom-s3-bucket"
```

---

##  Outputs

After a successful apply, Terraform will output:

- `eks_cluster_name`
- `rds_endpoint`
- `s3_bucket`

These values are useful for Stage 3 (Kubernetes deployment).

---

## Cleanup

To destroy the provisioned infrastructure:

```bash
terraform destroy
```

---

## Security Notes

- Store sensitive variables (like `db_password`) securely.
- Consider using `secrets.tfvars` and exclude it from version control via `.gitignore`.

---
