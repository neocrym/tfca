# TFCA - Terraform Certificate Authority

## Introduction

TFCA is a very simple Terraform module that can be used to create a self-signed root Certificate Authority (CA), which then signs an arbitrary number of leaf certificates. TFCA does not create an intermediate CA between the root CA and the leaves.

## Requirements

TFCA requires Terraform 0.13 or later.
## Alternatives

This is a tool primarily used for testing purposes. If you want to operate a serious CA, then you should look at [easy-rsa](https://github.com/OpenVPN/easy-rsa), [HashiCorp Vault](https://www.vaultproject.io/), [Cloudflare cfssl](https://github.com/cloudflare/cfssl), or [AWS Certificate Manager Private Certificate Authority](https://aws.amazon.com/certificate-manager/private-certificate-authority/).

## Examples

This Terraform code creates a self-signed CA certificate with the Common Name `example.com` and two leaf certificates named `server1` and `client`.

```terraform
module "mycerts" {
  source         = "github.com/neocrym/tfca?ref=v0.1.5"
  ca_common_name = "example.com"
  leaf_certs = {
    server1 = {
      common_name           = "server1.example.com"
      validity_period_hours = 24 * 30
      early_renewal_hours   = 24
      allowed_uses = [
        "digital_signature",
        "key_encipherment",
        "server_auth",
      ]
    }
    client1 = {
      common_name           = "client1.example.com"
      validity_period_hours = 24 * 30
      early_renewal_hours   = 24
      allowed_uses = [
        "digital_signature",
        "key_agreement",
      ]
    }
  }
}
```

## Variables

 - `output_dir` -- **Optional.** The directory to write the certificates and private keys to. Defaults to the module's current directory.
 - `write_keys` -- **Optional.** Whether to write the private keys to the filesystem. Set this to `false` if you only want to access the keys as a Terraform output.
 - `write_certs` -- **Optional.** Whether to write the certificates to the filesystem. Set this to `false` if you only want to access the certificates as a Terraform output.
 - `key_algorithm` -- **Optional.** This can be either `"RSA"` or `"ECDSA"`. Defaults to RSA.
 - `rsa_bits` -- **Optional.** This is the number of bits to use when `key_algorithm` is set to RSA.
 - `ecdsa_curve` -- **Optional.** This is the elliptic curve to use when the `key_algorithm` is set to ECDSA. The choices are `"P224"`, `"P256"`, `"P384"` or `"P521"`, with `"P224"` as the default.

 - `ca_validity_period_hours` -- **Optional.** The number of hours after issuing that the CA certificate will be valid for.
 - `ca_early_renewal_hours` -- **Optional.** The number of hours until the CA certificate is eliglble for early renewal.
 - `ca_allowed_uses` -- **Optional.** This is a list of the [IETF RFC 5280](https://tools.ietf.org/html/rfc5280) allowed uses for this certificate. The available values are [here](https://registry.terraform.io/providers/hashicorp/tls/3.0.0/docs/resources/self_signed_cert). TFCA defaults to allowing all of the listed allowed uses.

The CA certificate's identity is set with the following variables. They are all optional, but at least one of them must be filled. These variables stand in for the [RFC 5280 subject names](https://tools.ietf.org/html/rfc5280#section-4.1.2.6):
 - `ca_common_name`
 - `ca_organization`
 - `ca_organizational_unit`
 - `ca_street_address`
 - `ca_locality`
 - `ca_province`
 - `ca_postal_code`
 - `ca_serial_number`

Information about the leaf certificates are set by assigning a mapping to the `leaf_certs` variable. The mapping keys become the filenames for the certificates and private keys, and the mapping values must contain these keys:
 - `validity_period_hours` -- **Optional.** The number of hours after issuing that the CA certificate will be valid for.
 - `early_renewal_hours` -- **Optional.** The number of hours until the CA certificate is eliglble for early renewal.
 - `allowed_uses` -- **Optional.** This is a list of the [IETF RFC 5280](https://tools.ietf.org/html/rfc5280) allowed uses for this certificate. The available values are [here](https://registry.terraform.io/providers/hashicorp/tls/3.0.0/docs/resources/self_signed_cert). TFCA defaults to allowing all of the listed allowed uses.

and the RFC 5280 subject names:
 - `common_name`
 - `organization`
 - `organizational_unit`
 - `street_address`
 - `locality`
 - `province`
 - `postal_code`
 - `serial_number`

## Threat model

This Terraform module writes private keys to the filesystem. The machine you are using TFCA on should be secure enough to trust the filesystem. The private key data is also written to Terraform's state file. When Terraform state is saved to the local filesystem, the state file is often named `terraform.tfstate`. However, the state file may be encrypted-at-rest and behind access control if [remote state](https://www.terraform.io/docs/state/sensitive-data.html) is used. Terraform Enterprise and Terraform's open-source Amazon S3 backend both support encryption at rest.
