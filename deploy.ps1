$ErrorActionPreference = 'Stop'

Function Invoke-AWS {
  # AWS CLI command to run
  [String] $command
  [String] $stack
  [String] $image = "cgswong/aws:aws"

  if ($stack -ne $null) {
    $stack_cmd = " -v ${$stack}:/app/stack.json"
  } else {
    $stack_cmd = ""
  }

  Invoke-Expression @"
    docker run -it `
      -e AWS_ACCESS_KEY_ID="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().AccessKey)" `
      -e AWS_SECRET_ACCESS_KEY="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().SecretKey)" `
      -e AWS_REGION='us-east-1' `
      $stack_cmd `
      $image $command
"@
}

Function Create-Stack {
  Invoke-AWS -stack (get-childitem "stack.json").fullname `
  -command "cloudformation create-stack --stack-name alexa-bom --template-body file:///app/stack.json"
}

Function Get-AccountId {
  Invoke-AWS -command "sts get-caller-identity --query 'Account' --output text"
}

Function Get-LambdaRoleName {
  "role/lambda"
}

Function Get-LambdaRole {
  "arn:aws:iam::$(Get-AccountId):$(Get-LambdaRoleName)"
}

Function Update-Project {
  $project = Get-Content -Path "app/project.json" | ConvertFrom-Json
  $project['role'] = Get-LambdaRole
  Convert-ToJson $project | Set-Content -Path "app/project.json"
}

Function Deploy-Lambda {
  docker build -t bom-deploy .
  Invoke-AWS -image "bom-deploy" -command "deploy"
}

Function main {
  Create-Stack
  Update-Project
  Deploy-Lambda
}

docker pull cgswong/aws:aws
main