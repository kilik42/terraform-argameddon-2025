

### 🔹 GitHub Repo Description

```
Terraform + EKS project for Theo University Class 6: Armageddon. Includes network automation (Envoy, Prometheus, Grafana), web app deployments, and IAM setup.
```

---

### 🔹 README.md

```markdown
# Theo University – Class 6: AWS Armageddon

**Start:** July 17 @ 1 PM  
**Due:** September 5 @ 1 PM  

This repo contains my work for the **AWS Armageddon project**. The focus is on using Terraform and Kubernetes to build and manage cloud infrastructure on AWS. This project demonstrates end-to-end cloud infrastructure automation and application deployment on AWS using Terraform, Kubernetes (EKS), and Docker. The work covers multiple areas of cloud engineering: designing a secure and highly available VPC with public and private subnets, automating the provisioning of an EKS cluster, and deploying monitoring tools like Envoy, Prometheus, and Grafana to provide traffic visibility and performance insights. On the application side, the project delivers three independently containerized web applications running in Kubernetes pods with self-healing and high availability features, each exposed on unique non-standard ports to simulate multi-service production workloads. Security and identity management are also addressed by building an IAM group with S3 ReadOnly access and onboarding users with console access through Terraform variables for reusability. Altogether, this project shows practical experience with Infrastructure as Code (IaC), container orchestration, monitoring stacks, and cloud security—skills directly relevant to DevOps, cloud engineering, and site reliability roles.

---

## Project Tasks

### Task 1 – Network Automation
Automated the setup of **Envoy**, **Prometheus**, and **Grafana** inside an EKS cluster.  
The goal is to reduce manual setup and give the network team visibility and traffic management tools.

### Task 2 – Application Deployment
Deployed **3 separate web applications** in Kubernetes:
- Each app runs in self-healing pods
- Each uses a unique Docker image and port
- Apps are highly available and externally accessible

### Task 3 – Security and IAM
Created an **IAM group** with:
- **S3 Read-Only access**
- **Bedrock Admin access**  

IAM users were added to this group with console access only (no keys), and the Terraform code uses variables for flexibility.

---

## Repo Structure
```

terraform/        # VPC, subnets, routes, NAT, EKS setup
apps/             # Dockerfiles + Kubernetes manifests for apps
monitoring/       # Envoy, Prometheus, Grafana configs
README.md

````

---

## How to Run
1. Clone the repo and move into the Terraform folder:
   ```bash
   git clone https://github.com/<your-username>/armageddon.git
   cd armageddon/terraform
````

2. Initialize and apply Terraform:

   ```bash
   terraform init
   terraform apply
   ```
3. Update kubeconfig:

   ```bash
   aws eks update-kubeconfig --name <eks-cluster-name> --region <region>
   ```
4. Deploy monitoring tools and apps:

   ```bash
   kubectl apply -f monitoring/
   kubectl apply -f apps/
   ```

---

## Notes

* Screenshots of the cluster, apps, and IAM setup will be added here.


---

**Author:** Marvin Evins
Theo University – AWS Class 6

```
