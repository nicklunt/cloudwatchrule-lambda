{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeTags",
                "ec2:DescribeSnapshotAttribute",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeVolumes",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeSnapshots",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeInstanceStatus",
                "ec2:DeleteSnapshot",
                "ec2:DeleteTags",
                "ec2:CreateTags",
                "ec2:CreateSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}