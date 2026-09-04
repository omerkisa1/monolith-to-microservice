output "bastion_sg_name" {
  value = openstack_compute_secgroup_v2.bastion_sg.name
}

output "master_sg_name" {
  value = openstack_compute_secgroup_v2.master_sg.name
}

output "worker_sg_name" {
  value = openstack_compute_secgroup_v2.worker_sg.name
}

output "db_sg_name" {
  value = openstack_compute_secgroup_v2.db_sg.name
}