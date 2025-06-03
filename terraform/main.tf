
module "prometheus" {
  source = "./prometheus"
  project_name   = "default"
  image           = "selfie-noble"
}

output "prometheus_ipv4_address" {
  value = module.prometheus.instance_ip_addr
}