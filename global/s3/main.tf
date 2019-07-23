resource "aws_s3_bucket" "terraform_state" {
    bucket = "illustrious-kingdom-terraform-state"
    versioning {
        enabled = true
    }

    lifecycle {
        prevent_destroy = true
    }
  
}