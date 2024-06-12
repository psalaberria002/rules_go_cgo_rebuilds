#!/usr/bin/env bash

set -o pipefail

if creds_json="$(jq '. | .grant_type = "refresh_token" ' ~/.config/gcloud/application_default_credentials.json)"; then
    json_response=$(curl --silent --request POST 'https://oauth2.googleapis.com/token' \
        --header 'Content-Type: application/json' \
        --data-raw "$creds_json")

    jq '{"headers": {"Authorization": [("Bearer " + .id_token)]}}' <<<"$json_response"
else
    echo "Please ensure that you have run \`gcloud auth application-default login\`"
fi
