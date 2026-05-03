# DevSecOps Tools Automation with AWS EC2 using Terraform

This Terraform project provisions a multi-node DevSecOps lab environment on AWS EC2. It creates Ubuntu-based EC2 instances for Jenkins, SonarQube, Nexus, Grafana/Prometheus, and a Kubernetes cluster foundation, then bootstraps each server with role-specific user-data scripts.

The goal is to automate the infrastructure layer for a practical DevSecOps toolchain where CI/CD, code quality, artifact management, container security scanning, Kubernetes deployment, and monitoring can be configured from a repeatable Terraform workflow.

## Architecture Overview

Terraform creates the following AWS resources:

- Latest Ubuntu 24.04 LTS AMI lookup from Canonical
- EC2 key pair from a local public key
- Shared security group for DevSecOps access
- Seven EC2 instances with public IP addresses
- Root EBS volumes using configurable size and type
- Terraform outputs for AWS identity, public IPs, and public DNS names

Provisioned EC2 instances:

| Instance Role | Terraform Key | Instance Type | Bootstrap Script | Purpose |
| --- | --- | --- | --- | --- |
| Jenkins | `jenkins` | `t3.large` | `user-data/jenkins.sh` | CI/CD automation server with Docker, Trivy, kubectl, Java, Jenkins, and Node Exporter |
| SonarQube | `sonarqube` | `t3.medium` | `user-data/sonarqube.sh` | Code quality/security host prepared with Docker and Node Exporter |
| Nexus | `nexus` | `t3.medium` | `user-data/nexus.sh` | Artifact repository host prepared with Docker and Node Exporter |
| Grafana | `grafana` | `t3.medium` | `user-data/grafana.sh` | Monitoring host with Grafana Enterprise, Prometheus, Docker, and Node Exporter |
| Kubernetes Master | `k8s-master` | `t3.medium` | `user-data/k8s-master.sh` | Kubernetes control-plane-ready node with containerd, kubeadm, kubelet, kubectl, and Node Exporter |
| Kubernetes Worker 1 | `k8s-worker1` | `t3.medium` | `user-data/k8s-worker1.sh` | Kubernetes worker-ready node with containerd, kubeadm, kubelet, kubectl, and Node Exporter |
| Kubernetes Worker 2 | `k8s-worker2` | `t3.medium` | `user-data/k8s-worker2.sh` | Kubernetes worker-ready node with containerd, kubeadm, kubelet, kubectl, and Node Exporter |

## Repository Structure

```text
ec2-dso-terraform/
|-- main.tf
|-- provider.tf
|-- variables.tf
|-- outputs.tf
|-- .terraform.lock.hcl
|-- .gitignore
`-- user-data/
    |-- grafana.sh
    |-- jenkins.sh
    |-- k8s-master.sh
    |-- k8s-worker1.sh
    |-- k8s-worker2.sh
    |-- nexus.sh
    `-- sonarqube.sh
```

## Toolchain Components

### Jenkins

The Jenkins instance installs:

- Docker Engine and Docker Compose plugin
- Trivy for container/image security scanning
- kubectl for Kubernetes integration
- OpenJDK 21 runtime
- Jenkins from the official Jenkins Debian package repository
- Prometheus Node Exporter

Typical use cases:

- Build and deploy application pipelines
- Run static analysis and container scans
- Push artifacts to Nexus
- Deploy workloads to Kubernetes using `kubectl`

### SonarQube

The SonarQube instance is prepared with:

- Docker Engine and Docker Compose plugin
- Prometheus Node Exporter

This host is intended to run SonarQube for:

- Code quality gates
- Static code analysis
- Security hotspots
- Technical debt visibility

### Nexus

The Nexus instance is prepared with:

- Docker Engine and Docker Compose plugin
- Prometheus Node Exporter

This host is intended to run Nexus Repository Manager for:

- Maven/npm/container artifact storage
- Dependency proxying
- CI/CD artifact publishing

### Grafana and Prometheus

The Grafana instance installs:

- Docker Engine and Docker Compose plugin
- Grafana Enterprise
- Prometheus
- Prometheus Node Exporter

This host is intended for:

- Infrastructure metrics dashboards
- Prometheus target scraping
- EC2 node health visibility
- DevSecOps observability

