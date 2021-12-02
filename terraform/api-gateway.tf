# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api
resource "aws_apigatewayv2_api" "apigateway" {
  name          = var.project_name
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*/*"
}

resource "aws_apigatewayv2_integration" "apig_api_integ" {
  api_id                 = aws_apigatewayv2_api.apigateway.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.lambda.invoke_arn
  passthrough_behavior   = "WHEN_NO_MATCH"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "apig_route_api_get" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "GET /api/{path+}"
  target    = "integrations/${aws_apigatewayv2_integration.apig_api_integ.id}"
}

resource "aws_apigatewayv2_route" "apig_route_api_post" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "POST /api/{path+}"
  target    = "integrations/${aws_apigatewayv2_integration.apig_api_integ.id}"
}

resource "aws_apigatewayv2_route" "apig_route_root" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.apig_api_integ.id}"
}

resource "aws_cloudwatch_log_group" "http_log" {
  name = "/aws/apigateway/${var.project_name}-apigateway"
}

resource "aws_apigatewayv2_stage" "apig_stage" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  name        = "$default"
  auto_deploy = true
  default_route_settings {
    throttling_burst_limit = 10
    throttling_rate_limit  = 1
  }
  access_log_settings {
    destination_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/apigateway/prod_http"
    format          = "$context.identity.sourceIp [$context.requestTime] \"$context.httpMethod $context.path $context.protocol\" $context.status $context.responseLength $context.requestId"
  }
}