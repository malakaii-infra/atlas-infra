resource "aws_vpc" "atlas" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "atlas-vpc"
  }
}

resource "aws_internet_gateway" "atlas" {
  vpc_id = aws_vpc.atlas.id

  tags = {
    Name = "atlas-igw"
  }
}

# -------------------------
# Public subnets
# -------------------------

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.atlas.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "atlas-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.atlas.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "atlas-public-b"
  }
}

# -------------------------
# Private subnets
# -------------------------

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.atlas.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "atlas-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.atlas.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "atlas-private-b"
  }
}

# -------------------------
# Public routing
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.atlas.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.atlas.id
  }

  tags = {
    Name = "atlas-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# NAT Gateway
# -------------------------

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "atlas-nat-eip"
  }
}

resource "aws_nat_gateway" "atlas" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.atlas
  ]

  tags = {
    Name = "atlas-nat"
  }
}

# -------------------------
# Private routing
# -------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.atlas.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.atlas.id
  }

  tags = {
    Name = "atlas-private"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}