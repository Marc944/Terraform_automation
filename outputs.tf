output "jenkins_public_ip" {
  value = module.jenkins.public_ip
}

output "aks_name" {
  value = module.aks.cluster_name
}

output "acr_name" {
  value = module.acr.name
}

