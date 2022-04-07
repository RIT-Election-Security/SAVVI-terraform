// Meta
variable "project_name" {
    description = "Parent project id for the whole project"
    type = string
}

/*
variable "savi_router" {
    description = "UUID of SAVI router"
    type = string
}

variable "external_network" {
    description = "External Network UUID"
}
*/

// Security Group Ports
variable "all_ports" {
    description = "Allowed ports to all instances (empty for all)"
    type = map
    default = {"ssh": 22}
}

variable "user_name" {
    description = "Openstack username"
    type = string
}

variable "password" {
    description = "Openstack password"
    type = string
}

variable "auth_url" {
    description = "Openstack authentication url"
    type = string
}

variable "host_ci_vars" {
    description = "Variables to pass to cloudinit on the non-deploy servers"
    type = map
    default = {"ssh_pubkey"=""}
}

variable "deploy_ci_vars" {
    description = "Variables to pass to cloudinit on the deploy server"
    type = map
    default = {"ssh_pubkey"="", "ssh_privkey"="", "registrar_ip"="", "ballotbox_ip"="", "ballotserver_ip"="", "resultserver_ip"=""}
}