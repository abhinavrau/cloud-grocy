data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet-grocy" {
  cidr_block = cidrsubnet(aws_vpc.grocy_vpc.cidr_block, 3, 1)
  vpc_id = aws_vpc.grocy_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_route_table" "route-table-grocy" {
  vpc_id = aws_vpc.grocy_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.grocy-gw.id
  }
  tags = {
    Name = "route-table-grocy"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id = aws_subnet.subnet-grocy.id
  route_table_id = aws_route_table.route-table-grocy.id
}