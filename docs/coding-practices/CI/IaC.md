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

```groovy
#!/usr/bin/env groovy

@Library('jenkins-libs') _

project_name = utils.get_project_name()

void check_format() {
     utils.with_jfrog_credentials{
          sh("tox run -c ${project_name} -e check_format ")
     }
}

pipeline {
     agent {node {label 'dev07'}}

     options {
          buildDiscarder(logRotator(numToKeepStr: '20'))
          skipDefaultCheckout()
          ansiColor('xterm')
          timestamps()
     }

     stages {
          stage("Checkout") {
               steps {
                    script {
                         utils.checkout_project()
                    }
               }
          }
          stage("Style") {
               steps {
                    check_format()
               }
          }
     }
}

```

11. Jenkinsfile.admin
```groovy
#!/usr/bin/env groovy

@Library('jenkins-libs') _

project_name = utils.get_project_name()

void run_tox(String name, String parameters='') {
     utils.with_jfrog_credentials{
          utils.with_vault_credentials('terraform') {
               utils.with_jfrog_credentials {
                    sh("""tox run -c ${project_name} -re ${name} ${(parameters ? "-- $parameters" : '')}""")
               }
          }
     }
}

void reconnect() {
     withCredentials ([usernamePassword(
          credentialsId: 'jenkins-admin-account',
          usernameVariable: 'JENKINS_USERNAME',
          passwordVariable: 'JENKINS_PASSWORD'
     )]) {
          sh("""tox run -c ${project_name} -re reconnect """)
     }
}


pipeline {
     agent {node {label 'dev07'}}

}

```

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

# 19. with_secrets.py

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

     def login(self):
          role_id = self.unwrap("WRAPPED_ROLE_ID_TOKEN", "role_id")
          if role_id:
               secret_id = self.unwrap("WRAPPED_SECRET_ID_TOKEN", "secret_id")
               if secret_id:
                    self.client.auth.approle.login(role_id=role_id, secret_id=secret_id)
                    return
          self.user_login()
     
     def user_login(self):
          token = os.getenv("VAULT_TOKEN")
          username=os.getenv("USERNAME")
          password=os.getenv("PASSWORD")

          if token:
               self.client.token = token
          elif username and password:
               self.client.auth.ldap.login(username=username, password=password)
     
     def logout(self):
          if self.client_is_authenticated():
               self.client.logout()
          
     def unwrap(self,token_name,key):
          token = os.getenv(token_name)
     
          if not token:
               print(f"Could not get token name's value {token_name} as an env variable")
               return None
          try:
               self.client.token = token
               unwrap_response = self.client.sys.unwrap()
               return unwrap_response["data"][key]
          except hvac.exceptions.Forbidden:
               print(f"Could not get {key} from {token_name} env variables")
               return None
          
     def get_secrets(self, keys):
          all_secrets = {}
          if self.client.is_authenticated():
               for key in keys.split(",")
                    secrets = self.client.secrets.kv.read_secret_version(path=key, mount_point="kv", raise_on_deleted_version=True)["data"]["data"]
          return all_secrets
     

with ValutClient() as client:
     secrets = client.get_secrets(sys.argv[1]) #2nd param = keys
env = os.environ.copy()
env.update(secrets)
subprocess.run(sys.argv[2:], check=True, env=env)

```