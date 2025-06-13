
resource "incus_profile" "br0" {

  name = "br0"
  description = "Bridge profile for br0"
  device {
    name = "eth0"
    type = "nic"
    properties = {
      name = "eth0"
      nictype = "bridged"
      parent = "br0"
    }
  }
   lifecycle {
    create_before_destroy = true
  }
}
resource "incus_profile" "br5" {

  name = "br5"
  description = "Bridge profile for br5"
  device {
    name = "eth0"
    type = "nic"
    properties = {
      name = "eth0"
      nictype = "bridged"
      parent = "br5"
    }
  }
   lifecycle {
    create_before_destroy = true
    ignore_changes = [  ]
  }
}
