resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private-subnet-one" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_block_one
  availability_zone       = var.availability_zone_one
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

resource "aws_subnet" "public-subnet-one" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_block_one
  availability_zone       = var.availability_zone_one
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_subnet" "private-subnet-two" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_block_two
  availability_zone       = var.availability_zone_two
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-subnet-two"
  }
}

resource "aws_subnet" "public-subnet-two" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_block_two
  availability_zone       = var.availability_zone_two
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-two"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private-subnet-one.id
  route_table_id = aws_route_table.private-route-table.id
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public-subnet-one.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-association-two" {
  subnet_id      = aws_subnet.public-subnet-two.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-association-two" {
  subnet_id      = aws_subnet.private-subnet-two.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-igw.id
}

