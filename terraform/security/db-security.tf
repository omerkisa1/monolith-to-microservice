resource "openstack_compute_secgroup_v2" "db_sg" {
  name        = "db-sg"
  description = "Database security group"

  rule {
    from_port     = 5432
    to_port       = 5432
    ip_protocol   = "tcp"
    from_group_id = openstack_compute_secgroup_v2.worker_sg.id
  }

  rule {
    from_port     = 22
    to_port       = 22
    ip_protocol   = "tcp"
    from_group_id = openstack_compute_secgroup_v2.bastion_sg.id
  }
}