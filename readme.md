

# Theo University – Class 6: AWS Armageddon

**Start:** July 17 @ 1:00 PM


This repository documents my work for the **AWS Armageddon project**. The project centers on building and managing cloud infrastructure on AWS using **Terraform** and **Kubernetes (EKS)**. It showcases end-to-end automation: from networking and security to containerized application deployments and monitoring.

Key highlights include:

* **Infrastructure as Code (IaC):** Designed a secure, highly available VPC with both public and private subnets, provisioned through Terraform.
* **Kubernetes Orchestration:** Automated the setup of an EKS cluster and deployed multiple workloads across self-healing pods.
* **Monitoring & Observability:** Integrated Envoy, Prometheus, and Grafana to track performance, manage traffic, and provide visibility.
* **Application Deployment:** Launched three independently containerized web applications, each exposed on distinct non-standard ports to simulate a multi-service production environment.
* **Security & IAM:** Configured an IAM group with S3 ReadOnly and Bedrock Admin policies. Onboarded users with console access only, keeping credentials secure and Terraform code reusable through variables.

Overall, this work reflects practical experience in cloud automation, container orchestration, monitoring, and identity management—skills directly relevant to DevOps, cloud engineering, and SRE roles.

---

## Project Tasks

### Task 1 – Network Automation

Automated deployment of **Envoy**, **Prometheus**, and **Grafana** within the EKS cluster to provide the networking team with visibility and traffic-management tools.

### Task 2 – Application Deployment

Deployed **three separate web applications** in Kubernetes:

* Each app runs in a self-healing pod.
* Each uses a unique Docker image and port.
* All applications are externally accessible and highly available.

### Task 3 – Security and IAM

Created an **IAM group** with:

* **S3 Read-Only Access**
* **Bedrock Admin Access**

IAM users were added with **console-only access** (no keys). Terraform variables were used to maintain flexibility and reusability.


Initialize Terraform
cd envs/dev
terraform init

Review and Apply the Plan
terraform plan
terraform apply -auto-approve

Update Kubeconfig
aws eks update-kubeconfig --name <your-cluster-name> --region <your-region>

Deploy Applications
kubectl apply -f modules/apps/app1-deployment.yaml
kubectl apply -f modules/apps/app2-deployment.yaml
kubectl apply -f modules/apps/app3-deployment.yaml

Verify Deployments
kubectl get pods
kubectl get svc
