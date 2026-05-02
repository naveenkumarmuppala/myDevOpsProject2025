output "instance_profile_name" {
    value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "instance_profile_arn" {
    value = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "role_name" {
    value = aws_iam_role.ec2_role.name
}

output "role_arn" {
    value = aws_iam_role.ec2_role.arn
}
