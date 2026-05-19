---
title: bash
layout: default
parent: Terminal 
grand_parent: Coding Practices
---

# bash
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## ls
- `ls` short for **list**ing files in the current dir.
- `ls -a` to list all files including hidden ones (those start with a dot).
- `ls -l` to list files in long format (vertically), +permissions, owner, size
- `ls -h` to list file sizes in human-readable format (e.g., KB, MB).
- `ls -t` to sort files by modification time, newest first.
- `ls -r` to reverse the order of the sort.

## grep vs find
- `grep` is used to search for specific patterns within the content of files, while `find` is used to search for files and directories based on their names, types, sizes, or other attributes.

### grep
- `grep` short for **g**lobal **r**egular **e**xpression **p**rint, used to search for specific patterns in files or output.
- grep file content?
    - `grep "pattern" filename` to search for "pattern" in a file.
    - `grep -r "pattern" directory/` to search recursively in a directory.

### find
- `find` is used to search for files and directories in a directory hierarchy based on various
