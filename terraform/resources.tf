resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network-1.id
}

resource "yandex_compute_instance" "vm-1" {
  count       = 2
  name        = "vm${count.index}"
  platform_id = "standard-v1"

  boot_disk {
    initialize_params {
      image_id = "fd8jnu7r8j10tfmgs46b"
      size     = "5"
    }
  }

  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    #nat_ip_address = yandex_vpc_address.test-ip.external_ipv4_address.0.address
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

resource "yandex_lb_target_group" "test" {
  name = "test"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address = yandex_compute_instance.vm-1[0].network_interface.0.ip_address
  }
  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address = yandex_compute_instance.vm-1[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "lb-1"

  listener {
    name = "my-lb1"
    port = 80 
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.test.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
