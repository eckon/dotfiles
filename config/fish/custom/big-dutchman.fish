abbr --add bd_db-token     "az account get-access-token --resource-type oss-rdbms | jq '.accessToken' -r | clip"
abbr --add bd_login-apollo "az login && az acr login --name apollocore"

function bd_docker-login
  az login; or return
  set token (az acr login --name apollocore --expose-token --query accessToken -o tsv); or return
  echo $token | docker login apollocore.azurecr.io \
    -u 00000000-0000-0000-0000-000000000000 --password-stdin
end

function bd_switch-cloud
  set current (az cloud show --query name -o tsv); or return
  az cloud list --query "[].name" -o tsv \
    | string match -v -- $current \
    | fzf --height=~10 --reverse --header "Current: $current" \
    | xargs -r az cloud set --name
end
