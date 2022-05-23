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
8. run application ansible: `ansible-playbook -i inventory.yaml playbook.yaml -vvv`.
If anything in Ansible fails after initial SSH connections work, try running it again.
Sometimes, downloading packages or container images may take longer than the default timeouts.
9. run security ansible: `ansible-playbook -i inventory-STIG.yaml playbook-STIG.yaml`

examples of certain files are found in `examples/`

future work: 
* fix encoding so that unicode can be passed through, perhaps by doing base64 stuff on each end?
* restrict security rules further - only to websites required for package install
* use GCP features to make voter data scale better since gzipped cloudinit isn't supported
* download certificate to use for connecting


## Troubleshooting
* SSH to other instances by hostname
* by the time this is actually used by someone, ansible or its dependencies may have deprecated python2, which this uses for deployment
* each instance has a `nginx` reverse proxy and a python webapp (using [Quart](https://pgjones.gitlab.io/quart/), except for the `ballotserver`, which uses [FastAPI](https://fastapi.tiangolo.com/))

# How it all fits together
The terraform rules in this repository create a set of virtual machine instances in Google Cloud Platform Compute Engine,
one each for `registrar`, `ballotbox`, `ballotserver`, `resultserver`, and `deployserver`.
On the first four instances, `cloud_init` installs some necessary packages and enables login using the SSH key created earlier.
On the `deployserver`, it also downloads the [`SAVI-deployment`](https://github.com/RIT-Election-Security/SAVI-deployment) repository and fills in the templates and variables

# Election Manifest Format [WIP]

# Voter Data Format [WIP]

# Sources/References [WIP]
For a full bibliography, see the paper

* Docker security docs: https://docs.docker.com/engine/security/
* Docker user remapping: https://docs.docker.com/engine/security/userns-remap/
* SSL best practices: https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices
* Nginx config for SSL best practices: https://syslink.pl/cipherlist/
* NIST hardening checklist: https://ncp.nist.gov/checklist/989