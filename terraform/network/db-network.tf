resource "openstack_networking_network_v2" "data_network" {
  name = "data-network"
}

resource "openstack_networking_subnet_v2" "data_subnet" {
  name            = "data-subnet"
  network_id      = openstack_networking_network_v2.data_network.id
  cidr            = "10.30.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}