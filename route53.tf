resource "aws_route53_record" "app_dns" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = var.dns_type

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}
