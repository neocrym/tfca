output "ca" {
  value = {
    private_key_pem      = tls_private_key.ca.private_key_pem
    private_key_filename = var.write_keys ? local.ca_private_key_filename : null
    cert_pem             = tls_self_signed_cert.ca.cert_pem
    cert_filename        = var.write_certs ? local.ca_cert_filename : null
  }
}

output "leaf" {
  value = module.leaf_certs
}
