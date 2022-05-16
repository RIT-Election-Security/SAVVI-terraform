// Meta
variable "project_name" {
    description = "Parent project id for the whole project"
    type = string
}

// VMs
variable "hosts" {
    description = "Map of management VM details hostname:vars"
    type = map
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
}