locals {
  # Allowed uses found from https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert
  allowed_uses = [
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
  ca_private_key_filename = "${var.output_dir}/ca.key"
  ca_cert_filename = "${var.output_dir}/ca.crt"
}
## CERTIFICATE AUTHORITY

resource "tls_private_key" "ca" {
  algorithm   = var.key_algorithm
  rsa_bits    = var.rsa_bits
  ecdsa_curve = var.ecdsa_curve
}

resource "tls_self_signed_cert" "ca" {
  is_ca_certificate = true
  key_algorithm     = var.key_algorithm
  private_key_pem   = tls_private_key.ca.private_key_pem
  subject {
    common_name         = var.ca_common_name
    organization        = var.ca_organization
    organizational_unit = var.ca_organizational_unit
    street_address      = var.ca_street_address
    locality            = var.ca_locality
    province            = var.ca_province
    country             = var.ca_country
    postal_code         = var.ca_postal_code
    serial_number       = var.ca_serial_number
  }
  set_subject_key_id    = true
  validity_period_hours = var.ca_validity_period_hours
  early_renewal_hours   = var.ca_early_renewal_hours
  allowed_uses          = var.ca_allowed_uses
}

resource "local_file" "ca__key" {
  count                = var.write_keys ? 1 : 0
  sensitive_content    = tls_private_key.ca.private_key_pem
  filename             = local.ca_private_key_filename
  file_permission      = "0600"
  directory_permission = "0755"
}

resource "local_file" "ca__crt" {
  count                = var.write_certs ? 1 : 0
  sensitive_content    = tls_self_signed_cert.ca.cert_pem
  filename             = local.ca_cert_filename
  file_permission      = "0644"
  directory_permission = "0755"
}

module "leaf_certs" {
  source                = "./modules/tfca_leaf_cert"
  for_each              = var.leaf_certs
  leaf_name             = each.key
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  output_dir            = var.output_dir
  write_keys            = var.write_keys
  write_certs           = var.write_certs
  key_algorithm         = var.key_algorithm
  common_name           = try(each.value.common_name, null)
  organization          = try(each.value.organization, null)
  organizational_unit   = try(each.value.organizational_unit, null)
  street_address        = try(each.value.street_address, null)
  locality              = try(each.value.locality, null)
  province              = try(each.value.province, null)
  country               = try(each.value.country, null)
  postal_code           = try(each.value.postal_code, null)
  serial_number         = try(each.value.serial_number, null)
  validity_period_hours = try(each.value.validity_period_hours, null)
  early_renewal_hours   = try(each.value.early_renewal_hours, null)
  allowed_uses          = try(each.value.allowed_uses, local.allowed_uses)
}