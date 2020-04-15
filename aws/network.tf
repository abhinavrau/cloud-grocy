//network.tf
resource "aws_vpc" "grocy_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    name = "grocy_vpc"
  }
}
//
//resource "aws_eip" "ip-grocy" {
//  instance = aws_instance.grocy-ec2-instance.id
//  vpc = true
//}
