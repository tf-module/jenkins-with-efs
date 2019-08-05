terraform {
  backend "s3" {
    bucket = "siglus-tf-config-nonprod"
    key    = "jenkins-efs.tfstate"
    region = "ap-south-1"
  }
}