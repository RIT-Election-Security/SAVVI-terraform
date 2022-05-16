resource "google_compute_firewall" "ssh" {
    name = "allow-ssh"
    network = google_compute_network.savi_network.name
    allow {
        ports = ["22"]
        protocol = "tcp"
    }
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ssh"]
}

resource "google_compute_firewall" "egress" {
    name = "egress"
    network = google_compute_network.savi_network.name
    allow {
        protocol = "tcp"
    }
    direction = "EGRESS"
}