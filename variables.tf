variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "ccr-pathways-dojo-weather-app-s3-bucket"
}

variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default     = {}
}

variable "image_uri" {
  type = string
}
# variable "vpc_cidr" {
#     type = string
# }

# variable "subnet_mappings_priv" {
#     type = map(object({
#         cidr = string
#         az   = string
#         name = string
#     }))
# }

# variable "subnet_mappings_pub" {
#     type = map(object({
#         cidr = string
#         az   = string
#         name = string
#     }))
# }

