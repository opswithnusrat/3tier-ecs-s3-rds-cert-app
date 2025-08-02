# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "this" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
    count             = var.az_count
    cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.this.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
    count                   = var.az_count
    cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, var.az_count + count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    vpc_id                  = aws_vpc.this.id
    map_public_ip_on_launch = true
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.this.id
}
# Route the public subnet traffic through the IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "public" {
   count          = var.az_count
    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = element(aws_route_table.public.*.id, count.index)
}


resource "aws_eip" "this" {
  domain = "vpc"

}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}



resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
    subnet_id      = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}
