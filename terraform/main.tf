
module "prometheus" {
  source = "./prometheus"
  project_name   = "default"
  image           = "selfie-noble"
}
module "cloudy" {
  source = "./cloudy"
  project_name   = "default"
  image           = "images:debian/trixie/cloud"
}
output "prometheus_ipv4_address" {
  value = module.prometheus.instance_ip_addr
}
output "cloudy_ipv4_address" {
  value = module.cloudy.instance_ip_addr
}

module "profiles" {
  source = "./profiles"
}