provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {
        encrypt = true
        bucket = "illustrious-kingdom-terraform-state"
        region = "us-east-1"
        key = "global/s3/terraform.tfstate"
    }
}