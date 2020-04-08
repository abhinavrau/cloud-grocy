resource "aws_internet_gateway" "grocy-gw" {
  vpc_id = aws_vpc.grocy_vpc.id
  tags = {
    Name = "grocy-gw"
  }
}