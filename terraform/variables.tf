variable "token"{
    type = string
    description = "The ID of YaCloud"
    sensitive = true
}

variable "secret_key" {
  type        = string
  description = "YaCloud secret-key"
}

variable "key_identify" {
  type        = string
  description = "YaCloud secret-key identity"
}
