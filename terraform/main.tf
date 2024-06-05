resource "incus_storage_pool" "default" {
  name    = "default"
  driver  = "btrfs"
}

import {
  to = incus_storage_pool.default
  id = "default"
}

module "grafana" {
  source = "./grafana"
  project_name   = "services"
  image           = "selfie-grafana"
}
module "prometheus" {
  source = "./prometheus"
  project_name   = "services"
  image           = "selfie-prometheus"
}


module "syncthing" {
  source = "./syncthing"
  project_name   = "services"
  image           = "selfie-syncthing"
}
