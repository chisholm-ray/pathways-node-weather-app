terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "pathways-dojo"
    key    = "chisholm-ray-tfstate-main"
    region = "us-east-1"
  }
}