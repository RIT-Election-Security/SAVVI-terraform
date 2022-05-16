// Meta
variable "project_name" {
    description = "Parent project id for the whole project"
    type = string
}

variable "region" {
    description = "GCP region for the whole deployment"
    type = string
}

variable "zone" {
    description = "GCP zone for everything"
    type = string
}

variable "mtype" {
    description = "GCP machine type for all instances"
    type = string
    default = "e2-micro" //$7/month
}

variable "gcp_cred_file" {
    type = string
    description = "path to the GCP credentials file"
}

variable "ip_addrs" {
    description = "IP addresses of each host in the topology"
    type = map
    default = {"registrar"="192.168.0.11", "ballotbox"="192.168.0.12", "ballotserver"="192.168.0.13", "resultserver"="192.168.0.14", "deployserver"="192.168.0.15"}
}

variable "ssh_pubkey_file" {
    description = "SSH public key file path for hosts"
    type = string
    default = "id_savi.pub"
}

variable "ssh_privkey_file" {
    description = "SSH private key file path that matches ssh_pubkey_file"
    type = string
    default = "id_savi"
}

variable "electionguard_facility_name" {
    description = "facility name for ElectionGuard"
    type = string
    default = "test-facility"
}

variable "launch_code_seed" {
    description = "seed for generating random launch code; integer parsed from string"
    type = string
    default = "1337"
}

variable "electionguard_shared_key" {
    description = "shared Fernet key for ElectionGuard"
    type = string
}

variable "election_manifest_file" {
    description = "file path to the election manifest JSON"
    type = string
    default = "examples/election_manifest.json"
}

variable "voter_data_file" {
    description = "file path to the voter data JSON"
    type = string
    default = "examples/voter_data.json"
}

variable "deploy_ci_vars" {
    description = "Variables to pass to cloudinit on the deploy server"
    type = map
    default = {"ssh_pubkey"="", "ssh_privkey"="", "registrar_ip"="", "ballotbox_ip"="", "ballotserver_ip"="", "resultserver_ip"=""}
}

variable "host_ci_vars" {
    description = "Variables to pass to cloudinit on the non-deploy servers"
    type = map
    default = {"ssh_pubkey"=""}
}