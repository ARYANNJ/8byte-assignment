terraform {
  backend "s3" {
    bucket       = "8byte-terraform-state-file"
    key          = "env/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}