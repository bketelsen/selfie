packer {
  required_plugins {
    incus = {
      version = ">= 1.0.0"
      source  = "github.com/bketelsen/incus"
    }
  }
}

source "incus" "syncthing" {
  image        = "selfie-noble"
  output_image = "selfie-syncthing"
  reuse        = true
}

build {
  sources = ["incus.syncthing"]
  provisioner "shell" {
    scripts = [
      "common/install-go.sh",
      "syncthing/build.sh",

    ]
  }

}

