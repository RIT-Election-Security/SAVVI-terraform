// this is pretty much a shell for the whole thing


provider "google" {
  project = var.project_name
  region = var.region
  zone = var.zone
  credentials = file(var.gcp_cred_file)
}

data "template_file" "ci_deploy" {
  template = "${file("templates/cloud-init-deploy.yaml")}"
  vars = {
    ssh_pubkey=file(var.ssh_pubkey_file)
  }
}

data "template_file" "download_repo" {
    template = "${file("templates/download-repo.sh")}"
    vars = {
      registrar_ip=var.ip_addrs.registrar
      ballotbox_ip=var.ip_addrs.ballotbox
      ballotserver_ip=var.ip_addrs.ballotserver
      resultserver_ip=var.ip_addrs.resultserver
      facility_name=var.electionguard_facility_name
      launch_code_seed=var.launch_code_seed
      shared_key=var.electionguard_shared_key
      ssh_privkey=file(var.ssh_privkey_file)
      election_manifest=file(var.election_manifest_file)
      voter_data=file(var.voter_data_file)
    }
}

output "download_repo_templated" {
    value = "${data.template_file.download_repo.rendered}"
}

data "template_cloudinit_config" "deploy_config" {
  gzip          = false // these can both be true on openstack, but GCP's images don't support it
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.ci_deploy.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content = "${data.template_file.download_repo.rendered}"
  }
}

// then we'll do a module for each network
module "election_net" {
  source = "./networks" // pull in everything from the networks directory
  project_name = var.project_name
  region = var.region
  zone = var.zone
  mtype = var.mtype
  hosts = {
    "registrar": {
      "ip": var.ip_addrs.registrar
      "user_data": templatefile("templates/cloud-init.yaml", {ssh_pubkey=file(var.ssh_pubkey_file)})
      "tags": ["int-ssh", "ext-https"] // GCP security rules are based on tags for traffic destination
    }
    "ballotbox": {
      "ip": var.ip_addrs.ballotbox
      "user_data": templatefile("templates/cloud-init.yaml", {ssh_pubkey=file(var.ssh_pubkey_file)})
      "tags": ["int-ssh", "ext-https"]
    }
    "ballotserver": {
      "ip": var.ip_addrs.ballotserver
      "user_data": templatefile("templates/cloud-init.yaml", {ssh_pubkey=file(var.ssh_pubkey_file)})
      "tags": ["int-ssh", "int-https"]
    }
    "resultserver": {
      "ip": var.ip_addrs.resultserver
      "user_data": templatefile("templates/cloud-init.yaml", {ssh_pubkey=file(var.ssh_pubkey_file)})
      "tags": ["int-ssh", "ext-https"]
    }
    "deployserver": {
      "ip": var.ip_addrs.deployserver
      "user_data": "${data.template_cloudinit_config.deploy_config.rendered}"
      tags: ["ext-ssh"]
    }
  }
}