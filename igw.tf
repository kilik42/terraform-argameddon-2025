# Create an Internet Gateway
# This allows instances in the VPC to access the internet
# the IGW is attached to the VPC
# the IGW is used by the NAT gateway to route traffic to the internet
#examples of use cases: software updates, downloading packages, etc.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.env}-igw"
  }
}

# Attach the Internet Gateway to the VPC
# resource "aws_internet_gateway_attachment" "igw_attachment" {
#     vpc_id             = aws_vpc.main.id
#     internet_gateway_id = aws_internet_gateway.igw.id
#     }   

    
# The attachment is required for the IGW to function
# without the attachment, the IGW will not be able to route traffic to the internet