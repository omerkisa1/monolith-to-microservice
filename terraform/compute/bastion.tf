resource "openstack_compute_instance_v2" "bastion" {
  name            = "bastion"
  flavor_id       = var.nano_flavor_id
  key_pair        = openstack_compute_keypair_v2.bastion.name
  security_groups = [openstack_networking_secgroup_v2.bastion_sg.name]

  block_device {
    uuid                  = var.ubuntu_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 15
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = openstack_networking_network_v2.bastion_network.id
  }
}

resource "openstack_networking_floatingip_v2" "bastion_floatingip" {
  pool = data.openstack_networking_network_v2.public_network.name
}

resource "openstack_compute_floatingip_associate_v2" "bastion_floatingip_attach" {
  floating_ip = openstack_networking_floatingip_v2.bastion_floatingip.address
  instance_id = openstack_compute_instance_v2.bastion.id
}

output "bastion_public_ip" {
  value = openstack_networking_floatingip_v2.bastion_floatingip.address
}