terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}


provider "yandex" {
  token     = var.token #секретные данные должны быть в сохранности!! Никогда не выкладывайте токен в публичный доступ.
  cloud_id  = "b1gmn2p4njpkb0d2nfok"
  folder_id = "b1gpmvq18drtrb8dtdim"
  zone      = "ru-central1-a"
}
