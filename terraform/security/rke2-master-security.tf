resource "openstack_compute_secgroup_v2" "master_sg" {
  name        = "master-sg"
  description = "RKE2 master node security group for mtom project"

  #Kubernetes API
  rule {
    from_port   = 6443
    to_port     = 6443
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #RKE2 supervisor API
  rule {
    from_port   = 9345
    to_port     = 9345
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #kubelet metrics
  rule {
    from_port   = 10250
    to_port     = 10250
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #etcd client port
  rule {
    from_port   = 2379
    to_port     = 2379
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #etcd peer port
  rule {
    from_port   = 2380
    to_port     = 2380
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #etcd peer port
  rule {
    from_port   = 2381
    to_port     = 2381
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #NodePort port range
  rule {
    from_port   = 30000
    to_port     = 32767
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

  #Canal CNI with VXLAN
  rule {
    from_port   = 8472
    to_port     = 8472
    ip_protocol = "udp"
    cidr        = var.rke2_network_cidr

  }

  #Canal CNI health checks
  rule {
    from_port   = 9099
    to_port     = 9099
    ip_protocol = "tcp"
    cidr        = var.rke2_network_cidr
  }

}