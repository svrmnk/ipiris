terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yandex_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = "ru-central1-a"
}

# Создание сети
resource "yandex_vpc_network" "bookstore_network" {
  name = "bookstore-network"
}

# Создание подсети
resource "yandex_vpc_subnet" "bookstore_subnet" {
  name           = "bookstore-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.bookstore_network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

# Создание виртуальной машины
resource "yandex_compute_instance" "bookstore_vm" {
  name        = "jmix-bookstore-vm"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 20
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bookstore_subnet.id
    nat       = true
  }

  metadata = {
    user-data = "${file("${path.module}/cloud_config.yaml")}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ipiris"
      private_key = "${file("~/.ssh/id_ipris")}"
      host        = self.network_interface.0.nat_ip_address
    }

    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io",
      "sudo systemctl enable --now docker",
      "sudo docker run -d -p 8080:8080 jmix/jmix-bookstore"
    ]
  }
}
