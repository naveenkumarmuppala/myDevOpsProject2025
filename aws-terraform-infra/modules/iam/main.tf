resource "aws_iam_role" "ec2_role" {
  name               = "${var.name}-ec2-role"
  description        = "IAM role for EC2 instances in ${var.name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = merge(var.tags, {
    Name = "${var.name}-ec2-role"
  })
}

#Attach SSM permissions to the role
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#instance profile for EC2 role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.name}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(var.tags, {
    Name = "${var.name}-ec2-instance-profile"
  })
}