# Cloudsmith Webhook Automation

This repository provides automation scripts to create and manage **Cloudsmith webhooks via API** for package lifecycle events.

It covers two primary webhook use cases:

1. **Python Shared Package Webhook**
   - Triggers when a Python package tagged `shared`:
     - Is synchronized
     - Has its tag updated

2. **Slack Notification for Deleted Latest Releases**
   - Triggers when an `npm` or `Python` package:
     - Tagged as the latest release
     - Is deleted from Cloudsmith

   - Sends a structured notification to Slack

---

# Architecture Overview

```
Cloudsmith Event
        ↓
Cloudsmith Webhook
        ↓
Target Endpoint (webhook.site / Slack)
```

---

# Prerequisites

Before running the scripts, ensure the following:

## 1. Cloudsmith API Key

You must have a Cloudsmith API key with permission to create webhooks in the target namespace and repository.

Set it as an environment variable:

```bash
export CLOUDSMITH_API_KEY="your_api_key_here"
```

## 2. Webhook Target URL

Set the target endpoint for webhook payload delivery:

```bash
export WEBHOOK_TARGET_URL="https://your-webhook-url"
```

### Target URL Recommendations

| Webhook                   | Recommended Target                             |
| ------------------------- | ---------------------------------------------- |
| Webhook #1 (Testing)      | [https://webhook.site/](https://webhook.site/) |
| Webhook #2 (Slack Alerts) | Slack Incoming Webhook URL                     |

---

# Webhook #1 — Python `shared` Tag Events

## Description

Creates a webhook that triggers when:

- A Python package tagged `shared` is synchronized
- A tag is updated for that package

## Script

```
repo_webhook_create.sh
```

## Usage

```bash
chmod +x repo_webhook_create.sh
./repo_webhook_create.sh
```

## Expected Output

The script will:

- Send a `POST` request to the Cloudsmith Webhooks API
- Configure event filters and message templates
- Return the webhook `slug_perm`

Example output:

```
#### Creating a webhook..../...with 'slug_perm' as ####
"8pVeC65HyPcW"
```

---

# Webhook #2 — Slack Alert for Deleted Latest Releases

## Description

Creates a webhook that triggers when:

- An `npm` or `Python` package
- Tagged as the latest release
- Is deleted

A formatted Slack message will be sent to the configured Slack channel.

## Script

```
repo_webhook_create_slack.sh
```

## Usage

```bash
chmod +x repo_webhook_create_slack.sh
./repo_webhook_create_slack.sh
```

## Expected Output

```
#### Creating a webhook..../...with 'slug_perm' as ####
"9xYzA12AbCdE"
```

---

# Testing the Webhooks

## Test Webhook #1

1. Synchronize a Python package tagged `shared`
   **OR**
2. Update the `shared` tag on an existing package

Verify that the payload is delivered to the configured endpoint.

---

## Test Webhook #2

1. Delete an `npm` or `Python` package
2. Ensure it is tagged as the latest release

Verify that the Slack channel receives the notification.

---

# Troubleshooting

### No Payload Received

- Confirm `WEBHOOK_TARGET_URL` is correct
- Check Cloudsmith webhook configuration
- Validate that the event filter conditions are met

### API Returns `null`

If recreating a webhook:

- Delete the existing webhook first
- Then rerun the script

Webhooks can be removed via:

- Cloudsmith UI
- Cloudsmith API

---

# Security Considerations

- Do not commit your `CLOUDSMITH_API_KEY`
- Use secure secret management in CI/CD pipelines
- Restrict webhook permissions to minimum required scope

---

# Customization

The webhook payload templates inside the scripts can be modified to:

- Change Slack formatting
- Add additional metadata fields
- Adjust event filters
- Integrate with other services (e.g., Teams, Datadog, custom APIs)

---

# API Reference

For full webhook configuration options, see:

[https://docs.cloudsmith.com/api/webhooks/create](https://docs.cloudsmith.com/api/webhooks/create)

---

# License

This project is intended for internal automation and integration purposes.
Adapt as required for your organization’s workflow.

---

If you’d like, I can also provide:

- A version with badges (CI, license, version)
- A developer-focused README with curl examples inline
- A Terraform-based alternative
- Or a version tailored specifically for a Cloudsmith demo environment