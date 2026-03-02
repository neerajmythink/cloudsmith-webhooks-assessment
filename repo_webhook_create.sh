#!/usr/bin/env bash

# Create a Webhook that will send information to a test endpoint(Webhook tester) when a package is synchronised or a tag is updated, the Webhook should trigger only for python packages tagged as “shared”.

export NAMESPACE="cloudsmith-org-neeraj" # Replace with your actual namespace
export API_KEY=$CLOUDSMITH_API_KEY # Ensure you have set the CLOUDSMITH_API_KEY environment variable with your API key
export REPO_NAME="example_repo_through_cli" # You can change the repository name as needed
export TARGET_URL="https://webhook.site/06499a3b-b157-4111-82d1-d0146edfdbb3" # Replace with your actual webhook target URL (e.g., from webhook.site)
export PACKAGE_QUERY="format:python and tag:shared" # Query to filter for python packages tagged as "shared"

# Function to set up a webhook for the specified repository and namespace
create_webhook() {
  curl -sS\
    --request POST \
    --url https://api.cloudsmith.io/webhooks/${NAMESPACE}/${REPO_NAME}/ \
    --header "X-Api-Key: ${API_KEY}" \
    --header 'accept: application/json' \
    --header 'content-type: application/json' \
    --data '
          {
        "is_active": true,
        "target_url": "'"${TARGET_URL}"'",
        "request_body_format": 3,
        "request_body_template_format": 1,
        "package_query": "'"${PACKAGE_QUERY}"'",
        "verify_ssl": true,
        "templates": [
                      {
                        "event": "default",
                        "template": "{\"event_type\": \"cloudsmith_package_event\"}"
                      }
                      ],
        "events": [
                  "package.synced",
                  "package.tags_updated"
                ]
      }
' | jq '.slug_perm'
}

echo "#### Creating a webhook for given package query '${PACKAGE_QUERY}' packages in '${REPO_NAME}' in namespace: '${NAMESPACE}' with 'slug_perm' as ####"
create_webhook
