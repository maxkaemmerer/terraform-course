terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "tls_public_key" "publickey" {
  private_key_pem = tls_private_key.privatekey.private_key_pem
}

resource "digitalocean_ssh_key" "sshkey" {
  name       = "sshkey"
  public_key = data.tls_public_key.publickey.public_key_openssh
}

resource local_file "local_public_ssh_key" {
  filename = "${path.module}/.ssh/terraform-do.pub"
  content = data.tls_public_key.publickey.public_key_openssh
  file_permission = 0600
}

resource local_file "local_private_ssh_key" {
  filename = "${path.module}/.ssh/terraform-do"
  content = tls_private_key.privatekey.private_key_openssh
  file_permission = 0600
}

resource local_file "ssh_bash" {
  filename = "${path.module}/.ssh/ssh.sh"
  content = "ssh root@${digitalocean_droplet.node0001[0].ipv4_address} -i ${path.module}/.ssh/terraform-do"
  file_permission = 0600
}

resource "digitalocean_volume" "volume0001" {
  region                  = "fra1"
  name                    = "volume0001"
  size                    = 1
  initial_filesystem_type = "ext4"
  description             = "an example volume"
}

resource "digitalocean_droplet" "node0001" {
  image    = "ubuntu-20-04-x64"
  name     = "node0001"
  region   = "fra1"
  size     = "s-1vcpu-1gb"
  count    = 1
  ssh_keys = [digitalocean_ssh_key.sshkey.id]
}

resource "digitalocean_volume_attachment" "volumeattachment0001" {
  droplet_id = digitalocean_droplet.node0001[0].id
  volume_id  = digitalocean_volume.volume0001.id
}

resource "digitalocean_project" "terraform_test_project" {
  name        = "terraform_test_project"
  description = "A project to test terraform infrastructure deployment."
  purpose     = "Testing"
  environment = "Development"
  resources   = [digitalocean_volume.volume0001.urn, digitalocean_droplet.node0001[0].urn]
}
