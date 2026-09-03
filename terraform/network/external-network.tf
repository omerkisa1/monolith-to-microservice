data "openstack_networking_network_v2" "public_network" {
  network_id = var.external_network_id
}