resource "aws_subnet" "private_zone_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.zone1

  tags = {
    Name                                = "${local.env}-private-${local.zone1}-subnet"
    "kubernetes.io/role/internal-elb"      = "1" # for private subnets and load balancers
    "kubernetes.io/cluster/${local.eks_name}" = "owned" # for EKS cluster recognition
    # the reason for EKS CLUSTER recognition is to allow the EKS to manage the lifecycle of the subnet
    #it is owned by the cluster and will be deleted when the cluster is deleted
    #its not shared with other clusters because we are using a single cluster for this project
  }
}


resource "aws_subnet" "private_zone_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = local.zone2

  tags = {
    Name = "${local.env}-private-${local.zone2}-subnet"
    "kubernetes.io/role/internal-elb"      = "1" # for private subnets and load balancers
    "kubernetes.io/cluster/${local.eks_name}" = "owned" # for EKS cluster recognition
    # the reason for EKS CLUSTER recognition is to allow the EKS to manage the lifecycle of the subnet
    #it is owned by the cluster and will be deleted when the cluster is deleted
    #its not shared with other clusters because we are using a single cluster for this project
  }
}

###################### public subnets################################
resource "aws_subnet" "public_zone_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = local.zone1

  tags = {
    Name                                = "${local.env}-public-${local.zone1}-subnet"
    "kubernetes.io/role/elb"      = "1" # for private subnets and load balancers
    "kubernetes.io/cluster/${local.eks_name}" = "owned" # for EKS cluster recognition
    # the reason for EKS CLUSTER recognition is to allow the EKS to manage the lifecycle of the subnet
    #it is owned by the cluster and will be deleted when the cluster is deleted
    #its not shared with other clusters because we are using a single cluster for this project
  }
}

resource "aws_subnet" "public_zone_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = local.zone2

  tags = {
    Name                                = "${local.env}-public-${local.zone2}-subnet"
    "kubernetes.io/role/elb"      = "1" # for private subnets and load balancers
    "kubernetes.io/cluster/${local.eks_name}" = "owned" # for EKS cluster recognition
    # the reason for EKS CLUSTER recognition is to allow the EKS to manage the lifecycle of the subnet
    #it is owned by the cluster and will be deleted when the cluster is deleted
    #its not shared with other clusters because we are using a single cluster for this project
  }
}

