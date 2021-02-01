# terraform-k8s-airflow

## Install Terraform

First, install the HashiCorp tap, a repository of all our Homebrew packages.

$ brew tap hashicorp/tap

Now, install Terraform with hashicorp/tap/terraform.

$ brew install hashicorp/tap/terraform

To update to the latest, run

$ brew upgrade hashicorp/tap/terraform

### Enable tab completion

$ terraform -install-autocomplete

## Provision infrastructure with Terraform

Initialize the project, which downloads plugins that allow Terraform to interact with services

$ terraform init

Preview the provisionning of the infrastructure

$ terraform plan 
or 
$ terraform plan -out ~file~
and
$ terraform apply ~file~
then 
$ yes

$ terraform destroy 
then 
$ yes

Provision with variables from a file 

$ terraform apply -var-file dev.tfvars

Destroy with variables from a file 

$ terraform destroy -var-file dev.tfvars