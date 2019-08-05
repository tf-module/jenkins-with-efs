variable "efs_id" {
  description = "EFS ID that host jenkins_home files"
}

variable "public_zone_id" {
  description = "public routes53 zone_id"
}

locals {
  az_count           = 1
}