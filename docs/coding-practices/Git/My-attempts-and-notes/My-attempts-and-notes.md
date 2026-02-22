---
title: My attempts and notes
layout: default
parent: Git 
grand_parent: Coding Practices
---
# Personal Notes or My Attempts
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Basics
## Removing local branches and remote branches!
The way I do it is this all together is this

```bash
git branch -d remote_branch_name # remove local branch
git push origin --delete remote_branch_name # remote remote branch
git fetch --all --prune # remove the remote branch reference in local, by updating local view
```

- Removing local branches
    - `git branch -d remote_branch_name` = normal delete local branch
    - `git branch -D remote_branch_name` = force delete local branch
- Removing remote branches
    - `git push origin --delete remote_branch_name` = normal delete remote branch
    - `git push origin :remote_branch_name` = alternative way to delete remote branch by updating remote branch to NOTHING, so meaning to remove it (the syntax is `git push <remote> <local-ref>:<remote-ref>` )