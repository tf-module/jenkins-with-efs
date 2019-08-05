data "aws_availability_zones" "available" {
}
resource "aws_vpc" "cicd_vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "CICD VPC"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cicd_vpc.id
}
# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count             = local.az_count
  cidr_block        = cidrsubnet(aws_vpc.cicd_vpc.cidr_block, 8, local.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.cicd_vpc.id
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.cicd_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
