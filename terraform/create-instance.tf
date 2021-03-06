terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.65.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-backend-10"
    region     = "ru-central1-a"
    key        = "terraform.tfstate"
    access_key = "HNvjeaDeGCKv6pwIp6xa"
    secret_key = "8ruZhJWTa1kTF5D64cP37IYEVz4mZ5dZdW7sg2vo"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.yandex-token
  cloud_id  = var.yandex-cloud-id
  folder_id = var.yandex-folder-id
  zone      = var.yandex-zone
}

resource "yandex_vpc_network" "network" {
  name = "network1"

  labels = {
    environment = "network"
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name = "subnet1"
  zone = var.yandex-zone
  network_id = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.0.0/24"]

  labels = {
    environment = "subnet"
  }
}

resource "yandex_compute_instance" "build" {
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat = true
  }
  resources {
    cores = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      name = "disk1"
      size = 30
      type = "network-hdd"
      image_id = "fd814k6nlgobk70klpjn"
    }
  }

  metadata = {
    ssh-keys = "extor:${file("/root/.ssh/id_rsa.pub")}"
  }

  provisioner "remote-exec" {
    inline = ["echo Connected!"]

    connection {
      host = self.network_interface[0].nat_ip_address
      type = "ssh"
      user = "ubuntu"
      private_key = file("/root/.ssh/id_rsa")
    }
  }
}

resource "yandex_compute_instance" "prod" {
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat = true
  }
  resources {
    cores = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      name = "disk3"
      size = 30
      type = "network-hdd"
      image_id = "fd814k6nlgobk70klpjn"
    }
  }

  metadata = {
    ssh-keys = "extor:${file("/root/.ssh/id_rsa.pub")}"
  }

  provisioner "remote-exec" {
    inline = ["echo Connected!"]

    connection {
      host = self.network_interface[0].nat_ip_address
      type = "ssh"
      user = "ubuntu"
      private_key = file("/root/.ssh/id_rsa")
    }
  }
}