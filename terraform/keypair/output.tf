output "bastion_keypair_name" {
  value = openstack_compute_keypair_v2.bastion.name
}

output "rke2_keypair_name" {
  value = openstack_compute_keypair_v2.rke2.name
}

output "db_keypair_name" {
  value = openstack_compute_keypair_v2.db.name
}