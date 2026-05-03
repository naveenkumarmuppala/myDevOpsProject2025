data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}