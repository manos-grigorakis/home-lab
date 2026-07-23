terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "6.56.0"
    }
  }

  required_version = ">= 1.13"
}