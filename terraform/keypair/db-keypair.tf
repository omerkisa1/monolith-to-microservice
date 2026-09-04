resource "tls_private_key" "db" {
  algorithm = "ED25519"
}

resource "openstack_compute_keypair_v2" "db" {
  name       = "db-key"
  public_key = tls_private_key.db.public_key_openssh
}

resource "local_sensitive_file" "db_private_key" {
  filename        = "/home/omer/Desktop/mtom-keys/db-key"
  content         = tls_private_key.db.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "db_public_key" {
  filename = "/home/omer/Desktop/mtom-keys/db-key.pub"
  content  = tls_private_key.db.public_key_openssh
}