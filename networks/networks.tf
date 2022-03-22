resource "openstack_networking_network_v2" "savi_network" {
    name = "SAVI Network"
  // this is just a container for the name and the heavy lifting is done in the subnet
}

resource "openstack_networking_subnet_v2" "savi_subnet" {
    name = "SAVI Subnet"
    network_id = openstack_networking_network_v2.savi_network.id
    cidr = "192.168.0.0/24"
    gateway_ip = "192.168.0.254"
    ip_version = 4
    allocation_pool {
        start = "192.168.0.200"
        end = "192.168.0.253"
    }
}

// this is a port
resource "openstack_networking_port_v2" "savi_router_port" {
    name = "SAVI Router Port"
    network_id = openstack_networking_network_v2.savi_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.savi_subnet.id
        ip_address = "192.168.0.254"
    }
}

// and then we add that port to the router
resource "openstack_networking_router_interface_v2" "savi_router_interface" {
    router_id = var.savi_router
    port_id = openstack_networking_port_v2.savi_router_port.id
}