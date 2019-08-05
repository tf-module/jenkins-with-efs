# tf-jenkins-efs

An Terraform project to create a Jenkins Service, Including the following modules:
- EC2 instance and install Jenkins, and mount EFS
- VPC/Networks, private subnet
- DNS Records
- EFS mount target, at private subnet
- Security Groups


## Pre-environment

Before running this terraform script you should 
- Set AWS Credential

```
export AWS_ACCESS_KEY_ID=xxxxx         
export AWS_SECRET_ACCESS_KEY=xxxxx
```

- Create a S3 bucket for Terraform backend, you can get the bucket name at [backend.tf](backend.tf)

## Set up

### create EFS
The storage.tf file In the folder /storage  is to create an EFS for persistence of Jenkins, it's sperated from Jenkins terraform config.
```
cd storage
terraform apply -auto-approve
```

### Create Jenkins relating modules

```
terraform apply -var "efs_id={the efs id you got at above step}" -var "public_zone_id={routes53 public zone id}" -auto-approve
```




