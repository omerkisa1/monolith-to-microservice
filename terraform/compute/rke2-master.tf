resource "openstack_compute_instance_v2" "master" {
  count = 3

  name            = "rke2-master-${count.index + 1}"
  flavor_id       = var.medium_flavor_id
  key_pair        = var.rke2_keypair_name
  security_groups = [var.master_sg_name]

  block_device {
    uuid                  = var.ubuntu_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = var.rke2_network_id
  }
}