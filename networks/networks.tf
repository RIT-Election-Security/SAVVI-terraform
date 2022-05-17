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

resource "google_compute_address" "nat-ip" {
    name = "savi-nat-ip"
    project = var.project_name
    region = var.region
}

resource "google_compute_router_nat" "nat-gateway" {
  name = "savi-nat-gateway"
  router = google_compute_router.nat-router.name
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = [ google_compute_address.nat-ip.self_link ]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on = [ google_compute_address.nat-ip ]
}

output "nat_ip_address" {
  value = google_compute_address.nat-ip.address
    #TODO: expose this output properly
}