resource "aws_iam_user" "developer" {
  name = "developer"
  force_destroy = true
  tags = {
    Name = "developer-user"
  }
}

resource "aws_iam_policy" "developer_eks" {
  name = "developer-eks-policy"
  
  description = "Policy to allow developer user to access EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:ListClusters",
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "eks:ListFargateProfiles",
          "eks:DescribeFargateProfile",
          "eks:ListUpdates",
          "eks:DescribeUpdate",
          "eks:ListAddons",
          "eks:DescribeAddon",
          "eks:ListIdentityProviderConfigs",
          "eks:DescribeIdentityProviderConfig",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
    ]
  })
}

#attach the AmazonEKSClusterPolicy to the developer user
resource "aws_iam_user_policy_attachment" "developer_AmazonEKSClusterPolicy" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_eks.arn

}

resource "aws_eks_access_entry" "developer_access" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = aws_iam_user.developer.arn
  kubernetes_groups = ["viewer-user"] # this group is created in the viewer-cluster-role.yaml file
}

# Create access keys for the developer user
# resource "aws_iam_access_key" "developer_access_key" {
#   user = aws_iam_user.developer.name
# }

# # Create output for the developer access key ID
# output "developer_access_key_id" {
#   value = aws_iam_access_key.developer_access_key.id
#     sensitive = true
# }
