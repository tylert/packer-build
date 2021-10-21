packer {
  required_version = "~> 1.7.7"

# required_providers {
#   qemu = {
#     source  = "github.com/hashicorp/packer-plugin-qemu"
#     version = "~> 1.0.1"
#   }
#   virtualbox = {
#     source  = "github.com/hashicorp/packer-plugin-virtualbox"
#     version = "~> 1.0.0"
#   }
# }
}

variable "apt_cache_url" {
  type    = string
  default = "http://myserver:3142"
}

variable "boot_wait" {
  type    = string
  default = "3s"
}

variable "bundle_iso" {
  type    = string
  default = "false"
}

variable "communicator" {
  type    = string
  default = "ssh"
}

variable "country" {
  type    = string
  default = "CA"
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "description" {
  type    = string
  default = "Cinnamon box for x86_64 Debian Buster 10.x"
}

variable "disk_size" {
  type    = string
  default = "7500"
}

variable "domain" {
  type    = string
  default = ""
}

variable "guest_os_type" {
  type    = string
  default = "Debian_64"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "host_port_max" {
  type    = string
  default = "4444"
}

variable "host_port_min" {
  type    = string
  default = "2222"
}

variable "http_directory" {
  type    = string
  default = "."
}

variable "http_port_max" {
  type    = string
  default = "9000"
}

variable "http_port_min" {
  type    = string
  default = "8000"
}

variable "iso_checksum" {
  type    = string
  default = "sha512:d82b0510fd919c2a851ee93ea0f7ad6779bfa597297a5c7463b63746799f001321ec4c9b8ba6cfe20248dd2da28100ad3b78e74489a8c0c573238f226a509a9d"
  # default = "file:http://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/SHA512SUMS"
}

variable "iso_file" {
  type    = string
  default = "debian-10.11.0-amd64-netinst.iso"
}

variable "iso_path_external" {
  type    = string
  default = "http://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd"
}

variable "iso_path_internal" {
  type    = string
  default = "http://myserver:8080/debian"
}

variable "keep_registered" {
  type    = string
  default = "false"
}

variable "keyboard" {
  type    = string
  default = "us"
}

variable "language" {
  type    = string
  default = "en"
}

variable "locale" {
  type    = string
  default = "en_CA.UTF-8"
}

variable "memory" {
  type    = string
  default = "768"
}

variable "min_vagrant_version" {
  type    = string
  default = "2.2.18"
}

variable "mirror" {
  type    = string
  default = "ftp.ca.debian.org"
}

variable "packer_cache_dir" {
  type    = string
  default = "${env("PACKER_CACHE_DIR")}"
}

variable "preseed_file" {
  type    = string
  default = "template/debian/10_buster/cinnamon.preseed"
}

variable "qemu_binary" {
  type    = string
  default = "qemu-system-x86_64"
}

variable "shutdown_timeout" {
  type    = string
  default = "5m"
}

variable "skip_export" {
  type    = string
  default = "false"
}

variable "ssh_agent_auth" {
  type    = string
  default = "false"
}

variable "ssh_clear_authorized_keys" {
  type    = string
  default = "false"
}

variable "ssh_disable_agent_forwarding" {
  type    = string
  default = "false"
}

variable "ssh_file_transfer_method" {
  type    = string
  default = "scp"
}

variable "ssh_fullname" {
  type    = string
  default = "Ghost Writer"
}

variable "ssh_handshake_attempts" {
  type    = string
  default = "10"
}

variable "ssh_keep_alive_interval" {
  type    = string
  default = "5s"
}

variable "ssh_password" {
  type    = string
  default = "1ma63b0rk3d"
}

variable "ssh_port" {
  type    = string
  default = "22"
}

variable "ssh_pty" {
  type    = string
  default = "false"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_username" {
  type    = string
  default = "ghost"
}

variable "start_retry_timeout" {
  type    = string
  default = "5m"
}

variable "system_clock_in_utc" {
  type    = string
  default = "true"
}

variable "timezone" {
  type    = string
  default = "UTC"
}

variable "vagrantfile_template" {
  type    = string
  default = "template/debian/10_buster/vagrant.rb.j2"
}

variable "version" {
  type    = string
  default = "0.0.0"
}

variable "vm_name" {
  type    = string
  default = "cinnamon-buster"
}

variable "vnc_vrdp_bind_address" {
  type    = string
  default = "127.0.0.1"
}

variable "vnc_vrdp_port_max" {
  type    = string
  default = "6000"
}

variable "vnc_vrdp_port_min" {
  type    = string
  default = "5900"
}
# The "legacy_isotime" function has been provided for backwards compatability, but we recommend switching to the timestamp and formatdate functions.

locals {
  output_directory = "build/${legacy_isotime("2006-01-02-15-04-05")}"
}

source "qemu" "kvm" {
  accelerator                  = "kvm"
  boot_command                 = ["<wait><wait><wait><esc><wait><wait><wait>", "/install.amd/vmlinuz ", "initrd=/install.amd/initrd.gz ", "auto=true ", "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ", "hostname=${var.vm_name} ", "domain=${var.domain} ", "interface=auto ", "vga=788 noprompt quiet --<enter>"]
  boot_wait                    = var.boot_wait
  communicator                 = var.communicator
  cpus                         = var.cpus
  disk_cache                   = "writeback"
  disk_compression             = false
  disk_discard                 = "ignore"
  disk_image                   = false
  disk_interface               = "virtio-scsi"
  disk_size                    = var.disk_size
  format                       = "raw"
  headless                     = var.headless
  host_port_max                = var.host_port_max
  host_port_min                = var.host_port_min
  http_directory               = var.http_directory
  http_port_max                = var.http_port_max
  http_port_min                = var.http_port_min
  iso_checksum                 = var.iso_checksum
  iso_skip_cache               = false
  iso_target_extension         = "iso"
  iso_target_path              = "${var.packer_cache_dir}/${var.iso_file}"
  iso_urls                     = ["${var.iso_path_internal}/${var.iso_file}", "${var.iso_path_external}/${var.iso_file}"]
  machine_type                 = "pc"
  memory                       = var.memory
  net_device                   = "virtio-net"
  output_directory             = local.output_directory
  qemu_binary                  = var.qemu_binary
  shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  shutdown_timeout             = var.shutdown_timeout
  skip_compaction              = true
  skip_nat_mapping             = false
  ssh_agent_auth               = var.ssh_agent_auth
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = var.ssh_file_transfer_method
  ssh_handshake_attempts       = var.ssh_handshake_attempts
  ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  ssh_password                 = var.ssh_password
  ssh_port                     = var.ssh_port
  ssh_pty                      = var.ssh_pty
  ssh_timeout                  = var.ssh_timeout
  ssh_username                 = var.ssh_username
  use_default_display          = false
  vm_name                      = var.vm_name
  vnc_bind_address             = var.vnc_vrdp_bind_address
  vnc_port_max                 = var.vnc_vrdp_port_max
  vnc_port_min                 = var.vnc_vrdp_port_min
}

source "virtualbox-iso" "vbox" {
  boot_command                 = ["<wait><wait><wait><esc><wait><wait><wait>", "/install.amd/vmlinuz ", "initrd=/install.amd/initrd.gz ", "auto=true ", "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.preseed_file} ", "hostname=${var.vm_name} ", "domain=${var.domain} ", "interface=auto ", "vga=788 noprompt quiet --<enter>"]
  boot_wait                    = var.boot_wait
  bundle_iso                   = var.bundle_iso
  communicator                 = var.communicator
  cpus                         = var.cpus
  disk_size                    = var.disk_size
  format                       = "ova"
  guest_additions_mode         = "disable"
  guest_os_type                = var.guest_os_type
  hard_drive_discard           = false
  hard_drive_interface         = "sata"
  hard_drive_nonrotational     = false
  headless                     = var.headless
  host_port_max                = var.host_port_max
  host_port_min                = var.host_port_min
  http_directory               = var.http_directory
  http_port_max                = var.http_port_max
  http_port_min                = var.http_port_min
  iso_checksum                 = var.iso_checksum
  iso_interface                = "sata"
  iso_target_extension         = "iso"
  iso_target_path              = "${var.packer_cache_dir}/${var.iso_file}"
  iso_urls                     = ["${var.iso_path_internal}/${var.iso_file}", "${var.iso_path_external}/${var.iso_file}"]
  keep_registered              = var.keep_registered
  memory                       = var.memory
  output_directory             = local.output_directory
  post_shutdown_delay          = "0s"
  sata_port_count              = "1"
  shutdown_command             = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  shutdown_timeout             = var.shutdown_timeout
  skip_export                  = var.skip_export
  skip_nat_mapping             = false
  ssh_agent_auth               = var.ssh_agent_auth
  ssh_clear_authorized_keys    = var.ssh_clear_authorized_keys
  ssh_disable_agent_forwarding = var.ssh_disable_agent_forwarding
  ssh_file_transfer_method     = var.ssh_file_transfer_method
  ssh_handshake_attempts       = var.ssh_handshake_attempts
  ssh_keep_alive_interval      = var.ssh_keep_alive_interval
  ssh_password                 = var.ssh_password
  ssh_port                     = var.ssh_port
  ssh_pty                      = var.ssh_pty
  ssh_timeout                  = var.ssh_timeout
  ssh_username                 = var.ssh_username
  vboxmanage                   = [["modifyvm", "{{ .Name }}", "--rtcuseutc", "off"]]
  virtualbox_version_file      = "/tmp/.vbox_version"
  vm_name                      = var.vm_name
  vrdp_bind_address            = var.vnc_vrdp_bind_address
  vrdp_port_max                = var.vnc_vrdp_port_max
  vrdp_port_min                = var.vnc_vrdp_port_min
}

build {
  description = var.description

  sources = ["source.qemu.kvm", "source.virtualbox-iso.vbox"]

  provisioner "shell" {
    binary              = false
    execute_command     = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect   = true
    inline              = ["echo '${var.ssh_username} ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99${var.ssh_username}", "chmod 0440 /etc/sudoers.d/99${var.ssh_username}"]
    inline_shebang      = "/bin/sh -e"
    only                = ["vbox", "qemu"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    binary              = false
    execute_command     = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect   = true
    inline              = ["apt-get update", "apt-get --yes dist-upgrade", "apt-get clean"]
    inline_shebang      = "/bin/sh -e"
    only                = ["vbox", "qemu"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    binary              = false
    execute_command     = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect   = true
    inline              = ["dd if=/dev/zero of=/ZEROFILL bs=16M || true", "rm /ZEROFILL", "sync"]
    inline_shebang      = "/bin/sh -e"
    only                = ["vbox", "qemu"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  post-processor "vagrant" {
    compression_level    = 6
    keep_input_artifact  = true
    only                 = ["vbox", "qemu"]
    output               = "${local.output_directory}/${var.vm_name}-${var.version}-${build.name}.box"
    vagrantfile_template = var.vagrantfile_template
  }

  post-processor "compress" {
    compression_level   = 6
    format              = ".gz"
    keep_input_artifact = true
    only                = ["qemu"]
    output              = "${local.output_directory}/${var.vm_name}.raw.gz"
  }
}
