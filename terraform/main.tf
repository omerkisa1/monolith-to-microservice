module "network" {
  source = "./network"

  external_network_id     = var.external_network_id
  management_network_cidr = var.management_network_cidr
  rke2_network_cidr       = var.rke2_network_cidr
  data_network_cidr       = var.data_network_cidr
}

module "keypair" {
  source = "./keypair"

  bastion_public_key_path = var.bastion_public_key_path
  rke2_public_key_path    = var.rke2_public_key_path
  db_public_key_path      = var.db_public_key_path
}

module "security" {
  source = "./security"

  admin_cidr = var.admin_cidr

  management_network_cidr = var.management_network_cidr
  rke2_network_cidr       = var.rke2_network_cidr
  data_network_cidr       = var.data_network_cidr
}

module "compute" {
  source = "./compute"

  ubuntu_image_id  = var.ubuntu_image_id
  nano_flavor_id   = var.nano_flavor_id
  medium_flavor_id = var.medium_flavor_id

  master_count           = var.master_count
  worker_count           = var.worker_count
  ingress_http_nodeport  = var.ingress_http_nodeport
  ingress_https_nodeport = var.ingress_https_nodeport

  management_network_id = module.network.management_network_id
  rke2_network_id       = module.network.rke2_network_id
  rke2_subnet_id        = module.network.rke2_subnet_id
  data_network_id       = module.network.data_network_id

  external_network_name = module.network.external_network_name

  bastion_keypair_name = module.keypair.bastion_keypair_name
  rke2_keypair_name    = module.keypair.rke2_keypair_name
  db_keypair_name      = module.keypair.db_keypair_name

  bastion_sg_name = module.security.bastion_sg_name
  master_sg_name  = module.security.master_sg_name
  worker_sg_name  = module.security.worker_sg_name
  db_sg_name      = module.security.db_sg_name
}