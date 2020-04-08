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
    Name = var.project_name
  }


  provisioner "file" {
    source = "${path.cwd}/../letsencrypt/"
    destination = "~/"
  }

  provisioner "file" {
    source = "${path.cwd}/../docker/"
    destination = "~/"
  }

  // Backup

  provisioner "remote-exec" {
    inline = [ "mkdir -p .config",
    ]
  }

  provisioner "file" {
    source = "~/.config/dbxcli"
    destination = "~/.config"
  }

  provisioner "file" {
    source = "${path.cwd}/../backup/"
    destination = "~/"
  }


  connection {
    user = "ubuntu"
    type = "ssh"
    host = aws_instance.grocy-ec2-instance.public_ip
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x ./*.sh",
      "sudo ./install-docker.sh",
      "sudo ./install-docker-compose.sh",
      "sudo ./install-docker-grocy.sh",
      "sudo ./schedule-backup.sh"
    ]
  }

}