### Kubernetes Nodes

The Kubernetes nodes install:

- containerd
- kubeadm
- kubelet
- kubectl
- Kubernetes packages pinned to `1.33.2-1.1`
- Prometheus Node Exporter

The scripts prepare the nodes for Kubernetes, but they do not automatically run `kubeadm init` or `kubeadm join`. Cluster initialization and worker joining should be performed after Terraform finishes and the instances are reachable.

## Prerequisites

Install and configure the following before running Terraform:

- Terraform `>= 1.5.0`
- AWS CLI
- AWS credentials configured locally
- An AWS account with permission to manage EC2, security groups, key pairs, AMIs, and caller identity
- An existing VPC and subnet
- An SSH key pair generated locally

Example AWS CLI authentication check:

```bash
aws sts get-caller-identity
```

Example SSH key generation:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/terra-automate-key
```

Use the public key path in `public_key_path`, for example:

```hcl
public_key_path = "~/.ssh/terra-automate-key.pub"
```

## Configuration

The main configuration values are defined in `variables.tf`.

| Variable | Description | Default |
| --- | --- | --- |
| `aws_region` | AWS region where resources are deployed | `us-east-1` |
| `key_name` | EC2 key pair name to create in AWS | `terra-automate-key` |
| `public_key_path` | Local public key file used for the AWS key pair | `/home/naveen/ec2-terra-key.pub` |
| `project_name` | Prefix used for resource names and EC2 `Name` tags | `devops-ec2` |
| `vpc_id` | Target VPC ID for the security group | `vpc-00f06f036ce76276b` |
| `subnet_id` | Target subnet ID for EC2 instances | `subnet-0b246adb236e01de7` |
| `ingress_rules` | List of inbound security group rules | See `variables.tf` |
| `tags` | Common tags applied to resources | `Environment = dev`, `Project = Terraform-EC2` |
| `root_volume_size` | Root EBS volume size in GiB | `25` |
| `root_volume_type` | Root EBS volume type | `gp3` |

Create a local `terraform.tfvars` file to override environment-specific values:

```hcl
aws_region      = "us-east-1"
project_name    = "devsecops-tools"
key_name        = "terra-automate-key"
public_key_path = "~/.ssh/terra-automate-key.pub"
vpc_id          = "vpc-xxxxxxxxxxxxxxxxx"
subnet_id       = "subnet-xxxxxxxxxxxxxxxxx"
root_volume_size = 30

tags = {
  Environment = "dev"
  Project     = "DevSecOps-Tools"
  ManagedBy   = "Terraform"
}
```

## Default Network Access

The default security group allows inbound access from `0.0.0.0/0` for the following ports:

| Port or Range | Protocol | Purpose |
| --- | --- | --- |
| `22` | TCP | SSH |
| `80` | TCP | HTTP |
| `8080` | TCP | Jenkins |
| `3000-10000` | TCP | Grafana, Prometheus, Node Exporter, SonarQube, Nexus, and related tool ports |
| `30000-32767` | TCP | Kubernetes NodePort services |
| `465` | TCP | SMTPS |
| `25` | TCP | SMTP |

For production or shared environments, restrict `cidr_blocks` to trusted IP ranges instead of `0.0.0.0/0`.

Example restricted SSH rule:

```hcl
ingress_rules = [
  {
    from        = 22
    to          = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.10/32"]
    description = "SSH from trusted workstation"
  }
]
```

## Deployment

From this directory:

```bash
cd ec2-dso-terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Approve the apply when the planned resources look correct.

After deployment, view the instance connection details:

```bash
terraform output ec2_public_ip
terraform output ec2_public_dns
```

## Accessing the Servers

SSH into an instance using the private key that matches `public_key_path`:

```bash
ssh -i ~/.ssh/terra-automate-key ubuntu@<instance-public-ip>
```

Common service URLs after provisioning:

| Service | URL Format |
| --- | --- |
| Jenkins | `http://<jenkins-public-ip>:8080` |
| Grafana | `http://<grafana-public-ip>:3000` |
| Prometheus | `http://<grafana-public-ip>:9090` |
| Node Exporter | `http://<instance-public-ip>:9100/metrics` |
| SonarQube | commonly `http://<sonarqube-public-ip>:9000` after you run SonarQube |
| Nexus | commonly `http://<nexus-public-ip>:8081` after you run Nexus |

