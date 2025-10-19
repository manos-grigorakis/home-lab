resource "proxmox_virtual_environment_container" "ubuntu_container" {
  for_each = local.ubuntu_containers

  node_name     = var.pve_node_name
  vm_id         = each.value.id
  description   = "Managed by Terraform"
  started       = true
  start_on_boot = true
  tags          = each.value.tags

  # newer linux distributions require unprivileged user namespaces
  unprivileged = true
  features {
    nesting = true
  }

  cpu {
    cores        = each.value.cpu_cores
    architecture = "amd64"
  }

  memory {
    dedicated = each.value.memory
  }

  initialization {
    hostname = each.value.hostname

    ip_config {
      ipv4 {
        address = each.value.ipv4
        gateway = var.gateway
      }
    }

    user_account {
      keys = [trimspace(data.local_file.ssh_public_keys.content)]
    }
  }

  network_interface {
    name     = "eth0"
    bridge   = "vmbr0"
    firewall = true
  }

  disk {
    datastore_id = "local-lvm"
    size         = 4
  }

  operating_system {
    # Download template manually on PVE from CT Templates -> Templates
    # pvesm list <storage>
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    type             = "ubuntu"
  }

  mount_point {
    # volume mount, a new volume will be created by PVE
    volume = "local-lvm"
    size   = "${each.value.storage_size}G"
    path   = "/mnt/volume"
    backup = true
  }

  startup {
    order = each.value.startup_order
  }
}

