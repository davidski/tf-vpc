resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "niddel"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
      Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags {
    Name = "main"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.r.id}"
}
