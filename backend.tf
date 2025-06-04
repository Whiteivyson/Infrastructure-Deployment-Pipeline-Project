
terraform {
  backend "s3" {
    bucket         = "beatstar-tf-backend-1999"
    key            = "global/infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "BeatStar-tf-locks"
    encrypt        = true
  }
}
