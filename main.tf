provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_iam_role" "role" {
  name = "PushCloudWatchLogsRole"
  assume_role_policy = "${file("assume-role-policy.json")}"
}

resource "aws_iam_policy" "policy" {
  name = "PushCloudWatchLogsPolicy"
  policy = "${file("policy.json")}"
}

resource "aws_iam_policy_attachment" "profile" {
  name = "cloudwatch-lambda-attachment"
  roles = ["${aws_iam_role.role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_lambda_function" "demo" {
  filename = "function/deployment.zip"
  function_name = "HelloWorld"
  role = "${aws_iam_role.role.arn}"
  handler = "main"
  runtime = "go1.x"
}
