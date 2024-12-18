resource "aws_security_group" "testsg" {
    vpc_id = aws_vpc.test.id
    description = "allow rules" 
    name = "network-sg"
    tags = {
      name = "${var.vpc_name}-testsg"
    }
    ingress  {
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress  {
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
