output "host_ssh_key" {
  value = tls_private_key.ssh_key.private_key_pem
}

output "grocy_host" {
  value =aws_eip.ip-grocy.public_ip
}