$ErrorActionPreference = 'Stop'

docker pull cgswong/aws:aws
docker run -it `
  -e AWS_ACCESS_KEY_ID="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().AccessKey)" `
  -e AWS_SECRET_ACCESS_KEY="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().SecretKey)" `
  -e AWS_REGION='us-east-1' `
  -v /c/Users//stack.json:/app/stack.json `
  cgswong/aws:aws cloudformation create-stack --stack-name alexa-bom --template-body file:///app/stack.json

docker build -t bom-deploy .
docker run -it `
  -e AWS_ACCESS_KEY_ID="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().AccessKey)" `
  -e AWS_SECRET_ACCESS_KEY="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().SecretKey)" `
  -e AWS_REGION='us-east-1' `
  bom-deploy