packer {
  required_plugins {
    incus = {
      version = ">= 1.0.0"
      source  = "github.com/bketelsen/incus"
    }
  }
}

source "incus" "prometheus" {
  image        = "selfie-noble"
  output_image = "selfie-prometheus"
  reuse        = true
}

build {
  sources = ["incus.prometheus"]
  provisioner "file" {  
    source = "prometheus/prometheus.service"  
    destination = "/etc/systemd/system/prometheus.service"
  }
  provisioner "shell" {
    scripts = [
      "prometheus/build.sh",
    ]
  }

}

