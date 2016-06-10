$ErrorActionPreference = 'Stop'

Function Invoke-AWS {
  [CmdletBinding()]
  Param(
  [String[]] $command = "",
  [String] $volume = "",
  [String] $image = "cgswong/aws:aws"
  )

  if ($volume -ne "") {
    $volume = "-v", "$(Convert-Path($volume)):/app/stack.json"
  } else {
    $volume = ""
  }

  Invoke-Expression @"
    docker run -it -e AWS_ACCESS_KEY_ID="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().AccessKey)" -e AWS_SECRET_ACCESS_KEY="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().SecretKey)" -e AWS_REGION='us-east-1' $volume $image $command
"@
}

Function Convert-Path {
  Param([String] $Path)
  $Path.Replace("C:\", "/c/").Replace('\', '/')
}

Function Create-Stack {
  Invoke-AWS -volume (get-childitem "stack.json").fullname `
    -command "cloudformation", "create-stack", "--region", "us-east-1", "--stack-name", "alexa-bom", "--template-body", "file:///app/stack.json", "--capabilities", "CAPABILITY_IAM"
}

Function Get-AccountId {
  Invoke-AWS -command "sts", "get-caller-identity", "--query", "Account", "--output", "text"
}

Function Get-LambdaRoleName {
  "role/lambda"
}

Function Get-LambdaRole {
  "arn:aws:iam::$(Get-AccountId):$(Get-LambdaRoleName)"
}

Function Update-Project {
  $project = (Get-Content -Path "app/project.json" | ConvertFrom-Json)
  $project.role = Get-LambdaRole
  ConvertTo-Json $project | Set-Content -Path "app/project.json"
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

#docker pull cgswong/aws:aws
main