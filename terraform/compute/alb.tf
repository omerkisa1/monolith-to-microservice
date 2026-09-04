############################################
# PUBLIC APPLICATION LOAD BALANCER
############################################

resource "openstack_lb_loadbalancer_v2" "application_lb" {
  name = "application-lb"

  # LB'nin iç/private VIP'si RKE2 subnet'inde.
  # Public erişimi aşağıda Floating IP ile sağlayacağız.
  vip_subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

############################################
# HTTP - PORT 80
############################################

resource "openstack_lb_listener_v2" "http_listener" {
  name = "application-http-listener"

  # TLS/HTTP routing işini Kubernetes Ingress'e bırakıyorsak
  # burada TCP passthrough kullanabiliriz.
  protocol      = "TCP"
  protocol_port = 80

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

  # Basit erişilebilirlik kontrolü.
  # İleride HTTP health endpoint'in varsa HTTP monitor'a çevrilebilir.
  type        = "TCP"
  delay       = 5
  timeout     = 3
  max_retries = 3
}

resource "openstack_lb_member_v2" "http_members" {
  count = var.worker_count

  pool_id = openstack_lb_pool_v2.http_pool.id

  # Trafik worker node'ların private IP'lerine gider.
  address = openstack_compute_instance_v2.worker[count.index].access_ip_v4

  # KRİTİK:
  # Bu port doğrudan 80 olmak zorunda değil.
  # Ingress Controller Service NodePort değeri neyse onu yazmalısın.
  protocol_port = var.ingress_http_nodeport

  subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

############################################
# HTTPS - PORT 443
############################################

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
  count = var.worker_count

  pool_id = openstack_lb_pool_v2.https_pool.id

  address = openstack_compute_instance_v2.worker[count.index].access_ip_v4

  # KRİTİK:
  # Kubernetes Ingress Controller'ın HTTPS NodePort'u.
  protocol_port = var.ingress_https_nodeport

  subnet_id = openstack_networking_subnet_v2.rke2_subnet.id
}

############################################
# PUBLIC FLOATING IP
############################################

resource "openstack_networking_floatingip_v2" "application_fip" {

  # OpenStack external/public network'ten bir Floating IP alır.
  pool = data.openstack_networking_network_v2.public_network.name
}

resource "openstack_networking_floatingip_associate_v2" "application_fip_attach" {

  floating_ip = openstack_networking_floatingip_v2.application_fip.address

  # Floating IP doğrudan worker'a değil,
  # Load Balancer'ın VIP portuna bağlanır.
  port_id = openstack_lb_loadbalancer_v2.application_lb.vip_port_id
}

output "application_public_ip" {
  value = openstack_networking_floatingip_v2.application_fip.address
}