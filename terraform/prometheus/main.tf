
resource "incus_instance" "prometheus" {

  project  = var.project_name
  name     = "prometheus"
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


resource "incus_instance_file" "file1" {
  instance           = incus_instance.prometheus.name
  project  = var.project_name
  source_path        = "prometheus/prometheus.yml"
  target_path        = "/opt/prometheus/prometheus.yml"
  uid                = 1001
  gid                = 1001
  mode              = "0644"
  create_directories = true
}