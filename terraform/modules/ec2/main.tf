locals {
  ansible_install_script       = file("${path.module}/ansible_install.sh")
  amazon_linux_script          = file("${path.module}/install_ansible_amazon_linux.sh")
  maven_kubectl_install_script = file("${path.module}/install-maven-kubectl.sh")

  combined_user_data = <<-EOF
    #!/bin/bash
    set -e

    ${local.ansible_install_script}

    ${local.amazon_linux_script}

    ${local.maven_kubectl_install_script}
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

