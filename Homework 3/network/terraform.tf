terraform {
  backend "s3" {
    bucket                  = "devops-terraform-vlasenko"
    key                     = "network/terraform.tfstate"
    region                  = "eu-central-1"
    dynamodb_table          = "devops-terraform-vlasenko"
    shared_credentials_file = "/home/dmitry/Lessons-Hillel/Homework 3/creds"
    profile                 = "default"
  }
}
