
######### VPC creation

resource "aws_vpc" "hibora_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    name = "hibora_vpc_India"
  }
}

########## Creating Igw


resource "aws_internet_gateway" "hibora_Igw" {
  vpc_id = aws_vpc.hibora_vpc.id
  depends_on = [aws_vpc.hibora_vpc]

  tags = {
    name = "hibora_Igw_India"
  }
}

########## creating NAT gateway & eip

resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "aws_nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = aws_subnet.public_subnet.0.id
}


######### creating public route table

resource "aws_route_table" "hibora_public_rt" {
  vpc_id = aws_vpc.hibora_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hibora_Igw.id
  }

  tags = {
    name = "hibora_publicrt_India"
  }
}


############ creating pvt route table

resource "aws_route_table" "hibora_pvt_rt" {
  vpc_id = aws_vpc.hibora_vpc.id

  route {
    nat_gateway_id =aws_nat_gateway.aws_nat.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    name = "hibora_pvtrt_India"
  }
}


################### Creating public subnet

resource "aws_subnet" "public_subnet" {
  count = 2
  cidr_block = var.pub_cidr[count.index]
  vpc_id = aws_vpc.hibora_vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name = "borahi_test-public_subnet.${count.index + 1}"
  }


#################### Creating private subnet

  }
resource "aws_subnet" "private_subnet" {
  count = 2
  cidr_block = var.pvt_cidr[count.index]
  vpc_id = aws_vpc.hibora_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    name = "borahi_test-pvt_subnet.${count.index + 1}"
  }
}

###################### Associate the route table (public)

resource "aws_route_table_association" "public_asso_rt" {
  count = 2
  route_table_id = aws_route_table.hibora_public_rt.id
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  depends_on = [aws_subnet.public_subnet, aws_route_table.hibora_public_rt]
}

#################### Associate the pvt route table (pvt)

resource "aws_route_table_association" "pvt_asso_rt" {
  count = 2
  route_table_id = aws_route_table.hibora_pvt_rt.id
  subnet_id = aws_subnet.private_subnet.*.id[count.index]
  depends_on = [aws_route_table.hibora_pvt_rt, aws_subnet.private_subnet]
}

##############  aws security group

resource "aws_security_group" "borahi_sg" {
  vpc_id = aws_vpc.hibora_vpc.id
  tags = {
    name = "borahi_sg"
  }
}

################ Ingress and Egress rule

resource "aws_security_group_rule" "inbound_access" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.borahi_sg.id
  to_port = 0
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbond_access" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.borahi_sg.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

