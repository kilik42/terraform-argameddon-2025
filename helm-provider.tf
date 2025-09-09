

# we need to get the cluster details and auth info from the EKS cluster we created
# this is needed to configure the helm provider to connect to the EKS cluster
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks_cluster.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks_cluster.name
}

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks.token
# }

provider "helm" {
  kubernetes {
    config_path      = pathexpand("~/.kube/config")
    config_context   = "arn:aws:eks:us-east-1:129762072419:cluster/my-eks-cluster"
    
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}