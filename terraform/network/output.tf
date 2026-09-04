output "management_network_id" {
  value = openstack_networking_network_v2.management_network.id
}

output "rke2_network_id" {
  value = openstack_networking_network_v2.rke2_network.id
}

output "rke2_subnet_id" {
  value = openstack_networking_subnet_v2.rke2_subnet.id
}

output "data_network_id" {
  value = openstack_networking_network_v2.data_network.id
}

output "external_network_name" {
  value = data.openstack_networking_network_v2.public_network.name
}