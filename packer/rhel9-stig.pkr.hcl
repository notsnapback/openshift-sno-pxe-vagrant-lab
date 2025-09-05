packer {
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.0.0"
    }
    vagrant = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "virtualbox-iso" "rhel96" {
  vm_name           = "rhel9.6-stig"
  guest_os_type     = "RedHat_64"
  headless          = false
  iso_url           = "<ISO_URL>"       # e.g. file:///C:/path/to/rhel-9.6.iso
  iso_checksum      = "<ISO_SHA256>"    # e.g. sha256:0123abcd...
  boot_wait         = "5s"
  boot_command = [
    "<esc><wait>",
    "vmlinuz initrd=initrd.img inst.stage2=cdrom inst.text ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ssg-rhel9-stig-ks.cfg<enter>"
  ]
  http_directory    = "<HTTP_DIRECTORY>"  # e.g. C:/Users/you/labs/pxe_lab/packer/http
  communicator      = "ssh"
  ssh_username      = "admin"
  ssh_password      = "admin123"
  ssh_timeout       = "30m"
  shutdown_command  = "sudo shutdown -P now"
  memory            = 2048
  cpus              = 2
  disk_size         = 120000  # ~120 GB
  ssh_host = "127.0.0.1"
  ssh_port                = 22
  ssh_host_port_min       = 2222
  ssh_host_port_max       = 2222
}

build {
  sources = ["source.virtualbox-iso.rhel96"]
  post-processor "vagrant" {
    output = "rhel9-stig-virtualbox.box"
  }
}
