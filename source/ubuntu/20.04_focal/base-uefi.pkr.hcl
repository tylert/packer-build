packer {
  required_version = ">= 1.7.0, < 2.0.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.0, < 2.0.0"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.0.0, < 2.0.0"
    }
  }
}

variable "apt_cache_url" {
  type    = string
  default = "http://myserver:3142"
}

variable "boot_wait" {
  type    = string
  default = "6s"
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
  default = "Base box (UEFI) for x86_64 Ubuntu Focal Fossa 20.04.x LTS"
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
  default = "Ubuntu_64"
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
  default = "sha256:28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
  # default = "file:http://releases.ubuntu.com/20.04/SHA256SUMS"
}

variable "iso_file" {
  type    = string
  default = "ubuntu-20.04.4-live-server-amd64.iso"
}

variable "iso_path_external" {
  type    = string
  default = "http://releases.ubuntu.com/20.04"
}

variable "iso_path_internal" {
  type    = string
  default = "http://myserver:8080/ubuntu"
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
  default = "1024"
}

variable "min_vagrant_version" {
  type    = string
  default = "2.3.0"
}

variable "packer_cache_dir" {
  type    = string
  default = "${env("PACKER_CACHE_DIR")}"
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
  default = "100"
}

variable "ssh_keep_alive_interval" {
  type    = string
  default = "5s"
}

variable "ssh_password" {
  type    = string
  default = "1ma63b0rk3d"
}

variable "ssh_password_crypted" {
  type    = string
  default = "$6$w5yFawT.$d51yQ513SdzariRCjomBwO9IMtMh6.TjnRwQqTBlOMwGhyyVXlJeYC9kanFp65bpoS1tn9x7r8gLP5Dg4CtEP1"
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

variable "user_data_location" {
  type    = string
  default = "user-data"
}

variable "vagrantfile_template" {
  type    = string
  default = "vagrant.rb.j2"
}

variable "version" {
  type    = string
  default = "0.0.0"
}

variable "vm_name" {
  type    = string
  default = "base-uefi-focal"
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

# The "legacy_isotime" function has been provided for backwards compatability,
# but we recommend switching to the timestamp and formatdate functions.

locals {
  output_directory = "build/${legacy_isotime("2006-01-02-15-04-05")}"
}

source "qemu" "qemu" {
  accelerator = "kvm"
  boot_command = [
    "<wait><wait><wait><esc><esc><esc><enter><wait><wait><wait>",
    "/casper/vmlinuz root=/dev/sr0 initrd=/casper/initrd autoinstall ",
    "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.user_data_location}/",
    "<enter>"
  ]
  boot_wait            = var.boot_wait
  communicator         = var.communicator
  cpus                 = var.cpus
  disk_cache           = "writeback"
  disk_compression     = false
  disk_discard         = "ignore"
  disk_image           = false
  disk_interface       = "virtio-scsi"
  disk_size            = var.disk_size
  format               = "raw"
  headless             = var.headless
  host_port_max        = var.host_port_max
  host_port_min        = var.host_port_min
  http_content         = { "/user-data" = templatefile(var.user_data_location, { var = var }) }
  http_port_max        = var.http_port_max
  http_port_min        = var.http_port_min
  iso_checksum         = var.iso_checksum
  iso_skip_cache       = false
  iso_target_extension = "iso"
  iso_target_path      = "${regex_replace(var.packer_cache_dir, "^$", "/tmp")}/${var.iso_file}"
  iso_urls = [
    "${var.iso_path_internal}/${var.iso_file}",
    "${var.iso_path_external}/${var.iso_file}"
  ]
  machine_type     = "pc"
  memory           = var.memory
  net_device       = "virtio-net"
  output_directory = local.output_directory
  qemu_binary      = var.qemu_binary
  qemuargs = [
    ["-bios", "OVMF.fd"]
  ]
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
  boot_command = [
    "<wait><wait><wait><esc><esc><esc><enter><wait><wait><wait>",
    "/casper/vmlinuz root=/dev/sr0 initrd=/casper/initrd autoinstall ",
    "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.user_data_location}/",
    "<enter>"
  ]
  boot_wait                = var.boot_wait
  bundle_iso               = var.bundle_iso
  communicator             = var.communicator
  cpus                     = var.cpus
  disk_size                = var.disk_size
  format                   = "ova"
  guest_additions_mode     = "disable"
  guest_os_type            = var.guest_os_type
  hard_drive_discard       = false
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = false
  headless                 = var.headless
  host_port_max            = var.host_port_max
  host_port_min            = var.host_port_min
  http_content             = { "/user-data" = templatefile(var.user_data_location, { var = var }) }
  http_port_max            = var.http_port_max
  http_port_min            = var.http_port_min
  iso_checksum             = var.iso_checksum
  iso_interface            = "sata"
  iso_target_extension     = "iso"
  iso_target_path          = "${regex_replace(var.packer_cache_dir, "^$", "/tmp")}/${var.iso_file}"
  iso_urls = [
    "${var.iso_path_internal}/${var.iso_file}",
    "${var.iso_path_external}/${var.iso_file}"
  ]
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
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--firmware", "efi"],
    ["modifyvm", "{{ .Name }}", "--rtcuseutc", "off"]
  ]
  virtualbox_version_file = "/tmp/.vbox_version"
  vm_name                 = var.vm_name
  vrdp_bind_address       = var.vnc_vrdp_bind_address
  vrdp_port_max           = var.vnc_vrdp_port_max
  vrdp_port_min           = var.vnc_vrdp_port_min
}

build {
  description = "Can't use variables here yet!"

  sources = ["source.qemu.qemu", "source.virtualbox-iso.vbox"]

  provisioner "shell" {
    binary            = false
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect = true
    inline = [
      "echo 'FS0:\\EFI\\ubuntu\\grubx64.efi' > /boot/efi/startup.nsh"
    ]
    inline_shebang      = "/bin/sh -e"
    only                = ["qemu", "vbox"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    binary            = false
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect = true
    inline = [
      "apt-get update",
      "apt-get --yes dist-upgrade",
      "apt-get clean"
    ]
    inline_shebang      = "/bin/sh -e"
    only                = ["qemu", "vbox"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  provisioner "shell" {
    binary            = false
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S '{{ .Path }}'"
    expect_disconnect = true
    inline = [
      "dd if=/dev/zero of=/ZEROFILL bs=16M || true",
      "rm /ZEROFILL",
      "sync"
    ]
    inline_shebang      = "/bin/sh -e"
    only                = ["qemu", "vbox"]
    skip_clean          = false
    start_retry_timeout = var.start_retry_timeout
  }

  post-processor "vagrant" {
    compression_level    = 6
    keep_input_artifact  = true
    only                 = ["qemu", "vbox"]
    output               = "${local.output_directory}/${var.vm_name}-${var.version}-${build.name}.box"
    vagrantfile_template = "${path.root}/${var.vagrantfile_template}"
  }

  post-processor "compress" {
    compression_level   = 6
    format              = ".gz"
    keep_input_artifact = true
    only                = ["qemu"]
    output              = "${local.output_directory}/${var.vm_name}.raw.gz"
  }
}
