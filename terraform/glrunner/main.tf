
resource "incus_instance" "glrunner" {

  project  = var.project_name
  name     = "glrunner"
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
resource "ansible_host" "glrunner" {          #### ansible host details
  name   = incus_instance.glrunner.name
  groups = ["incus_instances", "ubuntu"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",
    ansible_host                 = incus_instance.glrunner.ipv4_address,
  }
}

output "instance_ip_addr" {
  value = incus_instance.glrunner.ipv4_address
}