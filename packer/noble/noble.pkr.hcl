packer {
  required_plugins {
    incus = {
      version = ">= 1.0.0"
      source  = "github.com/bketelsen/incus"
    }
  }
}

source "incus" "noble" {
  image        = "images:ubuntu/noble"
  output_image = "selfie-noble"
  reuse        = true
}

build {
  sources = ["incus.noble"]
  provisioner "file" {
    source = "common/90-incus"
    destination = "/tmp/90-incus"
  }

  provisioner "shell" {
    scripts = [
      "common/packages.sh",
      "common/sudoers.sh",
    ]
  }

}

