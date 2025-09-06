# IAM role for EKS cluster

resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.env}-${local.eks_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${local.env}-eks-cluster-role"
  }
}

# eks cluster role policy attachment
# Attach the AmazonEKSClusterPolicy and AmazonEKSServicePolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# eks cluster role policy attachment

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

#container registry for the EKS cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role.name
}




resource "aws_eks_cluster" "eks_cluster" {
  name     = local.eks_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = local.eks_version

  vpc_config {
    #we are using both public and private subnets for the EKS cluster
    #this is because we want to use the public subnets for the load balancer
    endpoint_private_access = false # this has to be false if we want to access the cluster via public endpoint
    endpoint_public_access  = true # this has to be true if we want to access the cluster via public endpoint
    #we are using all the subnets in the VPC for the EKS cluster


    subnet_ids = [
      aws_subnet.public_zone_1.id,
      aws_subnet.public_zone_2.id,
      aws_subnet.private_zone_1.id,
      aws_subnet.private_zone_2.id,
    ]
  }
  

  access_config {
    # this will create a public endpoint for the EKS cluster
    # this is required for the kubectl to access the cluster
    # without this, we will not be able to access the cluster
    # we can also use a private endpoint, but that requires a VPN or Direct Connect
    # for simplicity, we are using a public endpoint
    # in a production environment, we should use a private endpoint
    # and access the cluster via a VPN or Direct Connect

    #AUTHENTICATION MODES:
    #1. API - allows access via the AWS Management Console, AWS CLI, or AWS SDKs
    #2. IAM - allows access via IAM roles and policies
    authentication_mode = "API"

    #bootstrap cluster creator admin permissions
    #when this is set to true, the IAM user or role that creates the cluster
    #will be granted system:masters permissions in the cluster's RBAC configuration
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = "${local.env}-eks-cluster"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEC2ContainerRegistryReadOnly
  ]
}