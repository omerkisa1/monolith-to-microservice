resource "openstack_compute_keypair_v2" "db" {
  name       = "db-key"
  public_key = file(var.db_public_key_path)
}