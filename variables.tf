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