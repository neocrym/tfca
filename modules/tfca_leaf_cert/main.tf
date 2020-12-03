locals {
  private_key_filename = "${var.output_dir}/${var.leaf_name}.key"
  cert_filename = "${var.output_dir}/${var.leaf_name}.crt"
}

resource "tls_private_key" "leaf" {
  algorithm   = var.key_algorithm
  rsa_bits    = var.rsa_bits
  ecdsa_curve = var.ecdsa_curve
}

resource "tls_cert_request" "leaf" {
  key_algorithm   = var.key_algorithm
  private_key_pem = tls_private_key.leaf.private_key_pem
  subject {
    common_name         = var.common_name
    organization        = var.organization
    organizational_unit = var.organizational_unit
    street_address      = var.street_address
    locality            = var.locality
    province            = var.province
    country             = var.country
    postal_code         = var.postal_code
    serial_number       = var.serial_number
  }
}

resource "tls_locally_signed_cert" "leaf" {
  cert_request_pem      = tls_cert_request.leaf.cert_request_pem
  ca_key_algorithm      = var.key_algorithm
  ca_private_key_pem    = var.ca_private_key_pem
  ca_cert_pem           = var.ca_cert_pem
  validity_period_hours = var.validity_period_hours
  early_renewal_hours   = var.early_renewal_hours
  allowed_uses          = var.allowed_uses
  set_subject_key_id    = true
}

resource "local_file" "leaf__key" {
  count                = var.write_keys ? 1 : 0
  sensitive_content    = tls_private_key.leaf.private_key_pem
  filename             = "${var.output_dir}/${var.leaf_name}.key"
  file_permission      = "0600"
  directory_permission = "0755"
}

resource "local_file" "server__crt" {
  count                = var.write_certs ? 1 : 0
  sensitive_content    = tls_locally_signed_cert.leaf.cert_pem
  filename             = "${var.output_dir}/${var.leaf_name}.crt"
  file_permission      = "0644"
  directory_permission = "0755"
}
