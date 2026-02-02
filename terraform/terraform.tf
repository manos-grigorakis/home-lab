terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.94.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  required_version = ">= 1.13"
}