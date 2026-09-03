resource "openstack_networking_router_v2" "mtom_router" {
  name                = "mtom-router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "management_router_link" {
  router_id = openstack_networking_router_v2.mtom_router.id
  subnet_id = openstack_networking_subnet_v2.bastion_subnet.id
}

resource "openstack_networking_router_interface_v2" "rke2_router_link" {
  router_id = openstack_networking_router_v2.mtom_router.id
  subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

resource "openstack_networking_router_interface_v2" "data_router_link" {
  router_id = openstack_networking_router_v2.mtom_router.id
  subnet_id = openstack_networking_subnet_v2.data_subnet.id
}