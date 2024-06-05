packer {
  required_plugins {
    incus = {
      version = ">= 1.0.0"
      source  = "github.com/bketelsen/incus"
    }
  }
}

source "incus" "grafana" {
  image        = "selfie-noble"
  output_image = "selfie-grafana"
  reuse        = true
}

build {
  sources = ["incus.grafana"]
  provisioner "shell" {
    scripts = [
      "grafana/build.sh",
    ]
  }

}

