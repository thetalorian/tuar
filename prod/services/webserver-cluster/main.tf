terraform {
    backend "s3" {
        encrypt = true
        bucket = "illustrious-kingdom-terraform-state"
        region = "us-east-1"
        key = "prod/services/webserver-cluster/terraform.tfstate"
    }
}

module "webserver_cluster" {
    source = "../../../modules/services/webserver-cluster"
    cluster_name = "webservers-prod"
    db_remote_state_bucket = "illustrious-kingdom-terraform-state"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
}