output "asg_name" {
    value = aws_autoscaling_group.asg.name
}

output "asg_arn" {
    value = aws_autoscaling_group.asg.arn
}

output "launch_template_name" {
    value = aws_launch_template.lt.name
}

output "launch_template_id" {
    value = aws_launch_template.lt.id
}

output "launch_template_version" {
    value = aws_launch_template.lt.latest_version
}

output "autoscaling_group_desired_capacity" {
    value = aws_autoscaling_group.asg.desired_capacity
}

output "autoscaling_group_min_size" {
    value = aws_autoscaling_group.asg.min_size
}

output "autoscaling_group_max_size" {
    value = aws_autoscaling_group.asg.max_size
}

output "autoscaling_policy_name" {
    value = aws_autoscaling_policy.cpu_policy.name
}

output "autoscaling_policy_arn" {
    value = aws_autoscaling_policy.cpu_policy.arn
}
