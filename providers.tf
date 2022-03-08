provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Terraform = "true"
      Owner     = "CCR"
      Project   = "Weather-App"
    }
  }
}
