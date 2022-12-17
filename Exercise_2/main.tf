provider "aws"{
    shared_credentials_files = ["C:/Users/ravi_/.aws/credentials"]
    region = var.aws_region
}

resource "aws_iam_role" "lambda_iam" {
    name = "lambda_iam"
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
        ]
    }
    EOF
}


resource "aws_lambda_function" "greet_lambda" {
    filename = "greet_lambda.zip"
    function_name = "greet_lambda"
    role = aws_iam_role.lambda_iam.arn
    handler = "greet_lambda.lambda_handler"
    runtime = "python3.9"
    source_code_hash = filebase64sha256("greet_lambda.zip")
    environment {
      variables = {
          greeting = "Hello"
      }
    }
    depends_on = [
      aws_iam_role_policy_attachment.lambda_logs,
    ]
}

resource "aws_iam_policy" "lambda_logging" {
    name        = "lambda_logging"
    path        = "/"
    description = "IAM policy for logging from a lambda"
    policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource": "arn:aws:logs:*:*:*",
                "Effect": "Allow"
            }
        ]
    }
    )
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role = aws_iam_role.lambda_iam.name
    policy_arn = aws_iam_policy.lambda_logging.arn
}