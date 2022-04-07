# Deployment Steps

1. Generate SSH key and put the path to it in `variables.tf`
2. Create a Fernet key and put it in [WIP]
3. voter manifest or something [WIP]
4. `terraform plan`
5. `terraform apply`
6. SSH into the deploy box, run ansible