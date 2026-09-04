resource "openstack_networking_network_v2" "bastion_network" {
  name = "bastion-network"
}

resource "openstack_networking_subnet_v2" "bastion_subnet" {
  name            = "bastion-subnet"
  network_id      = openstack_networking_network_v2.bastion_network.id
  cidr            = var.bastion_network_cidr
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}