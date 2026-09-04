resource "openstack_compute_instance_v2" "database" {
  name      = "postgres-db"
  flavor_id = var.medium_flavor_id

  key_pair = openstack_compute_keypair_v2.db.name

  security_groups = [
    openstack_networking_secgroup_v2.db_sg.name
  ]

  block_device {
    uuid                  = var.ubuntu_image_id
    source_type           = "image"
    destination_type      = "volume"

    # İşletim sistemi diski
    volume_size = 20

    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = openstack_networking_network_v2.data_network.id
  }
}