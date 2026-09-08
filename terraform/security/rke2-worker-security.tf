resource "openstack_compute_secgroup_v2" "worker_sg" {
  name        = "worker-sg"
  description = "RKE2 worker node security group for mtom project"


  rule {
    from_port     = 22
    to_port       = 22
    ip_protocol   = "tcp"
    from_group_id = openstack_compute_secgroup_v2.bastion_sg.id
  }

  rule {
    from_port   = 10250
    to_port     = 10250
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  rule {
    from_port   = 8472
    to_port     = 8472
    ip_protocol = "udp"
    cidr        = var.rke2_network_cidr
  }

  rule {
    from_port   = 9099
    to_port     = 9099
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }
  rule {
    from_port   = 30080
    to_port     = 30080
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  rule {
    from_port   = 30443
    to_port     = 30443
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

}
