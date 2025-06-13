terraform {
  required_version = ">=1.5.7"
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = ">=0.1.1"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}


provider "incus" {

  remote {
    name    = "selfie"
    scheme  = "https"
    address = "10.0.1.57"
    default = true
  }
}
