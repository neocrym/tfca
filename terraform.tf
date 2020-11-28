terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
  }
}