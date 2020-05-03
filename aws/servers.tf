provider "tls" {
  version = "~> 2.1"
}
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}


resource "aws_key_pair" "generated_key" {
  key_name = var.ami_key_pair_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

data "aws_ami" "ami" {
  most_recent = true
  owners = [
    "099720109477"]
  # Canonical
  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }
}



resource "aws_instance" "grocy-ec2-instance" {
  ami = data.aws_ami.ami.image_id
  instance_type = "t2.micro"
  key_name = var.ami_key_pair_name
  security_groups = [
    aws_security_group.ingress-all-grocy.id]

  subnet_id = aws_subnet.subnet-grocy.id
  associate_public_ip_address = true

  tags = {
    Name = "grocy server"
  }

  // Create the dbx dir if does not exist
  provisioner "local-exec" {
    command = "mkdir -p ~/.config/dbxcli"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p dns",
      "mkdir -p docker-compose-letsencrypt-nginx-proxy-companion",
    ]
  }

  // put in the correct domain name in .env
  provisioner "file" {
    destination = "~/.env"
    content = templatefile("${path.cwd}/../docker/.env.tpl", {
      grocy_domain_name =  "${var.grocy_duckdns_domain}.duckdns.org"
      bbuddy_domain_name =  "${var.grocy_bbuddy_duckdns_domain}.duckdns.org"
    })
  }

  // put in the correct domain name in dns script
  provisioner "file" {
    destination = "~/dns/register-duckdns.sh"
    content = templatefile("${path.cwd}/../dns/register-duckdns.sh.tpl", {
      grocy_domain_name =  var.grocy_duckdns_domain
      bbuddy_domain_name =  var.grocy_bbuddy_duckdns_domain
      duckdns_token = var.duckdns_token
    })
  }

  // put in the correct domain name in dns script to wait for grocy server domain
  provisioner "file" {
    destination = "~/dns/wait-for-dns.sh"
    content = templatefile("${path.cwd}/../dns/wait-for-dns.sh.tpl", {
      duckdns_domain =  var.grocy_duckdns_domain
      duckdns_token = var.duckdns_token
    })
  }

  // put in the correct domain name in dns script to wait for bbuddy server domain
  provisioner "file" {
    destination = "~/dns/wait-for-dns2.sh"
    content = templatefile("${path.cwd}/../dns/wait-for-dns2.sh.tpl", {
      duckdns_domain =  var.grocy_bbuddy_duckdns_domain
      duckdns_token = var.duckdns_token
    })
  }

  // Copy over dns scripts
  provisioner "file" {
    source = "${path.cwd}/../dns/"
    destination = "~/dns"
  }

  // Copy over docker scripts
  provisioner "file" {
    source = "${path.cwd}/../docker/"
    destination = "~/"
  }

  // Copy over letsencrypt-nginx-proxy-companion files
  provisioner "file" {
    source = "${path.cwd}/../docker-compose-letsencrypt-nginx-proxy-companion/"
    destination = "~/docker-compose-letsencrypt-nginx-proxy-companion"
  }

  // Copy over backup scripts
  provisioner "file" {
    source = "${path.cwd}/../backup/"
    destination = "~/"
  }

  // Copy over Dropbox configs
  provisioner "remote-exec" {
    inline = [ "mkdir -p .config",
    ]
  }

  provisioner "file" {
    source = "~/.config/dbxcli"
    destination = "~/.config"
  }


  connection {
    user = "ubuntu"
    type = "ssh"
    host = aws_instance.grocy-ec2-instance.public_ip
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x -R ./*.sh",
      "sudo ./install-docker.sh",
      "sudo ./install-docker-compose.sh",
      "cd dns && sudo chmod a+x -R ./*.sh && sudo ./schedule-duckdns.sh",
      "cd ../docker-compose-letsencrypt-nginx-proxy-companion && sudo chmod a+x -R ./*.sh && sudo ./start.sh",
      "cd .. && sudo docker-compose up -d"
      //"sudo ./schedule-backup.sh",
    ]
  }

}


