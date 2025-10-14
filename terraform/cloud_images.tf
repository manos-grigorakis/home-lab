resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.pve_node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"

  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "ubuntu-server-24-04-lts-noble-server-cloudimg-amd64.qcow2"
}