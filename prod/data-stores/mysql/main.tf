terraform {
    backend "s3" {
        encrypt = true
        bucket = "illustrious-kingdom-terraform-state"
        region = "us-east-1"
        key = "prod/data-stores/mysql/terraform.tfstate"
    }
}

module "mysql" {
    source = "../../../modules/data-stores/mysql"
    db_name = "db-prod"
    db_username = "admin"
    db_password = "amoredifferentpassword"
}