resource "openstack_compute_secgroup_v2" "worker_sg" {
  name        = "worker-sg"
  description = "RKE2 worker node security group for mtom project"


    rule {
        from_port = 22
        to_port   = 22
        ip_protocol = "tcp"
        cidr = var.admin_cidr
    }
    
    rule {
        from_port = 10250
        from_port = 10250
        ip_protocol = "tcp"
        cidr = var.admin_cidr
    }

    rule {
        from_port = 8472
        from_port = 8472
        ip_protocol = "udp"
        cidr = var.admin_cidr
    }

    rule {
        from_port = 9099
        from_port = 9099
        ip_protocol = "tcp"
        cidr = var.admin_cidr
    }
}