variable "portvmind_access_key" { type = string }
variable "portvmind_secret_access_key" { type = string }
variable "tenant_id" { type = string }
variable "ubuntu_image_id" { type = string }
variable "external_network_id" { type = string }
variable "medium_flavor_id" { type = string }
variable "nano_flavor_id" { type = string }
variable "admin_cidr" { type = string }
variable "private_network_cidr" { type = string }
variable "bastion_public_key_path" { type = string }
variable "rke2_public_key_path" { type = string }
variable "db_public_key_path" { type = string }
variable "bastion_network_cidr" { type = string }
variable "rke2_network_cidr" { type = string }
variable "data_network_cidr" { type = string }

variable "master_count" {
  type    = number
  default = 3
}

variable "worker_count" {
  type    = number
  default = 2
}

variable "ingress_http_nodeport" {
  type    = number
  default = 30080
}

variable "ingress_https_nodeport" {
  type    = number
  default = 30443
}
