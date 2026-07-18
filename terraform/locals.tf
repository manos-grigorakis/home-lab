locals {
  k3s_servers = {

  }

  k3s_agents = {

  }

  ubuntu_containers = {
    "uptime-kuma" = {
      id            = 103
      hostname      = "uptime-kuma"
      tags          = ["terraform", "monitoring"]
      cpu_cores     = 1
      memory        = 1024
      ipv4          = "192.168.10.43/24"
      storage_size  = 20
      startup_order = 5
    }

    "netbox" = {
      id            = 105
      hostname      = "netbox"
      tags          = ["terraform"]
      cpu_cores     = 2
      memory        = 4096
      ipv4          = "192.168.10.48/24"
      storage_size  = 20
      startup_order = 100
    }

    "qbittorent" = {
      id            = 106
      hostname      = "qbittorent"
      tags          = ["terraform"]
      cpu_cores     = 1
      memory        = 1024
      ipv4          = "192.168.10.50/24"
      storage_size  = 20
      startup_order = 100
    }

    "coolify" = {
      id            = 120
      hostname      = "coolify"
      tags          = ["terraform"]
      cpu_cores     = 4
      memory        = 8192
      ipv4          = "192.168.10.56/24"
      storage_size  = 100
      startup_order = 20
    }

  }

  other_vm = {
    hardening-ubuntu = {
      id        = 210
      cpu_cores = 2
      memory    = 4096
      size      = 40
      ipv4      = "192.168.10.141/24"
      hostname  = "hardening-ubuntu"
      tags      = ["terraform"]
      started   = false
    }
  }
}