# Deployment Steps (Google Cloud + Terraform)

1. Generate SSH key and put the path to it in `variables.tf`
2. Create a Fernet key and put it in `secrets.auto.tfvars`
`python3 -c 'from cryptography.fernet import Fernet; print(Fernet.generate_key())'`
3. GCP auth and project data [WIP]
3. voter manifest or something [WIP]
4. Run `terraform plan` to test your connection to GCP
5. `terraform apply`
6. SSH into the deploy box (wait a bit to make sure everything's all set up; this may take several minutes)
7. `sudo su savi` since google cloud ssh doesn't do that
8. `ssh-keyscan -H 192.168.0.11 192.168.0.12 192.168.0.13 192.168.0.14 >> ~/.ssh/known_hosts`
8. run ansible: `ansible-playbook -i inventory.yaml playbook.yaml -vvv`.
if anything fails after initial SSH connections work, try running it again

examples of certain files are found in `examples/`

future work: 
* fix encoding so that unicode can be passed through, perhaps by doing base64 stuff on each end?
* restrict security rules further - only to websites required for package install
* use GCP features to make voter data scale better since gzipped cloudinit isn't supported
* download certificate to use for connecting


Docker security docs https://docs.docker.com/engine/security/
SSL best practices https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices
https://syslink.pl/cipherlist/

## Troubleshooting
* SSH to other instances by hostname
* by the time this is actually used by someone, ansible or its dependencies may have deprecated python2, which this uses for deployment

# How it all fits together [WIP]
this setup 

# Election Manifest Format [WIP]

# Voter Data Format [WIP]

