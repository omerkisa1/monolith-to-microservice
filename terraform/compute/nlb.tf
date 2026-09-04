############################################
# RKE2 CONTROL PLANE NLB
############################################

resource "openstack_lb_loadbalancer_v2" "rke2_nlb" {
  name          = "rke2-controlplane-nlb"

  # NLB'nin private VIP'si RKE2 subnet'inde oluşur.
  # Bu LB'ye FIP vermiyoruz; cluster içi HA endpoint olarak kullanıyoruz.
  vip_subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

############################################
# Kubernetes API - 6443
############################################

resource "openstack_lb_listener_v2" "k8s_api_listener" {
  name            = "k8s-api-listener"

  # Kubernetes API TCP tabanlı çalıştığı için L4 listener.
  protocol        = "TCP"
  protocol_port   = 6443

  loadbalancer_id = openstack_lb_loadbalancer_v2.rke2_nlb.id
}

resource "openstack_lb_pool_v2" "k8s_api_pool" {
  name        = "k8s-api-pool"
  protocol    = "TCP"

  # Sağlıklı master'lar arasında trafiği dağıtır.
  lb_method   = "ROUND_ROBIN"

  listener_id = openstack_lb_listener_v2.k8s_api_listener.id
}

resource "openstack_lb_monitor_v2" "k8s_api_monitor" {
  name        = "k8s-api-monitor"
  pool_id     = openstack_lb_pool_v2.k8s_api_pool.id

  # Burada sadece TCP portunun erişilebilir olup olmadığını kontrol ediyoruz.
  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_member_v2" "k8s_api_members" {
  count = var.master_count

  pool_id = openstack_lb_pool_v2.k8s_api_pool.id

  # NLB trafiği master node'ların PRIVATE IP'lerine gönderir.
  address = openstack_compute_instance_v2.master[count.index].access_ip_v4

  protocol_port = 6443
  subnet_id     = openstack_networking_subnet_v2.rke2_subnet.id
}

############################################
# RKE2 SUPERVISOR / NODE JOIN - 9345
############################################

resource "openstack_lb_listener_v2" "rke2_join_listener" {
  name            = "rke2-join-listener"
  protocol        = "TCP"
  protocol_port   = 9345

  loadbalancer_id = openstack_lb_loadbalancer_v2.rke2_nlb.id
}

resource "openstack_lb_pool_v2" "rke2_join_pool" {
  name        = "rke2-join-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"

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

  # Worker/server node'lar 9345 üzerinden bu master havuzuna ulaşır.
  address       = openstack_compute_instance_v2.master[count.index].access_ip_v4
  protocol_port = 9345
  subnet_id     = openstack_networking_subnet_v2.rke2_subnet.id
}

output "rke2_nlb_private_vip" {
  # RKE2 config içerisinde sabit cluster endpoint olarak kullanabileceğin VIP.
  value = openstack_lb_loadbalancer_v2.rke2_nlb.vip_address
}