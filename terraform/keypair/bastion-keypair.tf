resource "tls_private_key" "bastion" {
  algorithm = "ED25519"
}

resource "openstack_compute_keypair_v2" "bastion" {
  name       = "bastion-key"
  public_key = tls_private_key.bastion.public_key_openssh
}

resource "local_sensitive_file" "bastion_private_key" {
  filename        = "/home/omer/Desktop/mtom-keys/bastion-key"
  content         = tls_private_key.bastion.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "bastion_public_key" {
  filename = "/home/omer/Desktop/mtom-keys/bastion-key.pub"
  content  = tls_private_key.bastion.public_key_openssh
}