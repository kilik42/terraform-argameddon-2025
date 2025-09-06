resource "aws_iam_role" "nodes" {
  name = "${local.env}-${local.eks_name}-nodes-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    Name = "${local.env}-eks-nodes-role"
  }
}

#this policy now includes AssumeRoleForPodIdentity for the Pod identity agent
resource "aws_iam_role_policy_attachment" "nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

#node group 

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks_node_group"
  version         = local.eks_version
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids = [

    aws_subnet.private_zone_1.id,
    aws_subnet.private_zone_2.id,
  ] #we are using only private subnets for the nodes


  instance_types = ["t3.medium"] #you can change this to your desired instance type
  disk_size      = 20            #you can change this to your desired disk size
  ami_type       = "AL2_x86_64"  #Amazon Linux 2 AMI
  capacity_type  = "ON_DEMAND"   #you can change this to SPOT if you want to use spot instances


  scaling_config {
    desired_size = 6
    max_size     = 23
    min_size     = 3
  }


  labels = {
    role = "nodes-for-${local.env}-environment"
  }

  tags = {
    Name = "${local.env}-eks-node-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEC2ContainerRegistryReadOnly,
  ]

  # allow the node group to be created even if the desired size is changed outside of Terraform

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size] # this will ignore changes to the scaling config after the initial creation
  }
}


