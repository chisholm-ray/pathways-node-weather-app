
# locals {

#   vpc_cidr = "10.0.10.0/24"

#   subnet_mappings_priv = {

#     "subnet_1" = {
#       cidr = "10.0.10.0/26"
#       az   = "ap-southeast-2a"
#       name = "ccr-dojo-private-a"
#     }

#     "subnet_2" = {
#       cidr = "10.0.10.64/26"
#       az   = "ap-southeast-2b"
#       name = "ccr-dojo-private-b"
#     }

#     "subnet_3" = {
#       cidr = "10.0.10.128/26"
#       az   = "ap-southeast-2c"
#       name = "ccr-dojo-private-c"
#     }
#   }

#   subnet_mappings_pub = {

#     "subnet_1" = {
#       cidr = "10.0.10.192/28"
#       az   = "ap-southeast-2a"
#       name = "ccr-dojo-public-a"
#     }

#     "subnet_2" = {
#       cidr = "10.0.10.208/28"
#       az   = "ap-southeast-2b"
#       name = "ccr-dojo-public-b"
#     }

#     "subnet_3" = {
#       cidr = "10.0.10.224/28"
#       az   = "ap-southeast-2c"
#       name = "ccr-dojo-public-c"
#     }
#   }

  #   networks_priv = toset(flatten([for subnet_name, values in var.subnet_mappings_priv: [{
  #                             subnet_name = subnet_name
  #                             cidr = values.cidr
  #                             az  = values.az
  #                             }]     

  #                          ]))

#}

# data "aws_availability_zones" "this" {  
# }

module "networks"{
  source = "./modules/networks"
  vpc_cidr = "10.0.10.0/24"
  vpc_name = "ccr-dojo-pathways"

  subnet_mappings_priv = {
    "subnet_1" = {
      cidr = "10.0.10.0/26"
      az   = "ap-southeast-2a"
      name = "ccr-dojo-private-a"
      }
    "subnet_2" = {
      cidr = "10.0.10.64/26"
      az   = "ap-southeast-2b"
      name = "ccr-dojo-private-b"
      }
    "subnet_3" = {
      cidr = "10.0.10.128/26"
      az   = "ap-southeast-2c"
      name = "ccr-dojo-private-c"
      }
  }

  subnet_mappings_pub = {
    "subnet_1" = {
      cidr = "10.0.10.192/28"
      az   = "ap-southeast-2a"
      name = "ccr-dojo-public-a"
      }
    "subnet_2" = {
      cidr = "10.0.10.208/28"
      az   = "ap-southeast-2b"
      name = "ccr-dojo-public-b"
      }
    "subnet_3" = {
      cidr = "10.0.10.224/28"
      az   = "ap-southeast-2c"
      name = "ccr-dojo-public-c"
      }
  }
}

# module "s3_bucket" {
#   source = "./modules/s3"
#   bucket = var.bucket

#   tags = var.tags
# }

# output "bucket_name" {
#   description = "The name of the bucket"
#   value       = ["${module.s3_bucket.s3_bucket_name}"]
# }

# output "bucket_name_arn" {
#   description = "The name of the bucket"
#   value       = ["${module.s3_bucket.s3_bucket_name_arn}"]

# }


# output "public_subnet_a" {
#   value = module.networks.aws_subnet.public["ccr-dojo-public-a"].id
  
# }

# output "public_subnet_b" {
#   value = module.networks.aws_subnet.public["ccr-dojo-public-b"].id
  
# }