resource "openstack_compute_instance_v2" "savi_instance" {
    depends_on = [ openstack_networking_subnet_v2.savi_subnet ]
    for_each = var.hosts
    name = "${each.key}"
    flavor_id = each.value.flavor
    security_groups = [
        "default"//,
        //data.openstack_networking_secgroup_v2.savi_secgroup.id
    ]

    block_device {
        uuid = each.value.image
        volume_size = each.value.size
        boot_index = 0
        delete_on_termination = true
        source_type = "image"
        destination_type = "volume"
    }

    network {
        // since this is within the same module, we don't need to pull it in as `data`
        uuid = openstack_networking_network_v2.savi_network.id
        fixed_ip_v4 = each.value.ip
    }
    user_data = lookup(each.value, "user_data", null) // this is how we insert cloud_init
}
