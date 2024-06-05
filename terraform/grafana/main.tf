

resource "incus_instance" "grafana" {

  project  = var.project_name
  name     = "grafana"
  type     = "container"
  image    = var.image
  profiles = ["default"]
  config = {
    "security.nesting" = true
    "raw.idmap" = "both 1000 1000"
  }

  lifecycle {
    ignore_changes = [ running ]
  }
}
