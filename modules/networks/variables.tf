
variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default     = {}
}

variable "vpc_cidr" {
    type = string
}

variable "vpc_name" {
    type = string
}

variable "subnet_mappings_priv" {
    type = map(object({
        cidr = string
        az   = string
        name = string
    }))
}

variable "subnet_mappings_pub" {
    type = map(object({
        cidr = string
        az   = string
        name = string
    }))
}
