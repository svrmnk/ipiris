variable "yandex_cloud_id" {
  description = "Cloud ID в Yandex Cloud"
  type        = string
}

variable "yandex_token" {
    description = "Cloud Token в Yandex Cloud"
    type = string
}

variable "yandex_folder_id" {
  description = "Folder ID в Yandex Cloud"
  type        = string
}

variable "image_id" {
  description = "ID образа Ubuntu 24.04"
  default     = "fd86idv7gmqapoeiq5ld"
}

variable "zone" {
  description = "Зона Yandex Cloud"
  default     = "ru-central1-a"
}
