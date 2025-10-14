locals {
  k3s_servers = {
    "k3s-server-10" = {
      id   = 400
      name = "K3s-server-test-10"
      cpu_cores = 2
      memory = 4096
      ipv4 = "192.168.10.231/24"
      hostname = "k3s-server-test-10"
      tags = ["terraform", "cluster", "server"]
    }
    "k3s-server-20" = {
      id   = 401
      name = "k3s-server-test-20"
      cpu_cores = 2
      memory = 1024
      ipv4 = "192.168.10.232/24"
      hostname = "k3s-server-test-20"
      tags = ["terraform", "cluster", "server"]
    }
  }
}