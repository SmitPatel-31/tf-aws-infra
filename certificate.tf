
data "aws_acm_certificate" "imported_cert" {
  domain      = var.domain_name
  most_recent = true
  statuses    = ["ISSUED"]
}
output "acm_certificate_arn" {
  value = data.aws_acm_certificate.imported_cert.arn
}
