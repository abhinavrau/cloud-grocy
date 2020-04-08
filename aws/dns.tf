locals {
  register_dns = length(var.toplevel_domain) > 0 ? 1 : 0
  grocy_domain = "${var.project_name}.${var.toplevel_domain}"
}

data "aws_route53_zone" "selected" {
  count = local.register_dns ? 1 : 0

  name = "${var.toplevel_domain}."
}

resource "aws_route53_record" "ns" {

  count = local.register_dns ? 1 : 0

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = local.grocy_domain
  type    = "NS"
  ttl     = "30"

  records = [
    data.aws_route53_zone.grocy_zone.name_servers,
  ]
}

data "aws_route53_zone" "grocy_zone" {
  count = local.register_dns ? 1 : 0
  name = "${local.grocy_domain}."
}

resource "aws_route53_record" "dns" {

  count = local.register_dns ? 1 : 0

  zone_id = data.aws_route53_zone.grocy_zone.zone_id
  name = local.grocy_domain
  type = "A"
  ttl = "30"
  records = [
    aws_eip.ip-grocy.public_ip]
}