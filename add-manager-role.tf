data "aws_caller_identity" "current" {
    # This data source can be used to get the current AWS account ID
    # The account ID can be accessed using data.aws_caller_identity.current.account_id
    # account_id = data.aws_caller_identity.current.account_id

}

resource "aws_iam_role" "eks_admin" {
  name = "${local.env}-${local.eks_name}-manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  
}

# Attach the AmazonEKSClusterPolicy to the role
resource "aws_iam_policy" "eks_admin"{
    name = "${local.env}-${local.eks_name}-manager-policy"
    
    description = "Policy to allow manager role to access EKS cluster"
    
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

resource "aws_iam_role_policy_attachment" "eks_admin_attach" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_user" "manager" {
  name = "manager"
}

resource "aws_iam_policy" "eks_assume_policy" {
  name        = "${local.env}-${local.eks_name}-assume-role-policy"
  description = "Policy to allow user to assume the EKS manager role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.eks_admin.arn
      },
    ]
  })
}