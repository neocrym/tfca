output "private_key_pem" {
  value = tls_private_key.leaf.private_key_pem
}

output "cert_pem" {
  value = tls_locally_signed_cert.leaf.cert_pem
}