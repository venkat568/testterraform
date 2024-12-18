resource "aws_instance" "server" {
    count = 1
    ami = var.ami
    instance_type = var.instance_type
    key_name  = var.key_name
    vpc_security_group_ids = [aws_security_group.testsg.id]
    associate_public_ip_address = true
    subnet_id = aws_subnet.subnets[0].id
    private_ip = element(var.private_ip,count.index)
    user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install java-17-amazon-corretto-headless -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade -y
    sudo yum install jenkins -y
    sudo systemctl daemon-reload
    sudo systemctl start jenkins

    EOF
    tags = {
        Name = "${var.vpc_name}-server${count.index+1}"
    }
}