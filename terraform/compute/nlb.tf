resource "openstack_lb_loadbalancer_v2" "rke2_nlb" {
  name = "rke2-controlplane-nlb"

  vip_subnet_id = var.rke2_subnet_id
}


resource "openstack_lb_listener_v2" "k8s_api_listener" {
  name = "k8s-api-listener"

  protocol      = "TCP"
  protocol_port = 6443

  loadbalancer_id = openstack_lb_loadbalancer_v2.rke2_nlb.id
}

resource "openstack_lb_pool_v2" "k8s_api_pool" {
  name     = "k8s-api-pool"
  protocol = "TCP"

  lb_method = "ROUND_ROBIN"

  listener_id = openstack_lb_listener_v2.k8s_api_listener.id
}

resource "openstack_lb_monitor_v2" "k8s_api_monitor" {
  name    = "k8s-api-monitor"
  pool_id = openstack_lb_pool_v2.k8s_api_pool.id

  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_member_v2" "k8s_api_members" {
  count = var.master_count

  pool_id = openstack_lb_pool_v2.k8s_api_pool.id

  address = openstack_compute_instance_v2.master[count.index].access_ip_v4

  protocol_port = 6443
  subnet_id     = openstack_networking_subnet_v2.rke2_subnet.id
}


resource "openstack_lb_listener_v2" "rke2_join_listener" {
  name          = "rke2-join-listener"
  protocol      = "TCP"
  protocol_port = 9345

  loadbalancer_id = openstack_lb_loadbalancer_v2.rke2_nlb.id
}

resource "openstack_lb_pool_v2" "rke2_join_pool" {
  name      = "rke2-join-pool"
  protocol  = "TCP"
  lb_method = "ROUND_ROBIN"

  listener_id = openstack_lb_listener_v2.rke2_join_listener.id
}

resource "openstack_lb_monitor_v2" "rke2_join_monitor" {
  name        = "rke2-join-monitor"
  pool_id     = openstack_lb_pool_v2.rke2_join_pool.id
  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_member_v2" "rke2_join_members" {
  count = var.master_count

  pool_id = openstack_lb_pool_v2.rke2_join_pool.id

  address       = openstack_compute_instance_v2.master[count.index].access_ip_v4
  protocol_port = 9345
  subnet_id     = openstack_networking_subnet_v2.rke2_subnet.id
}

output "rke2_nlb_private_vip" {
  value = openstack_lb_loadbalancer_v2.rke2_nlb.vip_address
}