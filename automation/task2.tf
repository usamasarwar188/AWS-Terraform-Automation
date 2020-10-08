# provider "aws" {
#   version    = "~> 2.0"
#   access_key = "ASIASAJMUI6BDKO5CHHQ"
#   secret_key = "4IDNX6JyCg6BQkh/QS9zgne1Y/R7Zp0Pl2sP8pqv"
#   token      = "FwoGZXIvYXdzEIn//////////wEaDCh3cFc4VBImCw13PSLAAXJREl9mKfLeKfffkEhUVVGxt/pTiln69lN7Cl8i4pugrq9/0777DnHG3Q61jHheD/fWdnF6HF96LhVDzGW3LiAySI17k4bRaDo9TrDBoTFie3X8HV7I+LAbm9Mhxz7LfWhk3bcq0P4RQyMo+F28rQ411T6f4T389suUlcrP5gB2cq6Dxnfu70HG2dj4cL6O7TrFl8BldA9Xb/GazGhiai1XHMiuiuOfOfjoIxvG0NtEu2mzFu6Kq+Q6a63tcOfj6Ci5zdz0BTItXCwVZ4DVKOaEwk6pesWY5gp9an9zdPYK26s3STWoooGU6Je9T9UJhtrHGMcY"
#   region     = "us-east-1"
# }



resource "aws_launch_configuration" "tf_lch_conf" {
  image_id      = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  key_name      = "project_key_pair"
  user_data     = filebase64("${path.module}/userdata.sh")

}

resource "aws_autoscaling_group" "tf_asg" {
  name                 = "tf-asg"
  availability_zones   = ["us-east-1c", "us-east-1d"]
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.tf_lch_conf.name
  target_group_arns    = [aws_lb_target_group.tf_tgrp.arn]
}


resource "aws_lb_target_group" "tf_tgrp" {
  name     = "tf-tgrp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf_vpc.id
}

resource "aws_lb" "tf_lb" {
  name               = "tf-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_secgp.id]
  subnets            = [aws_subnet.tf_public_subnet_1.id, aws_subnet.tf_public_subnet_2.id]

  enable_deletion_protection = true

  # access_logs {
  #   bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # tags = {
  #   Environment = "production"
  # }
}