Initial Jenkins admin password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

User-data bootstrap logs:

```bash
sudo tail -f /var/log/user-data.log
```

Service status examples:

```bash
sudo systemctl status jenkins
sudo systemctl status grafana-server
sudo systemctl status prometheus
sudo systemctl status node_exporter
```

## Kubernetes Cluster Setup

The Kubernetes scripts prepare all Kubernetes nodes with container runtime and Kubernetes packages. To initialize the cluster, SSH to the master node and run a command similar to:

```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

Configure `kubectl` for the `ubuntu` user:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Install a CNI plugin, for example Calico:

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
```

Generate or copy the worker join command from the master:

```bash
kubeadm token create --print-join-command
```

Run the generated `kubeadm join` command on `k8s-worker1` and `k8s-worker2`.

Check node status:

```bash
kubectl get nodes -o wide
```

## Suggested Post-Deployment Setup

After Terraform completes, configure the DevSecOps tools according to your workflow:

1. Complete Jenkins setup and install required plugins.
2. Add Jenkins credentials for Git, Docker registry, Nexus, SonarQube, and Kubernetes.
3. Run SonarQube and Nexus on their prepared hosts, commonly with Docker or Docker Compose.
4. Connect Jenkins to SonarQube for quality gates.
5. Connect Jenkins to Nexus for artifact publishing.
6. Initialize the Kubernetes cluster and configure Jenkins with a kubeconfig.
7. Configure Prometheus scrape targets for each Node Exporter endpoint.
8. Build Grafana dashboards for EC2, Jenkins, Kubernetes, and application metrics.

## Outputs

This project exposes the following Terraform outputs:

| Output | Description |
| --- | --- |
| `aws_account_id` | AWS Account ID used by Terraform |
| `aws_caller_arn` | ARN of the authenticated IAM principal |
| `aws_user_id` | Unique identifier of the authenticated IAM principal |
| `ec2_public_ip` | Map of EC2 role names to public IP addresses |
| `ec2_public_dns` | Map of EC2 role names to public DNS names |

Example:

```bash
terraform output ec2_public_ip
```

## Security Considerations

- Replace open CIDR ranges with trusted source IP ranges.
- Avoid committing private keys, `.tfvars` files with sensitive values, or Terraform state files.
- Use least-privilege IAM permissions for Terraform.
- Consider encrypted EBS volumes for sensitive workloads.
- Store Jenkins, Nexus, SonarQube, Docker, and Kubernetes credentials in secure credential stores.
- Rotate initial passwords and tokens after first login.
- Review tool versions periodically and update user-data scripts as needed.
- Avoid `chmod 666 /var/run/docker.sock` in hardened environments because it grants broad Docker control on the host.

## Cost Awareness

This project creates seven EC2 instances. Running all instances continuously can incur meaningful AWS charges.

To reduce cost:

- Stop instances when not in use.
- Use smaller instance types only after validating tool requirements.
- Destroy the environment after labs or demos.
- Monitor EBS, public IPv4, and data transfer charges.

## Cleanup

Destroy all resources managed by this Terraform project:

```bash
terraform destroy
```

Confirm the destroy plan before approving.

## Troubleshooting

If provisioning fails or a service is unavailable:

- Check EC2 system status checks in the AWS Console.
- Review user-data logs with `sudo tail -f /var/log/user-data.log`.
- Confirm the security group allows the required port.
- Confirm the service is running with `systemctl status`.
- Verify that the public key path exists before running `terraform apply`.
- Run `terraform validate` to catch syntax or provider configuration issues.
- Re-run `terraform plan` after changing variables.

Useful checks:

```bash
docker --version
kubectl version --client
trivy --version
sudo systemctl status node_exporter
```

## Notes

- The EC2 instances use the latest matching Ubuntu 24.04 AMI at apply time.
- SonarQube and Nexus hosts are prepared with Docker but the current scripts do not start SonarQube or Nexus containers.
- Kubernetes nodes are prepared but the cluster is not initialized automatically.
- Prometheus is installed on the Grafana node, but scrape targets should be reviewed and customized for the public or private IP addresses in your environment.
