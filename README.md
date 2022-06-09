# Deployment Steps (Google Cloud + Terraform)

1. Generate SSH key and put the path to it in `variables.tf`
2. Create a Fernet key and put it in the `electionguard_shared_key` variable in `secrets.auto.tfvars`
`python3 -c 'from cryptography.fernet import Fernet; print(Fernet.generate_key())'`
3. Create a project in Google Cloud and put the project name, region, and zone in `savi.auto.tfvars`
3. Authenticate to Google Cloud using `gcloud auth application-default login` and put the path to the credential file in the `gcp_cred_file` variable in `secrets.auto.tfvars`
See [this guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started) for more details
3. Create [an ElectionGuard manifest](https://microsoft.github.io/electionguard-python/Election_Manifest/) and put the path to it in the `election_manifest_file` variable in `secrets.auto.tfvars`
See *Election Manifest Format* below for more details.
4. Create a voter data file and put the path to it in the `voter_data_file` variable
See *Voter Data File* below for details on the format
4. Your `secrets.auto.tfvars` should look something like this now:
```hcl-terraform
electionguard_shared_key="KEY GOES HERE"
gcp_cred_file = "/path/to/application_default_credentials.json"
election_manifest_file = "/path/to/election_manifest.json"
voter_data_file = "/path/to/voter_data.json"
```
4. Run `terraform plan` to verify that all the required variables are filled in
5. Run `terraform apply` to create the infrastructure
6. Wait a few minutes to make sure everything's set up (VM instances and network created, packages installed, and Ansible downloaded and templated); this may take several minutes
6. Connect to the `deployserver` instance with this command:
```bash
gcloud compute ssh --zone "INSERT ZONE HERE" "deployserver"  --tunnel-through-iap --project "PROJECT ID" -- -D localhost:8080
```
7. Use `sudo su savi` to switch users since Google Cloud SSH logs you in as the user you're logged in as on your current host machine
7. `cd ~/SAVI-deployment` to enter the directory where the ansible repo is stored
8. `ssh-keyscan -H 192.168.0.11 192.168.0.12 192.168.0.13 192.168.0.14 >> ~/.ssh/known_hosts`
8. Run voting application ansible: `ansible-playbook -i inventory.yaml playbook.yaml -vvv`
If anything in Ansible fails after initial SSH connections work, try running it again.
Sometimes, downloading packages or container images may take longer than the default timeouts.
9. Run [DISA STIG Ansible](https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_CAN_Ubuntu_18-04_LTS_V2R7_STIG_Ansible.zip) for security hardening: `ansible-playbook -i inventory-STIG.yaml playbook-STIG.yaml`


## Future Work
For more details, see the paper

* method for connecting to the servers from outside of the environment
* fix encoding so that unicode can be passed through, perhaps by doing base64 stuff on each end?
* restrict security rules further - only to websites required for package install
* use GCP features to make voter data scale better since gzipped cloudinit isn't supported
* download certificate to use for connecting


## Troubleshooting
* SSH to other instances by hostname
* by the time this is actually used by someone, ansible or its dependencies may have deprecated python2, which this uses for deployment
* each instance has a `nginx` reverse proxy and a python webapp (using [Quart](https://pgjones.gitlab.io/quart/), except for the `ballotserver`, which uses [FastAPI](https://fastapi.tiangolo.com/))
* `ballotserver` can intentionally only be accessed from the other webservers.  to access it externally in a test deployment, change its tags in `main.tf` to `ext-https` rather than `int-https`

# How it all fits together
The terraform rules in this repository create a set of virtual machine instances in Google Cloud Platform Compute Engine,
one each for `registrar`, `ballotbox`, `ballotserver`, `resultserver`, and `deployserver`.
On the first four instances, `cloud_init` installs some necessary packages and enables login using the SSH key created earlier.
On the `deployserver`, it also downloads the [`SAVI-deployment`](https://github.com/RIT-Election-Security/SAVI-deployment) repository and fills in the templates and variables

# Election Manifest Format
This project uses ElectionGuard and [its manifest format](https://microsoft.github.io/electionguard-python/Election_Manifest/), an example of which can be found in [examples/election_manifest.json].

The path to the election manifest file needs to be placed in the `election_manifest_file` Terraform variable, whether in `variables.tf` or in your own `*.auto.tfvars` file.
Either a relative path (relative to `main.tf`) or an absolute path can be used. 

# Voter Data Format
Voter data is used in the `registrar` application to verify whether a given user is allowed to register.
An example of the format can be found in [examples/voter_data.json].

It's a JSON file where each voter has the following keys:
* `first`
* `last`
* `address`
* `ballot_style`, which is taken from the election manifest

# Sources/References
For a full bibliography, see the paper

* Docker security docs: https://docs.docker.com/engine/security/
* Docker user remapping: https://docs.docker.com/engine/security/userns-remap/
* SSL best practices: https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices
* Nginx config for SSL best practices: https://syslink.pl/cipherlist/
* NIST hardening checklist: https://ncp.nist.gov/checklist/989