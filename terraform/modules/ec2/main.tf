locals {
  combined_user_data = <<-EOF
    #!/bin/bash
    set -e
    ${file("${path.module}/ansible_install.sh")}
    ${file("${path.module}/install_ansiable_amazon_linux.sh")}
    ${file("${path.module}/install-maven-kubectl.sh")}
  EOF
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = local.combined_user_data
  tags = {
    Name = var.instance_name
  }
}

