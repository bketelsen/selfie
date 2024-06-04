resource "incus_storage_pool" "default" {
  name    = "default"
  driver  = "btrfs"
}

import {
  to = incus_storage_pool.default
  id = "default"
}

module "syncthing" {
  source = "./syncthing"
  project_name   = "services"
  image           = "selfie-syncthing"
}
