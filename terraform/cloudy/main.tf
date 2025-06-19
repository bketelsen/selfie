
data "cloudinit_config" "cloudy" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "hello-script.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/hello-script.sh")
  }

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = file("${path.module}/cloud-config.yaml")
  }
}

resource "incus_instance" "cloudy" {

  project  = var.project_name
  name     = "cloudy"
  type     = "container"
  image    = var.image
  profiles = ["default", "br0"]
  config = {
    "security.nesting" = true
    "raw.idmap" = "both 1000 1000"
    "cloud-init.user-data" = data.cloudinit_config.cloudy.rendered
  }

  lifecycle {
    ignore_changes = [ running ]
  }
}
resource "ansible_host" "cloudy" {          #### ansible host details
  name   = incus_instance.cloudy.name
  groups = ["incus_instances", "ubuntu"]
  variables = {
    ansible_user                 = "ubuntu",
    ansible_become              = true,
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",
    ansible_host                 = incus_instance.cloudy.ipv4_address,
  }
}

output "instance_ip_addr" {
  value = incus_instance.cloudy.ipv4_address
}