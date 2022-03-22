resource "openstack_networking_secgroup_v2" "savi_main_secgroup" {
    //tenant_id = openstack_identity_project_v3.savi_project.id
    name = "SAVI Main Secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "savi_main_secgroup_rule" {
    for_each = var.all_ports
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.savi_main_secgroup.id
}