---
title: AI
layout: default
parent: Coding Practices
has_children: true
---

# AI

## Claude Code

### Setup poe claude-code and poe-code-router
1. Install these 2
    ```bash
        npm install -g @anthropic-ai/claude-code
        npm install -g @musistudio/claude-code-router
    ```
2. Obtain poe api token from https://poe.com/console/keys
3. Create api key file at `mkdir -p ~/.claude-code && touch ~/.claude-code/config.json` with content like this

4. `vi ~/.claude-code/config.json`
    ```json
        {
            "LOG": true,
            "API_TIMEOUT_MS": 600000,
            "Providers": [
                {
                "name": "openrouter",
                "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
                "api_key": "[PLACE YOUR POE API KEY HERE]",
                "models": [
                    "anthropic/claude-sonnet-4",
                    "anthropic/claude-opus-4.1"
                ],
                "transformer": {
                    "use": ["openrouter"]
                }
                }
            ],
            "Router": {
                "default": "openrouter,anthropic/claude-sonnet-4",
                "background": "openrouter,anthropic/claude-sonnet-4",
                "think": "openrouter,anthropic/claude-sonnet-4",
                "longContext": "openrouter,anthropic/claude-sonnet-4",
                "longContextThreshold": 60000,
                "webSearch": "openrouter,anthropic/claude-sonnet-4"
            }
        }
    ```

5. `npx poe-code@latest configure claude` and enter `y`

6. Activate with `claude`