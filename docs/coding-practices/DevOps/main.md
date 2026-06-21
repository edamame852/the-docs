---
title: CICD
layout: default
parent: Coding Practices
has_children: true
---

# Github Action

## Adding **PageCrypt** for static pages (i.e. Github Pages)
1. Head to your project, Settings tab -> Secrets and variables -> Actions -> Manage enviornment secrets
2. Click New Enviornment or `PROD` -> Add Enviornmental Secret, add your secret name and secret (e.g. PROD_MY_SECRET)
3. Use this new secret in your action.yml, for example:

Just make sure the identation is right (this might be off/wrong lmao)

```yaml

jobs:
  build:
    runs-on: ubuntu-latest
    environment: "PROD" # MUST HAVE - IMPORTANT
    steps:
        - name: Encrypt pages with PageCrypt
          run: | # MUST HAVE - IMPORTANT
            chmod 777 -R _site/
            npm i -D pagecrypt 
            
            sudo npx pagecrypt "_site/docs/medical.html" "_site/docs/medical.html" "$PROD_MEDICIAL_PASSWORD" --force

                for dir in _site/docs/diving/*/; do
                    for subdir in "$dir"*/; do
                        for file in "$subdir"index.html; do
                            sudo npx pagecrypt "$file" "$file" "$PROD_DIVING_PASSWORD" --force
                        done
                    done
                done
          env:
            NODE_ENV: production # OPTIONAL ?
            PROD_MY_SECRET: ${{ secrets.PROD_MY_SECRET }}

```
{:.note }
> Explanation: npm installed pagecrypt, and encrpts post .md rendered html. The triple for loop is required since I want to encrpt my aow,nitrox and owd dirs (aka: _site/docs/diving/aow/aow/index.html). For that, I had to loop through the dir and subdirs to get there.
> The format is `sudo npx pagecrypt "$file" "$file" "$MY_GITHUB_ACTION_PASSWORD" --force`