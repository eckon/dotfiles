abbr --add bd_db-token     "az account get-access-token --resource-type oss-rdbms | jq '.accessToken' -r | clip"
abbr --add bd_login-apollo "az login && az acr login --name apollocore"
abbr --add bd_docker-login "az login; and set TOKEN (az acr login --name apollocore --expose-token --query accessToken -o tsv); and docker login apollocore.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p $TOKEN"
