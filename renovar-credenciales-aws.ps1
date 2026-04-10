aws sso login --profile oraculo
$creds = (aws configure export-credentials --profile oraculo | ConvertFrom-Json)
aws configure set aws_access_key_id "$($creds.AccessKeyId)" --profile temp-amplify
aws configure set aws_secret_access_key "$($creds.SecretAccessKey)" --profile temp-amplify
aws configure set aws_session_token "$($creds.SessionToken)" --profile temp-amplify
Write-Host "Credenciales renovadas exitosamente" -ForegroundColor Green