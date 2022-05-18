resource "google_compute_instance" "savi_instance"{
    depends_on = [google_compute_subnetwork.savi_subnet]
    for_each = var.hosts
    name = "${each.key}"
    machine_type = var.mtype
    zone = var.zone

    metadata = {
        user-data = lookup(each.value, "user_data", null)
    }

    boot_disk {
        initialize_params {
            // current as of May 2022
            image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20220505"
        }
    }

    network_interface {
        network = google_compute_network.savi_network.name
        subnetwork = google_compute_subnetwork.savi_subnet.name
        network_ip = each.value.ip
    }
    tags = each.value.tags
}