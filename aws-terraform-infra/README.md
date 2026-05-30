# 🚀 AWS Terraform Enterprise Architecture

Production-grade AWS infrastructure using **Terraform modules**, **remote state (S3 + DynamoDB + KMS)**, and **environment setup**.

---

## 📌 Overview

This project provisions a highly available and secure architecture on AWS:

* Multi-AZ VPC
* Public & Private subnets
* Application Load Balancer (ALB)
* Auto Scaling Group (ASG)
* NAT Gateway per AZ
* Bastion Host (optional SSH access)
* IAM roles & policies
* Remote backend with encryption & locking

---

## 🏗️ Architecture Diagram

<img width="1536" height="1024" alt="aws-infra-architecture" src="https://github.com/user-attachments/assets/04d09f6b-6420-4748-9c75-be207c9bed05" />

---

## 🧭 Architecture Flow

```
User → ALB → Target Group → EC2 (Private Subnet)
                │
                ▼
         Auto Scaling Group
```

### 🔐 SSH Access

```
Laptop → Bastion Host → Private EC2
```

---

## 📂 Project Structure

```
aws-terraform-infra/
│
├── backend-infra/         # S3 + DynamoDB + KMS
│
├── modules/
│   ├── vpc/
│   ├── alb/
│   ├── asg/
│   ├── security/
│   ├── iam/
│   └── bastion/
│
├── envs/
│   ├── dev/
│   ├── stage/
│   └── prod/
|
└── README.md
```

---

## ⚙️ Features

### 🌐 Networking

* VPC with CIDR block
* Public & private subnets
* Internet Gateway & NAT Gateway
* Route tables

### ⚖️ Load Balancing

* Application Load Balancer (ALB)
* Target groups with health checks

### 🔁 Auto Scaling

* Dynamic scaling based on CPU
* Launch Templates
* Multi-AZ deployment

### 🔐 Security

* Security Groups (least privilege)
* Bastion Host for SSH
* IAM roles instead of static credentials

---

## 🗄️ Terraform Backend

| Component | Purpose               |
| --------- | --------------------- |
| S3        | Store Terraform state |
| DynamoDB  | State locking         |
| KMS       | Encryption            |

---

## 🔒 Security Best Practices

* Private EC2 instances (no public IP)
* SSH restricted to specific IP
* IAM roles for EC2 & CI/CD
* S3 encryption with KMS
* DynamoDB encryption enabled

---

## 🌍 Multi-Environment Setup

Each environment has isolated state:

```
envs/dev
envs/stage
envs/prod
```

### Example backend config:

```hcl
backend "s3" {
  bucket         = "dsoapp-terraform-state-12345"
  key            = "dev/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-locks"
}
```

---

## 🚀 Getting Started

### 1️⃣ Clone repository

```bash
git clone https://github.com/your-username/aws-terraform-infra.git
cd aws-terraform-infra
```

---

### 2️⃣ Create backend infrastructure

```bash
cd backend-infra
terraform init
terraform apply
```

---

### 3️⃣ Deploy environment

```bash
cd ../envs/dev
terraform init
terraform apply
```

---

## 🔑 SSH Access (Bastion)

```bash
ssh -i devops-key.pem ec2-user@<bastion-public-ip>
```

Then:

```bash
ssh ec2-user@<private-ip>
```

---

## 🧪 Validation

After deployment:

* Open ALB DNS in browser
* Refresh to see load balancing
* Verify ASG scaling behavior

---

## ⚠️ Troubleshooting

| Issue             | Cause           | Fix                    |
| ----------------- | --------------- | ---------------------- |
| 502 Bad Gateway   | EC2 not serving | Check user_data        |
| SSH denied        | Key mismatch    | Verify key_name        |
| Only one instance | ASG scaled down | Increase min_size      |
| Target unhealthy  | SG issue        | Allow port 80 from ALB |

---

## 🔄 Scaling Behavior

* Scale OUT → High CPU
* Scale IN → Low CPU

---

## 🧠 Best Practices

* Use modules for reusability
* Remote backend with locking
* Encrypt state using KMS
* Separate environments
* Avoid hardcoding values

---

## 🔮 Future Enhancements

* HTTPS (ACM + ALB)
* Route53 domain
* CloudWatch monitoring
* CI/CD (GitHub Actions)
* Replace bastion with SSM

---

## Jenkins CI/CD

This repo includes `aws-terraform-infra/Jenkinsfile` for Terraform CI/CD across `dev`, `stage`, and `prod`.

### Jenkins prerequisites

Install these tools/plugins on the Jenkins controller or agent:

* Terraform CLI `>= 1.5.0`
* AWS CLI, if you want to run AWS checks manually from the agent
* Jenkins Pipeline plugin
* AWS Credentials plugin support for `AmazonWebServicesCredentialsBinding`
* Workspace Cleanup plugin for `cleanWs`
* An agent with network access to AWS, the S3 state buckets, DynamoDB lock table, and KMS key

### Jenkins credentials

Create an AWS credential in Jenkins:

| Jenkins credential ID | Type | Purpose |
| --------------------- | ---- | ------- |
| `<your-id>` | AWS access key / secret key | Runs `terraform init`, `plan`, `apply`, and `destroy` |

The IAM principal should have least-privilege access to:

* Read/write the Terraform state S3 buckets
* Read/write the DynamoDB lock table
* Use the KMS key alias `alias/tf-state-key`
* Manage the AWS resources declared in this Terraform project

### Pipeline parameters

| Parameter | Values | Description |
| --------- | ------ | ----------- |
| `ENVIRONMENT` | `dev`, `stage`, `prod` | Selects `envs/<environment>` |
| `ACTION` | `plan`, `apply`, `destroy` | `apply` and `destroy` pause for manual approval |

### Pipeline stages

1. Checkout source
2. Show Terraform version
3. Run `terraform init -upgrade`
4. Run `terraform fmt -check -recursive`
5. Run `terraform validate`
6. Create a saved plan file
7. Wait for manual approval for `apply` or `destroy`
8. Apply the saved plan

### Create the Jenkins job

1. Create a new Jenkins Pipeline or Multibranch Pipeline job.
2. Point it at this repository.
3. Set the script path to:

```text
aws-terraform-infra/Jenkinsfile
```

4. Run the job with `ACTION=plan` first.
5. Review the plan output, then rerun with `ACTION=apply` for the selected environment.

## 👨‍💻 Author

**DevOps Terraform Learning Project**

---

## ⭐ Contributing

Feel free to fork and improve this project!

---
