---
title: IaC (Infra as Code)
layout: default
parent: CI
grand_parent: Coding Practices
has_children: true
---

# File structure
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
15. requirements-pyinfra.txt
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
18. tox.ini
19. with_secrets.py
