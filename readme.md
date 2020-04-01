AWS 

Terraform: 0.12.20

Creates a lambda function to create backup snapshots for EBS volumes.
Backup criteria is done by tags on the volume and the instance.

Creates a cloudwatch event rule to run the lambda function at the scheduled times.

