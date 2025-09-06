# This file contains the route tables for the VPC
# The route tables control the routing of traffic within the VPC
# Each subnet must be associated with a route table
# Public subnets are associated with the public route table
# Private subnets are associated with the private route table
# The public route table routes traffic to the internet gateway

################ route tables for public subnets ####################
#public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.env}-public-rt"
  }
}

# This resource creates a route in the public route table
# The route directs all traffic 
# resource "aws_route" "public_internet_access" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }

# This resource associates the public subnet with the public route table
resource "aws_route_table_association" "public_zone_1" {
  subnet_id      = aws_subnet.public_zone_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone_2" {
  subnet_id      = aws_subnet.public_zone_2.id
  route_table_id = aws_route_table.public.id
}
############### route tables for private subnets ####################
#private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.env}-private-rt"
  }
}

# This resource creates a route in the private route table
# The route directs all traffic to the NAT gateway
# resource "aws_route" "private_internet_access" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# This resource associates the private subnet with the private route table
resource "aws_route_table_association" "private_zone_1" {
  subnet_id      = aws_subnet.private_zone_1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_zone_2" {
  subnet_id      = aws_subnet.private_zone_2.id
  route_table_id = aws_route_table.private.id
}

# --- IGNORE ---
# cat ~/.aws/credentials