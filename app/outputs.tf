output "sample_app_external_ip" {
  description = "Public IP to access the sample NGINX app"
  value       = kubernetes_service.sample_app_lb.status[0].load_balancer[0].ingress[0].ip
}
