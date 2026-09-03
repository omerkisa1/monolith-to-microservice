resource "openstack_compute_keypair_v2" "rke2" {
  name       = "rke2-key"
  public_key = file(var.rke2_public_key_path)
}