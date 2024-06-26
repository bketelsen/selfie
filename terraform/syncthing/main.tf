
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

data "packer_version" "version" {}
data "packer_files" "syncthing" {
  file = "syncthing/syncthing.pkr.hcl"
}


resource "packer_image" "syncthing" {
  file = data.packer_files.syncthing.file
  variables = {
    image      = var.image
  }
  triggers = {
    packer_version = data.packer_version.version.version
    files_hash     = data.packer_files.syncthing.files_hash
  }
}


resource "terraform_data" "replacement" {
  input = packer_image.syncthing.build_uuid
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
    replace_triggered_by = [ terraform_data.replacement.output ]
  }
}
