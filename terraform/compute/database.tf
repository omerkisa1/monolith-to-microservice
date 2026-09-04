resource "openstack_compute_instance_v2" "database" {
  name            = "postgres-db"
  flavor_id       = var.medium_flavor_id
  key_pair        = var.db_keypair_name
  security_groups = [var.db_sg_name]

  block_device {
    uuid             = var.ubuntu_image_id
    source_type      = "image"
    destination_type = "volume"

    volume_size = 20

    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = var.data_network_id
  }
}