# backend.tf

# NOTE: The S3 Bucket MUST exist before the first 'terraform init' is run!
# You will need to create this S3 bucket manually in the AWS Console (in us-west-2).

terraform {
  backend "s3" {
    bucket         = "itcne24bucket" # <<< CRITICAL: CHANGE THIS TO A UNIQUE BUCKET NAME!
    key            = "ec2-instance/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock" # Optional: Prevents concurrent modification
  }
}

# The AWS provider configuration must also be present (usually in main.tf or providers.tf)
provider "aws" {
  region = "us-west-2" # Match this to the backend region and your AWS_REGION env var
}
