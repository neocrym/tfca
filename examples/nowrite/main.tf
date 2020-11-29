module "nowrite" {
  output_dir     = "./keys"
  source         = "../.."
  ca_common_name = "example.com"
  write_certs    = false
  write_keys     = false
  leaf_certs = {
    server1 = {
      common_name           = "server1.example.com"
      validity_period_hours = 24 * 30
      early_renewal_hours   = 24
    }
    client1 = {
      common_name           = "client1.example.com"
      validity_period_hours = 24 * 30
      early_renewal_hours   = 24
    }
  }
}