// this is pretty much a shell for the whole thing


provider "openstack" {
  // each of these needs to be pulled from variables.tf or secrets.auto.tfvars
    tenant_name = var.project_name // project name
    user_name = var.user_name
    password = var.password
    auth_url = var.auth_url
}

// we aren't going to create the project using tf

// Management Project
data "openstack_identity_project_v3" "savi_project" {
    name = var.project_name
}

// Openstack External Network
data "openstack_networking_network_v2" "external_network" {
    name = "RIT_WAN"
}

data "openstack_images_image_v2" "image_ubuntu_18" {
    name = "Ubuntu1804"
}

// Flavor Data
// these names are only a thing on RITSEC openstack
data "openstack_compute_flavor_v2" "flavor_medium" {
    name = "Medium general"
}

data "openstack_compute_flavor_v2" "flavor_medium_mem"{
    name = "Medium memory"
}

data "openstack_compute_flavor_v2" "flavor_large" {
    name = "Large general"
}

data "openstack_compute_flavor_v2" "flavor_large_mem" {
    name = "Large memory"
}

// create router
resource "openstack_networking_router_v2" "savi_router" {
    name = "SAVI Router"
    external_network_id = data.openstack_networking_network_v2.external_network.id
}

// then we'll do a module for each network
module "election_net" {
  source = "./networks" // pull in everything from the networks directory
  project_name = var.project_name
  project = data.openstack_identity_project_v3.savi_project
  savi_router = openstack_networking_router_v2.savi_router.id
  external_network = data.openstack_networking_network_v2.external_network.id
  user_name = var.user_name
  password = var.password
  auth_url = var.auth_url
  hosts = {
    "registrar": {
      "image": data.openstack_images_image_v2.image_ubuntu_18.id // this is the *ID* of the image
      "flavor": data.openstack_compute_flavor_v2.flavor_medium.id // the *ID* of the flavor
      "size": 20
      "ip": "192.168.0.1"
      //"secgroup":
    }
    "ballotbox": {
      "image": data.openstack_images_image_v2.image_ubuntu_18.id
      "flavor": data.openstack_compute_flavor_v2.flavor_medium.id
      "size": 20
      "ip": "192.168.0.2"
      //"secgroup":
    }
    "ballotserver": {
      "image": data.openstack_images_image_v2.image_ubuntu_18.id
      "flavor": data.openstack_compute_flavor_v2.flavor_medium.id
      "size": 20
      "ip": "192.168.0.3"
      //"secgroup":
    }
    "resultserver": {
      "image": data.openstack_images_image_v2.image_ubuntu_18.id
      "flavor": data.openstack_compute_flavor_v2.flavor_medium.id
      "size": 20
      "ip": "192.168.0.4"
      //"secgroup":
    }
    "deployserver": {
      "image": data.openstack_images_image_v2.image_ubuntu_18.id
      "flavor": data.openstack_compute_flavor_v2.flavor_medium.id
      "size": 20
      "ip": "192.168.0.5"
      //"secgroup":
    }
  }
}