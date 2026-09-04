resource "openstack_lb_loadbalancer_v2" "application_lb" {
  name          = "application-lb"
  vip_subnet_id = var.rke2_subnet_id
}


resource "openstack_lb_listener_v2" "http_listener" {
  name            = "application-http-listener"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.application_lb.id

}

resource "openstack_lb_pool_v2" "http_pool" {
  name      = "application-http-pool"
  protocol  = "TCP"
  lb_method = "ROUND_ROBIN"

  listener_id = openstack_lb_listener_v2.http_listener.id
}

resource "openstack_lb_monitor_v2" "http_monitor" {
  name    = "application-http-monitor"
  pool_id = openstack_lb_pool_v2.http_pool.id

  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_member_v2" "http_members" {
  count = var.worker_count

  pool_id = openstack_lb_pool_v2.http_pool.id

  address = openstack_compute_instance_v2.worker[count.index].access_ip_v4

  protocol_port = var.ingress_http_nodeport

  subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

resource "openstack_lb_listener_v2" "https_listener" {
  name          = "application-https-listener"
  protocol      = "TCP"
  protocol_port = 443

  loadbalancer_id = openstack_lb_loadbalancer_v2.application_lb.id
}

resource "openstack_lb_pool_v2" "https_pool" {
  name      = "application-https-pool"
  protocol  = "TCP"
  lb_method = "ROUND_ROBIN"

  listener_id = openstack_lb_listener_v2.https_listener.id
}

resource "openstack_lb_monitor_v2" "https_monitor" {
  name    = "application-https-monitor"
  pool_id = openstack_lb_pool_v2.https_pool.id

  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_member_v2" "https_members" {
  count         = var.worker_count
  pool_id       = openstack_lb_pool_v2.https_pool.id
  address       = openstack_compute_instance_v2.worker[count.index].access_ip_v4
  protocol_port = var.ingress_https_nodeport
  subnet_id     = openstack_networking_subnet_v2.rke2_subnet.id
}


resource "openstack_networking_floatingip_v2" "application_fip" {
  pool = var.external_network_name
}

resource "openstack_networking_floatingip_associate_v2" "application_fip_attach" {
  floating_ip = openstack_networking_floatingip_v2.application_fip.address
  port_id     = openstack_lb_loadbalancer_v2.application_lb.vip_port_id
}

output "application_public_ip" {
  value = openstack_networking_floatingip_v2.application_fip.address
}