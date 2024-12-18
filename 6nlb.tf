resource "aws_lb" "nlb" {
    name = "networkloadbalncer"
    load_balancer_type = "network"
    internal = false
    security_groups = [aws_security_group.testsg.id]
    subnets = [aws_subnet.subnets[0].id,aws_subnet.subnets[1].id]
    tags = {
        Name = "${var.vpc_name}-nlb"
    }
}

resource "aws_lb_target_group" "tg" {
    name = "nlb-tg"
    protocol = "TCP"
    port = 8080
    vpc_id = aws_vpc.test.id
    target_type = "instance"  
    health_check {
        protocol = "TCP"
        interval = 60
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
    tags = {
        Name = "${var.vpc_name}-nlb"
    }
}

resource "aws_lb_target_group_attachment" "attach" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.server[0].id
    port = 8080
  
}

resource "aws_lb_listener" "listen" {
    load_balancer_arn = aws_lb.nlb.arn
    protocol = "TCP"
    port = 80
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
      
    }
  
}