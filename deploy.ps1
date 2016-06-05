docker build -t bom .
docker run -it `
  -e AWS_ACCESS_KEY_ID="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().AccessKey)" `
  -e AWS_SECRET_ACCESS_KEY="$((Get-AWSCredentials -ProfileName alexa).GetCredentials().SecretKey)" `
  --entrypoint=gordon bom apply