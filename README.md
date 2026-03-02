# Cloudsmith Webhook Automation

Automation scripts to create and manage Cloudsmith webhooks for package lifecycle events.

## Prerequisites

Set environment variables:

```bash
export CLOUDSMITH_API_KEY="your_api_key_here"
export WEBHOOK_TARGET_URL="https://your-webhook-url"
```

---

## Webhook #1: Python Package Sync/Tag Update

### Create

```bash
chmod +x repo_webhook_create.sh
./repo_webhook_create.sh
```

Returns webhook ID: `8pVeC65HyPcW`

### Test

1. Synchronize a Python package tagged `shared`
2. OR update the `shared` tag on an existing package
3. Verify payload arrives at `WEBHOOK_TARGET_URL`

---

## Webhook #2: Slack Alert for Deleted Latest Releases

### Create

```bash
chmod +x repo_webhook_create_slack.sh
./repo_webhook_create_slack.sh
```

Returns webhook ID: `9xYzA12AbCdE`

### Test

1. Delete an `npm` or `Python` package tagged as `latest`
2. Verify Slack channel receives notification

---

## Troubleshooting

- **No payload received**: Verify `WEBHOOK_TARGET_URL` and event filter conditions
- **API returns null**: Delete existing webhook before recreating

---

## Security

- Don't commit `CLOUDSMITH_API_KEY`
- Use secret management for CI/CD
- Restrict webhook permissions

---

## Customization

Modify script templates to adjust Slack formatting, event filters, or integrate other services.

See [Cloudsmith API docs](https://docs.cloudsmith.com/api/webhooks/create) for full options.

## Steps to make incoming webhook target in slack

1. Go to your Slack workspace (personal) and navigate to "Apps" or "Integrations".
2. Create a new chennel for receiving notifications (optional but recommended) in Slack.
3. Click on 3 dots in the top right corner of the channel and select edit settings.
4. Go to "Integrations" tab and click on "Add an App" and search for "Incoming Webhooks".
5. Click on view and then click on configuration, will take you to the configuration page on the Slack website.
6. Click on "Add to slack" button and select the channel you want to post notifications to, then click "Add Incoming Webhooks integration".
7. After adding the integration, you will be provided with a Webhook URL. Copy this URL and set it as the value of `WEBHOOK_TARGET_URL` environment variable in your terminal:

```bash
export WEBHOOK_TARGET_URL="https://hooks.slack.com/services/your/webhook/url"
```

8. Now you can run the webhook creation script to set up the webhook with the Slack URL as the target for notifications. When the specified events occur in Cloudsmith, you should see notifications in your Slack channel.