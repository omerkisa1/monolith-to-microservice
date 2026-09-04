module "network" {
  source = "./network"

  external_network_id = var.external_network_id
}

module "keypair" {
  source = "./keypair"

  # gerekiyorsa key path variable'larını buradan geçirirsin
  bastion_public_key_path = var.bastion_public_key_path
  rke2_public_key_path    = var.rke2_public_key_path
  db_public_key_path      = var.db_public_key_path
}

module "security" {
  source = "./security"

  admin_cidr = var.admin_cidr

  # security kurallarında gerekirse network CIDR'larını burada geçirirsin
  management_network_cidr = var.management_network_cidr
  rke2_network_cidr       = var.rke2_network_cidr
  data_network_cidr       = var.data_network_cidr
}

module "compute" {
  source = "./compute"

  ubuntu_image_id  = var.ubuntu_image_id
  nano_flavor_id   = var.nano_flavor_id
  medium_flavor_id = var.medium_flavor_id

  # NETWORK OUTPUTLARI
  management_network_id = module.network.management_network_id
  rke2_network_id       = module.network.rke2_network_id
  rke2_subnet_id        = module.network.rke2_subnet_id
  data_network_id       = module.network.data_network_id

  external_network_name = module.network.external_network_name

  # KEYPAIR OUTPUTLARI
  bastion_keypair_name = module.keypair.bastion_keypair_name
  rke2_keypair_name    = module.keypair.rke2_keypair_name
  db_keypair_name      = module.keypair.db_keypair_name

  # SECURITY OUTPUTLARI
  bastion_sg_name = module.security.bastion_sg_name
  master_sg_name  = module.security.master_sg_name
  worker_sg_name  = module.security.worker_sg_name
  db_sg_name      = module.security.db_sg_name
}