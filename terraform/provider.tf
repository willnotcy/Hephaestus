terraform {
  required_version = ">= 0.14"  
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.69.0"
    }
  }
}

provider "proxmox" {
  endpoint      = var.pm_url
  api_token     = var.pm_token_secret
  insecure      = var.pm_tls_insecure
  ssh {
    agent = true
    username = var.pm_ssh_username
    password = var.pm_ssh_password
  }
}
