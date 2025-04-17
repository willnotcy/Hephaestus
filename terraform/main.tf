data "local_file" "ssh_public_key" {
  filename = "./ssh_host_ed25519.pub"
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "usb_device" {
  comment = "USB Device"
  name    = "usb_passthrough"
  
  map = [
    {
      comment = "Sonoff Zigbee 3.0 USB Dongle Plus"
      id      = var.host_usb
      node    = var.pm_node_name
    },
  ]
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = var.pm_snippet_content_type
  datastore_id = var.pm_datastore_id
  node_name    = var.pm_node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    users:
      - default
      - name: ubuntu
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_file.ssh_public_key.content)}
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMR5+iuMQAV5C5uwYoaRspziWVueXwcXd+d1XOL4rsku markkristensen@outlook.com
        sudo: ALL=(ALL) NOPASSWD:ALL
    runcmd:
        - apt update
        - apt install -y qemu-guest-agent net-tools nfs-common
        - timedatectl set-timezone Europe/Copenhagen
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_file" "metadata_cloud_config_master" {
  content_type = var.pm_snippet_content_type
  datastore_id = var.pm_datastore_id
  node_name    = var.pm_node_name

  count = var.k3s_master_count

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${join("", [var.cluster_name, var.k3s_master_name_prefix, count.index + 1])}
    EOF

    file_name = "metadata-cloud-config-k3s-master-${count.index + 1}.yaml"
  }
}

resource "proxmox_virtual_environment_file" "metadata_cloud_config_worker" {
  content_type = var.pm_snippet_content_type
  datastore_id = var.pm_datastore_id
  node_name    = var.pm_node_name

  count = var.k3s_worker_count

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${join("", [var.cluster_name, var.k3s_worker_name_prefix, count.index + 1])}
    EOF

    file_name = "metadata-cloud-config-k3s-worker-${count.index + 1}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "proxmox_vm_master" {
  count       = var.k3s_master_count
  name        = join("", [var.cluster_name, var.k3s_master_name_prefix, count.index +1])
  node_name   = var.pm_node_name

  initialization {
    ip_config {
      ipv4 {
        address = var.ipv4_address
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    meta_data_file_id  = proxmox_virtual_environment_file.metadata_cloud_config_master[count.index].id
  }

  agent {
    enabled = var.qemu_agent
  }  

  cpu {
    cores = var.k3s_master_cores
    type = var.k3s_cpu_type
  }

  memory {
    dedicated = var.k3s_master_memory
  }

  disk {
    datastore_id = var.storage_pool
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = var.disk_interface
    iothread     = var.disk_iothread
    discard      = var.disk_discard
    size         = var.k3s_master_disk_size
  }

  network_device {
    bridge = var.network_bridge
  }

#  usb {
#    mapping = proxmox_virtual_environment_hardware_mapping_usb.usb_device.id
#  }
}

resource "proxmox_virtual_environment_vm" "proxmox_vm_worker" {
  count       = var.k3s_worker_count
  name        = join("", [var.cluster_name, var.k3s_worker_name_prefix, count.index +1])
  node_name   = var.pm_node_name

  initialization {
    ip_config {
      ipv4 {
        address = var.ipv4_address
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    meta_data_file_id  = proxmox_virtual_environment_file.metadata_cloud_config_worker[count.index].id
  }

  agent {
    enabled = var.qemu_agent
  }  

  cpu {
    cores = var.k3s_worker_cores
    type = var.k3s_cpu_type
  }

  memory {
    dedicated = var.k3s_worker_memory
  }

  disk {
    datastore_id = var.storage_pool
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = var.disk_interface
    iothread     = var.disk_iothread
    discard      = var.disk_discard
    size         = var.k3s_worker_disk_size
  }

  network_device {
    bridge = var.network_bridge
  }

#  usb {
#    mapping = proxmox_virtual_environment_hardware_mapping_usb.usb_device.id
#  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = var.pm_cloud_image_content_type
  datastore_id = var.pm_datastore_id
  node_name    = var.pm_node_name

  url = var.pm_cloud_image_url
}


output "vm_info" {
  value = [
    for vm in concat(
      proxmox_virtual_environment_vm.proxmox_vm_master,
      proxmox_virtual_environment_vm.proxmox_vm_worker
    ) :
    {
      vm_name   = vm.name
      ip_address = vm.ipv4_addresses[1][0]
    }
  ]
}