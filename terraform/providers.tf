terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  auth_url = "https://tr-ist-01-apigw.portvmind.com/v3"
  region   = "tr-ist-01"

  application_credential_id     = var.portvmind_access_key
  application_credential_secret = var.portvmind_secret_access_key
}