provider "aws" {
    region = "ap-southeast-1"
}   

terraform {
    backend "s3" {
        bucket = "terraform-devops-backend-file"
        region = "ap-southeast-1"
        key = "terraform.tfstate"
        encrypt = true
        use_lockfile = true
    }
}
