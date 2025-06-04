
module "prometheus" {
  source = "./prometheus"
  project_name   = "default"
  image           = "selfie-noble"
}
module "glrunner" {
  source = "./glrunner"
  project_name   = "default"
  image           = "selfie-noble"
}
output "prometheus_ipv4_address" {
  value = module.prometheus.instance_ip_addr
}
output "glrunner_ipv4_address" {
  value = module.glrunner.instance_ip_addr
}