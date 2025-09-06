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