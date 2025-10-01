# backend.tf
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket" # Replace
    key            = "ec2-instance/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks" # Replace
  }
}
