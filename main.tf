module "dynamodb_integration" {
  source = "github.com/barneyparker/terraform-aws-api-generic"

  api_id             = var.api_id
  resource_id        = var.resource_id
  http_method        = var.http_method
  authorization      = var.authorization
  method_request_parameters = var.method_request_parameters
  integration_request_parameters = var.integration_request_parameters

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:eu-west-1:dynamodb:action/PutItem"
  credentials             = aws_iam_role.dynamodb_put.arn
  request_templates       = var.request_templates

  responses = var.responses
}

resource "aws_iam_role" "dynamodb_put" {
  name = "${var.name}-ddb-put"
  assume_role_policy = data.aws_iam_policy_document.apigw.json
}

data "aws_iam_policy_document" "apigw" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "dynamodb_put" {
  name = "DynamoDB-Put-Item"
  role = aws_iam_role.dynamodb_put.id
  policy = data.aws_iam_policy_document.dynamodb_put.json
}

data "aws_iam_policy_document" "dynamodb_put" {
  statement {
     actions = [
      "dynamodb:PutItem",
    ]

    resources = [
      "${var.table_arn}",
    ]
  }
}