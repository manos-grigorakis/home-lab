locals {
  k3s_servers = {
    # "k3s-server-10" = {
    #   id        = 400
    #   name      = "K3s-server-test-10"
    #   cpu_cores = 2
    #   memory    = 4096
    #   ipv4      = "192.168.10.231/24"
    #   hostname  = "k3s-server-test-10"
    #   tags      = ["terraform", "cluster", "server"]
    # }
    # "k3s-server-20" = {
    #   id        = 401
    #   name      = "k3s-server-test-20"
    #   cpu_cores = 2
    #   memory    = 1024
    #   ipv4      = "192.168.10.232/24"
    #   hostname  = "k3s-server-test-20"
    #   tags      = ["terraform", "cluster", "server"]
    # }
  }

  k3s_agents = {
    # "k3s-agent-10" = {
    #   id        = 410
    #   name      = "K3s-agent-test-10"
    #   cpu_cores = 2
    #   memory    = 1024
    #   ipv4      = "192.168.10.233/24"
    #   hostname  = "k3s-agent-10"
    #   tags      = ["terraform", "cluster", "agent"]
    #   igpu      = false
    # }
    # "k3s-agent-20" = {
    #   id        = 411
    #   name      = "K3s-agent-20"
    #   cpu_cores = 2
    #   memory    = 1024
    #   ipv4      = "192.168.10.234/24"
    #   hostname  = "k3s-agent-20"
    #   tags      = ["terraform", "cluster", "agent"]
    #   igpu      = false
    # }
  }

  debian_containers = {
    "K3s-database" = {
      id           = 108
      hostname     = "k3s-database"
      tags         = ["terraform", "cluster"]
      cpu_cores    = 2
      memory       = 4096
      ipv4         = "192.168.10.44/24"
      storage_size = 40
      startup_order = 2
    }

    "K3s-proxy" = {
      id           = 109
      hostname     = "k3s-proxy"
      tags         = ["terraform", "cluster"]
      cpu_cores    = 2
      memory       = 1024
      ipv4         = "192.168.10.45/24"
      storage_size = 8
      startup_order = 2
    }

  }
}