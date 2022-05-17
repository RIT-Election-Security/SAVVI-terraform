# Deployment Steps

1. Generate SSH key and put the path to it in `variables.tf`
2. Create a Fernet key and put it in [WIP]
3. voter manifest or something [WIP]
4. `terraform plan`
5. `terraform apply`
6. SSH into the deploy box (wait a bit to make sure everything's all set up; this may take several minutes)
8. `ssh-keyscan -H 192.168.0.11 192.168.0.12 192.168.0.13 192.168.0.14 >> ~/.ssh/known_hosts`
8. run ansible: `ansible-playbook -i inventory.yaml playbook.yaml -vvv`

examples of certain files are found in `examples/`

future work: fix encoding so that unicode can be passed through
do strange base64 stuff on each end?
