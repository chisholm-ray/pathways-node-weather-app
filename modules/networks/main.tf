
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.vpc_name}"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.ap-southeast-2.s3"
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  for_each = { for subnet in var.subnet_mappings_priv : subnet.name => subnet }
  vpc_id   = aws_vpc.main.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    "Name" = "${each.value.name}"
    "Type" = "Private"
  }
}

resource "aws_subnet" "public" {
  for_each = { for subnet in var.subnet_mappings_pub : subnet.name => subnet }
  vpc_id   = aws_vpc.main.id

  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    "Name" = "${each.value.name}"
    "Type" = "Public"
  }
}

resource "aws_eip" "nat" {
  for_each = { for subnet in var.subnet_mappings_priv : subnet.name => subnet}
  vpc = true
    tags = {
    "Name" = "ccr-${each.value.name}-eip"
  }
}

resource "aws_nat_gateway" "private" {
  depends_on = [
    aws_subnet.private
  ]
  for_each          = { for subnet in var.subnet_mappings_priv : subnet.name => subnet }
  subnet_id         = aws_subnet.private[each.key].id
  connectivity_type = "public"
  allocation_id     = aws_eip.nat[each.key].allocation_id
  tags = {
    "Name" = "ccr-${each.value.name}-natgw"
  }
}


resource "aws_route_table" "private" {
  for_each = { for subnet in var.subnet_mappings_priv : subnet.name => subnet }
  vpc_id   = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private[each.key].id
  }

  tags = {
    "Name" = "ccr-${each.value.name}-rt"
    "Type" = "Private"
  }
}


resource "aws_route_table" "public" {
  for_each = { for subnet in var.subnet_mappings_pub : subnet.name => subnet }
  vpc_id = aws_vpc.main.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.public.id
  }
    tags = {
    "Name" = "ccr-${each.value.name}-rt"
    "Type" = "Public"
  }  
}

resource "aws_route_table_association" "private" {
    depends_on = [
      aws_route_table.private,
      aws_subnet.private
    ]
  for_each = { for subnet in var.subnet_mappings_priv : subnet.name => subnet }
  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}


resource "aws_route_table_association" "public" {
    depends_on = [
      aws_route_table.public,
      aws_subnet.public
    ]
  for_each = { for subnet in var.subnet_mappings_pub : subnet.name => subnet }
  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

output "ccr_vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_a" {
  value = aws_subnet.public["ccr-dojo-public-a"].id
  
}

output "public_subnet_b" {
  value = aws_subnet.public["ccr-dojo-public-b"].id
  
}