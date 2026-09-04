variable "ubuntu_image_id" {
  type = string
}

variable "nano_flavor_id" {
  type = string
}

variable "medium_flavor_id" {
  type = string
}

variable "master_count" {
  type = number
}

variable "worker_count" {
  type = number
}

variable "ingress_http_nodeport" {
  type = number
}

variable "ingress_https_nodeport" {
  type = number
}

variable "rke2_network_id" {
  type = string
}

variable "rke2_subnet_id" {
  type = string
}

variable "data_network_id" {
  type = string
}

variable "external_network_name" {
  type = string
}

variable "bastion_keypair_name" {
  type = string
}

variable "rke2_keypair_name" {
  type = string
}

variable "db_keypair_name" {
  type = string
}

variable "bastion_sg_name" {
  type = string
}

variable "master_sg_name" {
  type = string
}

variable "worker_sg_name" {
  type = string
}

variable "db_sg_name" {
  type = string
}

variable "bastion_network_id" {
  type = string
}