resource "openstack_compute_secgroup_v2" "bastion_sg" {
  name        = "bastion-sg"
  description = "Bastion security group for monolith to microservice project"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = var.admin_cidr
  }
}
