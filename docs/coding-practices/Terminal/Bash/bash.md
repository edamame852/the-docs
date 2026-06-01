---
title: bash commands (ls, grep, find)
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
    - `grep -r "pattern" filename` to search recursively in a specific file.
    - `grep -i "pattern" filename` to search case-insensitively (i.e. ERROR, error, Error).
    - `grep -n "pattern" filename` to include line numbers in the output.
        - Example: the `is` is all in red, and the line numbers are in green (?)
            ```
                [12:02:07]miltonycchow@HP-Miller: ~$ grep -rin "is" .tmp.test.txt 
                1:This is a new line
                2:The is another new line
            ```
    - `grep -v "pattern" filename` to invert the match, showing lines that do NOT contain the pattern.
    - `grep -l "are" ~` to list only the names of files that contain the pattern "are". --> This won't work since ~ is a dir, so we need recursive search, aka: `grep -rl "are" ~`

### find
- `find` is used to search for files and directories in a directory hierarchy based on various
