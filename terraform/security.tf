resource "openstack_compute_secgroup_v2" "mtom_bastion_secgroup" {
  name        = "mtom-secgroup"
  description = "Bastion security group for monolith to microservice project"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = var.admin_cidr
  }

}

resource "openstack_compute_secgroup_v2" "mtom_rke2_secgroup" {
    name = "mtom-rke2-secgroup"
    description = "RKE2 security group for mtom project"

    rule {
        from_port = 6443
        to_port   = 6443
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "Kubernetes API"
    }

    rule {
        from_port = 9345
        to_port   = 9345
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "RKE2 supervisor API"
    }
    
    rule {
        from_port = 10250
        to_port   = 10250
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "kubelet metrics"
    }

    rule {
        from_port = 2379
        to_port   = 2379
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "etcd client port"
    }

    rule {
        from_port = 2380
        to_port   = 2380
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "etcd peer port"
    }

    rule {
        from_port = 2381
        to_port   = 2381
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "etcd peer port"
    }

    rule {
        from_port = 30000
        to_port   = 32767
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "NodePort port range"
    }

    rule {
        from_port = 8472
        to_port   = 8472
        ip_protocol = "udp"
        cidr = var.private_network_cidr
        description = "Canal CNI with VXLAN"

    }

    rule {
        from_port = 9099
        to_port   = 9099
        ip_protocol = "tcp"
        cidr = var.private_network_cidr
        description = "Canal CNI health checks"
    }

}