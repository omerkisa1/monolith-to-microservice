resource "tls_private_key" "rke2" {
  algorithm = "ED25519"
}

resource "openstack_compute_keypair_v2" "rke2" {
  name       = "rke2-key"
  public_key = tls_private_key.rke2.public_key_openssh
}

resource "local_sensitive_file" "rke2_private_key" {
  filename        = "/home/omer/Desktop/mtom-keys/rke2-key"
  content         = tls_private_key.rke2.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "rke2_public_key" {
  filename = "/home/omer/Desktop/mtom-keys/rke2-key.pub"
  content  = tls_private_key.rke2.public_key_openssh
}