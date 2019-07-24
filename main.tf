# Ok, for testing the jenkins connection, starting out
# simple with only the top level, split statefiles will
# have to come later.
data "aws_availability_zones" "all" {}

terraform {
    backend "s3" {
        encrypt = true
        bucket = "illustrious-kingdom-terraform-state"
        region = "us-east-1"
        key = "test/terraform.tfstate"
    }
}

provider "aws" {
    region = "us-east-1"
}


resource "aws_launch_configuration" "example" {
    image_id = "ami-40d28157"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "instance" {
    name = "jtest-instance"

    ingress {
        from_port = "8080"
        to_port = "8080"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones = "${data.aws_availability_zones.all.names}"

    load_balancers = ["${aws_elb.example.name}"]
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}

resource "aws_elb" "example" {
    name = "jtest"
    availability_zones = "${data.aws_availability_zones.all.names}"
    security_groups = ["${aws_security_group.elb.id}"]

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = "8080"
        instance_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 60
        target = "HTTP:8080/"
    }
}

resource "aws_security_group" "elb" {
    name = "jtest-elb"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}