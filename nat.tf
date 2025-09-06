# nat gateway is meant to translate private subnet traffic to the internet
# it is not meant to be used for incoming traffic

# this resource creates an elastic IP for the NAT gateway
# the elastic IP is a static IP that is used to route traffic from the NAT gateway to the internet
# the elastic IP is associated with the NAT gateway
#why elastic IP? because it is a static IP that does not change
# if we use a regular IP, it will change when the NAT gateway is restarted
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.env}-nat-eip"
  }
}

# this resource creates a NAT gateway in the public subnet
# the NAT gateway is used to route traffic from the private subnets to the internet

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone_1.id

  tags = {
    Name = "${local.env}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}


