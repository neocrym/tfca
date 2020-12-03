output "private_key_pem" {
  value = tls_private_key.leaf.private_key_pem
}

output "private_key_filename" {
  value = var.write_keys ? local.private_key_filename : null
}

output "cert_pem" {
  value = tls_locally_signed_cert.leaf.cert_pem
}

output "cert_filename" {
  value = var.write_certs ? local.cert_filename : null
}