#!/usr/bin/env bash

# Create a Webhook that will send information to a Slack channel when any npm or python packages tagged with the latest release are deleted from Cloudsmith.
# Note: Before making the Webhook in cloudsmith, make sure to create an Incoming Webhook in your Slack workspace and set the WEBHOOK_TARGET_URL environment variable with the generated Slack webhook URL.
export NAMESPACE="cloudsmith-org-neeraj" # Replace with your actual namespace
export REPO_NAME="example_repo_through_cli" # You can change the repository name as needed
export API_KEY=$CLOUDSMITH_API_KEY # Ensure you have set the CLOUDSMITH_API_KEY environment variable with your API key

export TARGET_URL=$WEBHOOK_TARGET_URL # Ensure you have set the WEBHOOK_TARGET_URL environment variable with your Slack webhook URL
export PACKAGE_QUERY="(format:npm or format:python) and tag:latest" # Query to filter for npm or python packages tagged with "latest"

# Function to set up a webhook for the specified repository and namespace
create_slack_webhook() {
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
                        "template": "{\"blocks\":[{\"type\":\"header\",\"text\":{\"type\":\"plain_text\",\"text\":\"🚨 Cloudsmith Package Alert\",\"emoji\":true}},{\"type\":\"divider\"},{\"type\":\"section\",\"text\":{\"type\":\"mrkdwn\",\"text\":\"```\\nNamespace     : {{data.namespace}}\\nRepository    : {{data.repository}}\\nPackage Name  : {{data.display_name}}\\nFormat        : {{data.format}}\\nSlug          : {{data.slug_perm}}\\nEvent         : {{meta.event_id}}\\nTimestamp     : {{meta.event_at}}\\n```\"}}]}"
                      }
                      ],
        "events": [
                  "package.deleted"
                ]
      }
' | jq '.slug_perm'
}

# Call the function to create the webhook and print the slug_perm of the created webhook
echo "#### Creating a webhook for given package query '${PACKAGE_QUERY}' packages in '${REPO_NAME}' in namespace: '${NAMESPACE}' with 'slug_perm' as ####"
create_slack_webhook