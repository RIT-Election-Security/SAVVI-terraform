resource "google_compute_firewall" "ext-ssh" {
    // allow SSH into the deploy host/jump box
    // source IP ranges can be locked down even further
    name = "allow-external-ssh"
    network = google_compute_network.savi_network.name
    allow {
        ports = ["22"]
        protocol = "tcp"
    }
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ext-ssh"]
}

resource "google_compute_firewall" "int-ssh" {
    // only allow connection to internal boxes from the jump box/deploy host
    name = "allow-internal-ssh"
    network = google_compute_network.savi_network.name
    allow {
        ports = ["22"]
        protocol = "tcp"
    }
    direction = "INGRESS"
    source_tags = ["ext-ssh"]
    target_tags = ["int-ssh"]
}

resource "google_compute_firewall" "ext-https" {
    name = "allow-external-https"
    network = google_compute_network.savi_network.name
    allow {
        ports = ["443"]
        protocol = "tcp"
    }
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["ext-https"]
}

resource "google_compute_firewall" "int-https" {
    name = "allow-internal-https"
    network = google_compute_network.savi_network.name
    allow {
        ports = ["443"]
        protocol = "tcp"
    }
    direction = "INGRESS"
    source_tags = ["ext-https"]
    target_tags = ["int-https"]
}

resource "google_compute_firewall" "egress" {
    name = "egress"
    network = google_compute_network.savi_network.name
    allow {
        protocol = "tcp"
    }
    direction = "EGRESS"
}