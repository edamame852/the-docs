---
title: lesson_10
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
Lesson 9 - CCNA Fast Track (June, 2025). We left off at page 163. It ends at the top of pg 186.

# 0. CCNA Exam Questions
1. 

# 13 SSH : Secure SHell

## 13.3 Setting up hostnames and domain names !
- Recall, this is our topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_ssh.jpg) 
- Please perform the following on R1
```text
    conf t
    username user1 secret pass1
    line vty 0 4
    login local
    transport input ssh
    end
```
- Let's break it down a bit...
    - `username user1 secret pass1` = username and password
    - `line vty 0 4` vty: Multiple entries into Router user mode, referring to diagram pt. 2 from page 18
    - `login local` : login w/ local user info (i.e. user1 pass1)
    - `transport input ssh`: 

# 14. IPv6

## 14.1 Overview
- IPv6 = latest verion of IP (= Internet Protocol)

# Lab 5: NAT, SSH, ACL

# Simulation
## Simulation 42

## Simulation 31

