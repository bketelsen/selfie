
resource "incus_instance" "prometheus" {

  project  = var.project_name
  name     = "prometheus"
  type     = "container"
  image    = var.image
  profiles = ["default", "br0"]
  config = {
    "security.nesting" = true
    "raw.idmap" = "both 1000 1000"
  }

  lifecycle {
    ignore_changes = [ running ]
  }
}
resource "ansible_host" "prometheus" {          #### ansible host details
  name   = incus_instance.prometheus.name
  groups = ["incus_instances", "ubuntu"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",
    ansible_host                 = incus_instance.prometheus.ipv4_address,
  }
}

output "instance_ip_addr" {
  value = incus_instance.prometheus.ipv4_address
}