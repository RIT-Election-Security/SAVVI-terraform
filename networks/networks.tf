resource "google_compute_network" "savi_network" {
    name = "savi-net"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "savi_subnet" {
    ip_cidr_range = "192.168.0.0/24"
    name = "savi-subnet"
    network = google_compute_network.savi_network.name
    region = var.region
}

resource "google_compute_router" "nat-router" {
    name = "savi-nat-router"
    network = google_compute_network.savi_network.name
}