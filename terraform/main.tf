terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

################################
# Providers
################################

provider "docker" {}

provider "null" {}

################################
# Docker Network (IaC-managed)
################################

resource "docker_network" "sockshop" {
  name = "sockshop-network"
}

################################
# Application Deployment
# (Triggered via Terraform)
################################

resource "null_resource" "deploy_sockshop" {

  depends_on = [
    docker_network.sockshop
  ]

  provisioner "local-exec" {
    command = <<EOT
      cd ../deploy/docker-compose
      docker compose up -d
    EOT
  }

  triggers = {
    redeploy = timestamp()
  }
}
