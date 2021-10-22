# codewar-web-infrastructure

# About

This repo contains infrastructre for https://github.com/nimblehq/codewar-web/pulls.

# Dependencies

* Terraform v0.14.4

# Setup

* Clone the repository.
* Cd into respective directory, eg.
  - `cd staging`
* Copy db credentials from the1password into `{env_name}/variables.tf`
* Run terraform plan
  - `terraform plan`
* Run terraform apply
  - `terraform apply`

# Destroy

* Cd into respective directory, then run
- `terraform destroy`
