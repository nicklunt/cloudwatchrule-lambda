# Terraform to create a lambda function to run a python script which will backup ebs volumes to snapshots.data

# NOTE: Create the IAM policy/role from template_file **

# role policy
resource "aws_iam_role_policy" "nl-lecp_backup_volumes_policy" {
  name = "nl-lecp_backup_volumes_policy"
  policy = file("iam/nl-backup_lambda_policy.json")
  role = aws_iam_role.nl-lecp_backup_volumes_role.id
}

# role
resource "aws_iam_role" "nl-lecp_backup_volumes_role" {
  name = "nl-lecp_backup_volumes_role"
  assume_role_policy = file("./iam/nl-backup_lambda_assume_role.json")
}

# The python module
data "archive_file" "nl-lecp_backup_volumes" {
  type        = "zip"
  source_file = "scripts/nl-lecp_backup_volumes.py"
  output_path = "scripts/nl-lecp_backup_volumes.zip"
}

resource "aws_lambda_function" "nl-lecp_backups_lambda" {
  filename = data.archive_file.nl-lecp_backup_volumes.output_path
  function_name = "nl-lecp_backup_volumes"
  runtime = "python3.6"
  handler = "nl-lecp_backup_volumes.lambda_handler"
  role = aws_iam_role.nl-lecp_backup_volumes_role.arn
}

resource "aws_lambda_permission" "nl-allow-cw-lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nl-lecp_backups_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.nl-schedule-snapshots-event-rule.arn
}
