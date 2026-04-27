aws sso login --profile alejo_terrasacha
$creds = (aws configure export-credentials --profile alejo_terrasacha | ConvertFrom-Json)
aws configure set aws_access_key_id "$($creds.AccessKeyId)" --profile alejo_terrasacha
aws configure set aws_secret_access_key "$($creds.SecretAccessKey)" --profile alejo_terrasacha
aws configure set aws_session_token "$($creds.SessionToken)" --profile alejo_terrasacha
Write-Host "Credenciales renovadas exitosamente" -ForegroundColor Green