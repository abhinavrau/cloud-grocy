// Get the existing top level record which needs to be registered with Route53
data "aws_route53_zone" "selected" {

  name = "${var.toplevel_domain}."
}


// Create the A record hosted zone the grocy domain name
resource "aws_route53_record" "dns" {

  zone_id = data.aws_route53_zone.selected.zone_id
  name = var.project_name
  type = "A"
  ttl = "30"
  records = [
    aws_eip.ip-grocy.public_ip]
}

