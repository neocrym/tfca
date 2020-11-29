output "ca" {
  value = {
    private_key_pem = tls_private_key.ca.private_key_pem
    cert_pem        = tls_self_signed_cert.ca.cert_pem
  }
}

output "leaf" {
  value = module.leaf_certs
}
