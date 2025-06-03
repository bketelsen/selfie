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
