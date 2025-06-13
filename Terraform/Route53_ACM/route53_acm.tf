resource "aws_route53_zone" "dns" {
    name = "simha.in.net"
}

resource "aws_acm_certificate" "ssl" {
    domain_name = "simha.in.net"
    validation_method = "DNS"
    depends_on = [ aws_route53_zone.dns]
}

resource "aws_acm_certificate_validation" "ssl_valid" {
  certificate_arn = aws_acm_certificate.ssl.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
  depends_on = [ aws_route53_zone.dns ]
  timeouts {
    create = "10m"
  }
}

resource "aws_route53_record" "certificate" {
  for_each = {
    for dvo in aws_acm_certificate.ssl.domain_validation_options : 
    dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type =  each.value.type
  zone_id = aws_route53_zone.dns.zone_id
  depends_on = [ aws_route53_zone.dns ]
}