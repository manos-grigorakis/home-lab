locals {
  vms_group = merge(local.k3s_servers, local.k3s_agents, local.other_vm)
}

data "local_file" "ssh_public_keys" {
  filename = "./ssh_keys.pub"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  for_each = local.vms_group

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${each.value.hostname}
    timezone: ${var.timezone}
    ssh_pwauth: false # Disable SSH with password
    users:
      - default
      - name: ${var.vm_user}
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
%{for key in split("\n", trimspace(data.local_file.ssh_public_keys.content))~}
          - ${key}
%{endfor~}
        sudo: ALL=(ALL) ALL
        passwd: ${var.vm_password_hashed}
        lock_passwd: false
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "${each.value.hostname}-user-data-cloud-config.yaml"
  }
}