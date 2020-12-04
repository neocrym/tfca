variable "output_dir" {
  type    = string
  default = "./"
}

variable "write_keys" {
  type    = bool
  default = true
}

variable "write_certs" {
  type    = bool
  default = true
}

variable "rsa_bits" {
  type    = number
  default = null
}

variable "ecdsa_curve" {
  type    = string
  default = null
}

variable "key_algorithm" {
  type    = string
  default = "RSA"
}

variable "ca_common_name" {
  type    = string
  default = null
}

variable "ca_organization" {
  type    = string
  default = null
}

variable "ca_organizational_unit" {
  type    = string
  default = null
}

variable "ca_street_address" {
  type    = list(string)
  default = null
}

variable "ca_locality" {
  type    = string
  default = null
}

variable "ca_province" {
  type    = string
  default = null
}

variable "ca_country" {
  type    = string
  default = null
}

variable "ca_postal_code" {
  type    = string
  default = null
}

variable "ca_serial_number" {
  type    = string
  default = null
}

variable "ca_validity_period_hours" {
  type = number
  # 10 years
  default = 24 * 365.25 * 10
}

variable "ca_early_renewal_hours" {
  type = number
  # 1 year
  default = 24 * 365
}

variable "ca_allowed_uses" {
  type = list(string)
  # Allowed uses found from https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert
  default = [
    "digital_signature",
    "content_commitment",
    "key_encipherment",
    "data_encipherment",
    "key_agreement",
    "cert_signing",
    "crl_signing",
    "encipher_only",
    "decipher_only",
    "any_extended",
    "server_auth",
    "client_auth",
    "code_signing",
    "email_protection",
    "ipsec_end_system",
    "ipsec_tunnel",
    "ipsec_user",
    "timestamping",
    "ocsp_signing",
    "microsoft_server_gated_crypto",
    "netscape_server_gated_crypto",
  ]
}

variable "ca_dns_names" {
  type    = list(string)
  default = []
}

variable "ca_ip_addresses" {
  type    = list(string)
  default = []
}

variable "ca_uris" {
  type    = list(string)
  default = []
}

variable "leaf_certs" {
  type    = any
  default = {}
}