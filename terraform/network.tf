data "openstack_networking_network_v2" "public_network" {
  network_id = var.external_network_id
}



##### bastion block ###
resource "openstack_networking_network_v2" "management_network" {
  name = "management-network"
}

resource "openstack_networking_subnet_v2" "management_subnet" {
  name            = "management-subnet"
  network_id      = openstack_networking_network_v2.management_network.id
  cidr            = "10.10.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}


#### rke2 block ############

resource "openstack_networking_network_v2" "rke2_network" {
  name = "rke2-network"
}

resource "openstack_networking_subnet_v2" "rke2_subnet" {
  name            = "rke2-subnet"
  network_id      = openstack_networking_network_v2.rke2_network.id
  cidr            = "10.20.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}


### data block #########

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

resource "openstack_networking_router_v2" "mtom_router" {
  name                = "mtom-router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

###### routers ###

resource "openstack_networking_router_interface_v2" "management_router_link" {
  router_id = openstack_networking_router_v2.mtom_router.id
  subnet_id = openstack_networking_subnet_v2.management_subnet.id
}

resource "openstack_networking_router_interface_v2" "rke2_router_link" {
  router_id = openstack_networking_router_v2.mtom_router.id
  subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

resource "openstack_networking_router_interface_v2" "data_router_link" {
  router_id = openstack_networking_router_v2.mtom_router.id
  subnet_id = openstack_networking_subnet_v2.data_subnet.id
}