variable "leaf_name" {
  type = string
  validation {
    condition     = var.leaf_name != "ca"
    error_message = "You cannot name a leaf certificate as 'ca' otherwise you will overwrite your Certificate Authority(CA) private key."
  }
}

variable "rsa_bits" {
  type    = number
  default = null
}

variable "ecdsa_curve" {
  type    = string
  default = null
}

variable "ca_private_key_pem" {
  type = string
}

variable "ca_cert_pem" {
  type = string
}

variable "output_dir" {
  type = string
}

variable "write_keys" {
  type    = bool
  default = true
}

variable "write_certs" {
  type    = bool
  default = true
}

variable "key_algorithm" {
  type = string
}

variable "common_name" {
  type    = string
  default = null
}

variable "organization" {
  type    = string
  default = null
}

variable "organizational_unit" {
  type    = string
  default = null
}

variable "street_address" {
  type    = list(string)
  default = null
}

variable "locality" {
  type    = string
  default = null
}

variable "province" {
  type    = string
  default = null
}

variable "country" {
  type    = string
  default = null
}

variable "postal_code" {
  type    = string
  default = null
}

variable "serial_number" {
  type    = string
  default = null
}

variable "validity_period_hours" {
  type = number
  # 1 month
  default = 24 * 30
}

variable "early_renewal_hours" {
  type = number
  # 1 day
  default = 24
}

variable "allowed_uses" {
  type = list(string)
}

variable "dns_names" {
  type    = list(string)
  default = []
}

variable "ip_addresses" {
  type    = list(string)
  default = []
}

variable "uris" {
  type    = list(string)
  default = []
}