
resource "incus_project" "this" {
  name        = var.project_name
  description = "Project used to test incus-deploy services"
  config = {
    "features.images"          = false
    "features.networks"        = false
    "features.networks.zones"  = false
    "features.profiles"        = false
    "features.storage.buckets" = true
    "features.storage.volumes" = true
  }
}

resource "incus_instance" "mysyncthing" {

  project  = incus_project.this.name
  name     = "mysyncthing"
  type     = "container"
  image    = var.image
  profiles = ["default"]
  config = {
    "security.nesting" = true
    "raw.idmap" = "both 1000 1000"
  }

  device {
    name = "myhome"
    type = "disk"
    properties = {
      path   = "/var/hosthome"
      source = "/var/home/bjk"
    }
  }

  lifecycle {
    ignore_changes = [ running ]
  }
}
