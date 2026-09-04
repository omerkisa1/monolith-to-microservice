resource "openstack_networking_network_v2" "rke2_network" {
  name = "rke2-network"
}

resource "openstack_networking_subnet_v2" "rke2_subnet" {
  name            = "rke2-subnet"
  network_id      = openstack_networking_network_v2.rke2_network.id
  cidr            = var.rke2_network_cidr
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}