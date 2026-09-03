resource "openstack_compute_keypair_v2" "bastion" {
  name       = "bastion-key"
  public_key = file(var.bastion_public_key_path)
}