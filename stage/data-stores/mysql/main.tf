terraform {
    backend "s3" {
        encrypt = true
        bucket = "illustrious-kingdom-terraform-state"
        region = "us-east-1"
        key = "stage/data-stores/mysql/terraform.tfstate"
    }
}

module "mysql" {
    source = "../../../modules/data-stores/mysql"
    db_name = "db-stage"
    db_username = "admin"
    db_password = "adifferentpassword"
}