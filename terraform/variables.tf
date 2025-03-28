###########
# General #
###########
variable "cluster_name" {
  description = "Name of cluster"
  type        = string
  default     = "hephaestus"
}

variable "gateway" {
  description = "Gateway IP"
  type        = string  
  default     = "192.168.0.1"
}

variable "ci_template" {
  description = "Source cloud init template to clone in Proxmox."
  type        = string
  default     = "vm-9991-cloudinit"
}

variable "qemu_agent" {
  description = "Enable qemu guest agent"
  type        = bool
  default     = true
}

variable "os_type" {
  description = "OS Type, cloud-init"
  type        = string
  default     = "cloud-init"
}

variable "disk_type" {
  description = "Disk type to use for volumes"
  type        = string
  default     = "scsi"
}

variable "disk_interface" {
  description = "Disk interface to use for volumes"
  type        = string
  default     = "virtio0"
}

variable "disk_iothread" {
  description = "Enable iothread for disk"
  type        = bool
  default     = true
}

variable "disk_discard" {
  description = "Set block storage discard"
  type        = string
  default     = "on"
}

variable "storage_pool" {
  description = "Storage pool in Proxmox to use for volumes"
  type        = string
  default     = "local-lvm"
}

variable "bios" {
  description = "BIOS Setting for Proxmox VM"
  type        = string
  default     = "seabios"
}

variable "scsihw" {
  description = "Bios SCSI Controller for Proxmox VM"
  type        = string
  default     = "virtio-scsi-pci"
}

variable "ipv4_address" {
  description = "IPV4 Address"
  type        = string
  default     = "dhcp"
}

variable "network_bridge" {
  description = "Network device bridge"
  type        = string
  default     = "vmbr0"
}

variable "host_usb" {
  description = "Host usb devide (Sonoff Zigbee Gateway)"
  type        = string
  default     = "10c4:ea60"
}

variable "k3s_cpu_type" {
  description = "The emulated CPU type"
  type        = string
  default     = "host"
}

#######
# SSH #
#######



##########
# Master #
##########
variable "k3s_master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "k3s_master_disk_size" {
  description = "Disk size of the controlplane nodes"
  type        = string
  default     = "25"
}

variable "k3s_master_cores" {
  description = "Cores for each controlplane node"
  type        = number
  default     = 2
}

variable "k3s_master_memory" {
  description = "Memory for each controlplane node"
  type        = string
  default     = "12288"
}

variable "k3s_master_name_prefix" {
  description = "Prefix for the controlplane node name"
  type        = string
  default     = "-k3s-master-"
}


##########
# Worker #
##########
variable "k3s_worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "k3s_worker_disk_size" {
  type    = string
  default = "25"
}

variable "k3s_worker_cores" {
  description = "Cores for each worker node"
  type        = number
  default     = 2
}

variable "k3s_worker_memory" {
  description = "Memory for each worker node"
  type        = string
  default     = "12288"
}

variable "k3s_worker_name_prefix" {
  description = "Prefix for the controlplane node name"
  type        = string
  default     = "-k3s-worker-"
}

###########
# Proxmox #
###########
variable "pm_url" {
  description = "The url for the proxmox api on the host"
  type        = string
  default     = "https://192.168.0.37:8006/"
}

variable "pm_token_secret" {
  description = "The token secret for the proxmox secret"
  type        = string
  sensitive   = true
}

variable "pm_token_id" {
  description = "The token id for the proxmox secret"
  type        = string
}

variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = true
}

variable "pm_node_name" {
  description = "name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

variable "pm_datastore_id" {
  description = "Id of the proxmox datastore used for snippets"
  type        = string
  default     = "local"
}

variable "pm_snippet_content_type" {
  description = "Content type used for proxmox snippets"
  type        = string
  default     = "snippets"
}

variable "pm_cloud_image_content_type" {
  description = "Content type used for proxmox cloud images"
  type        = string
  default     = "iso"
}

variable "pm_cloud_image_url" {
  description = "Url for the Cloud image to be cloned onto proxmox"
  type        = string
  default     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

variable "pm_ssh_username" {
  description = "The user used by proxmox provider to access prommox node"
  type        = string
  default     = "terraform-prov"
}

variable "pm_ssh_password" {
  description = "The password for the user used by proxmox provider to access prommox node"
  type        = string
  sensitive   = true
}