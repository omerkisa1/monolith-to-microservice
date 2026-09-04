resource "openstack_compute_instance_v2" "bastion" {
  name            = "bastion"
  flavor_id       = var.nano_flavor_id
  key_pair        = var.bastion_keypair_name
  security_groups = [var.bastion_sg_name]

  block_device {
    uuid                  = var.ubuntu_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 15
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = var.management_network_id
  }
}

resource "openstack_networking_floatingip_v2" "bastion_floatingip" {
  pool = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "bastion_floatingip_attach" {
  floating_ip = openstack_networking_floatingip_v2.bastion_floatingip.address
  instance_id = openstack_compute_instance_v2.bastion.id
}

output "bastion_public_ip" {
  value = openstack_networking_floatingip_v2.bastion_floatingip.address
}