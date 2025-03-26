---
title: IaC (Infra as Code)
layout: default
parent: CI
grand_parent: Coding Practices
has_children: true
---

# 0. File structure
1. .github/
     - workflows/
          - dependabot.yml
     - CODEOWNERS
     - dependabot.yml
2. .vscode/
3. ansible/
4. corvil/ (lots of conf inside)
5. jira/
     - test.py
6. pyinfra/
7. terraform/
8. .gitignore
9. .groovylintrc.json
10. Jenkinsfile.asia
11. Jenkinsfile.admin
12. README.md
13. pyproject.toml
14. requirements-jfrog.txt
     - 
     ```txt
     hvac==2.3.0
     ``` 
15. requirements-pyinfra.txt
     - 
     ```txt
     aiohttp[speedups]==3.11.14
     black==25.1.0
     hvac==2.3.0
     pyinfra==3.2.0
     packaging==24.2
     gevent=
     ```
16. requirements-reconnect.txt
     - 
     ```txt
     aiohttp[speedups]==3.11.14
     black==25.1.0
     hvac==2.3.0
     pyinfra==3.2.0
     packaging==24.2
     gevent==24.11.1
     ```
17. requirements-terraform.txt
     - 
     ```txt 
     hvac==2.3.0
     ```
18. tox.ini
19. with_secrets.py

# 14-17 SKIPPED since it's already written out

# 18. tox.ini

```tox

[tox]
skipsdist = True

[testenv:{format, check_format}]
passenv = NETRC
deps =
     black[jupyter]
     isort[colors]
commands = 
     format: black . {posargs}
     format: isort . {posargs}
     check_format: black --check --diff --color . {posargs}
     check_format: isort --check-only --diff --color . {posargs}

[testenv:dev-{ame,asi,eur}, tst-{asi}, far-{asi}, pyinfra, lcl]
deps = -r {tox_root}/requirements-pyinfra.txt
changedir = pyinfra
setenv=
     PYINFRA_PROGRESS=off
pass_env = SSH*
          USER
          NETRC
          WRAPPED_ROLE_ID_TOKEN
          VAULT_TOKEN
          USERNAME
          PASSSWORD
          GIT_USERNAME
          GIT_PASSWORD
          JFROG_USER
          JFROG_PASSWORD
          JFROG_SERVER_ID
allowlist_externals = 
     ../with_secrets.py
commands = 
     pyinfra --version
     dev-ame: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y inventories/dev.py dev_servers.py --limit dev_ame {posargs}
     dev-asi: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y inventories/dev.py dev_servers.py --limit dev_asi {posargs}
     dev-eur: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y inventories/dev.py dev_servers.py --limit dev_eur {posargs}
     tst-asi: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y inventories/tst.py dev_servers.py --limit tst_asi {posargs}
     far-asi: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y inventories/far.py dev_servers.py --limit far_asi {posargs}
     lcl: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y inventories/lcl.py {posargs}
     pyinfra: ../with_secrets.py cloudplatform,s3,jfrog-dsp pyinfra -y {posargs}

[testenv:terraform-{init,plan,import,apply,output,destroy,replace}]
deps = -r {tox_root}/requirements-terraform.txt
changedir = terraform
pass_env = SSH*
          USER
          NETRC
          WRAPPED_ROLE_ID_TOKEN
          VAULT_TOKEN
          USERNAME
          PASSSWORD
allowlist_externals = 
     ../with_secrets.py
commands = 
     terraform-init: ../with_secrets.py cloudplatform,s3 ./terraform_init.sh {posargs}
     terraform-plan: ../with_secrets.py cloudplatform,s3 ./terraform_plan.sh {posargs}
     terraform-import: ../with_secrets.py cloudplatform,s3 ./terraform_import.sh {posargs}
     terraform-apply: ../with_secrets.py cloudplatform,s3 ./terraform_apply.sh {posargs}
     terraform-output: ../with_secrets.py cloudplatform,s3 ./terraform_output.sh {posargs}
     terraform-destroy: ../with_secrets.py cloudplatform,s3 ./terraform_destroy.sh {posargs}
     terraform-replace: ../with_secrets.py cloudplatform,s3 ./replace_all_dev_servers.sh {posargs}

[testenv:reconnect]
deps = -r {tox_root}/requirements-reconnect.txt
setenv=
     SSL_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt
passenv = 
     JENKINS_USERNAME
     JENKINS_PASSWORD
commands = 
     reconnect_build_agents {posargs}
```

19. with_secrets.py

```python
#!/usr/bin/env python3

import os
import subprocess
import sys

import hvac 

# Useful links
'''
https://www.hasi
'''

class VaultClient:
     def __init__(self):
          self.client = hvac.Client (
          url = os.getenv("VAULT_ADDR","https://vault.cloud.company/"),
          namespace=os.getenv("VAULT_NAMESPACE","myVault/ABC_TRIGRAM_5153_DEV_platform/"),
          verify="/etc/pki/tls/certs/ca-bundle.crt",
     )

     def __enter__(self):
          self.login()
          return self

     def __exit__(self, exc_type, exc_value, traceback):
          self.logout()



```