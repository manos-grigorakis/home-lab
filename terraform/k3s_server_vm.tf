resource "proxmox_virtual_environment_vm" "k3s_server_vm" {
  for_each = local.k3s_servers

  node_name   = var.pve_node_name
  vm_id       = each.value.id
  name        = each.key
  description = "Managed by Terraform"
  tags        = each.value.tags

  machine       = "q35"
  bios          = var.bios
  started       = true # Start after creation
  on_boot       = false # Start at server boot
  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0"]

  operating_system {
    type = "l26" # Linux 6.x - 2.6 Kernel
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu_cores
    type  = "x86-64-v2-AES" # recommended for modern CPUs
  }

  memory {
    dedicated = each.value.memory
  }

  # Create an EFI disk when the bios is set to ovmf
  dynamic "efi_disk" {
    for_each = (var.bios == "ovmf" ? [1] : [])
    content {
      datastore_id      = "local-lvm"
      file_format       = "raw"
      type              = "4m"
      pre_enrolled_keys = true
    }
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    size         = 20
    discard      = "on"
    iothread     = true
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    ssd          = true
    backup       = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ipv4
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    # Cloud config
    #user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[each.key].id

  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
    model    = "virtio"
  }
}