provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = "${var.pve_token_id}=${var.pve_api_token}"

  # Because self-signed TLS certificate is in use
  insecure = true

  ssh {
    agent       = true
    username    = var.pve_user
    private_key = file("~/.ssh/id_ed25519_terraform_homelab")
  }
}