---
title: lesson_10
layout: default
parent: CCNA
grand_parent: Coding Practices
nav_order: 10
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
Lesson 9 - CCNA Fast Track (June, 2025). We left off at page 163. It ends at the top of pg 186.

# 0. CCNA Exam Questions
1. There are alternative ways to hash/encrypt passwords where `0` = Unencrypted secret, `5` = MDS Hashed secret, `8` PBKDF2 Hashed Secret, `9` SCRYPT Hashed secret 

# 13 SSH : Secure SHell

## 13.3 Setting up hostname and domain names !
- Recall, this is our topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_ssh.jpg) 
- Method 1: Please perform the following on R1
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
    - `transport input ssh`: limits only ssh to enter the 5 vtysm and limits virtual terminals to accept SSH connections only
- Remarks:
    - Cisco IOS ssh servers requires username based auth, hence need username-password pair (i.e. user1, pass1)

- Method 2: Bash or encrypt the password
- Here are the possible methods to setup your secrets
```text
    Router1(config)# username user1 secret ?
    0 specifies a UNENCRYPTED secret will follow
    5 specifies a MDS Hashed secret will follow
    8 specifies a PBKDF2 Hashed Secret will follow
    9 specifies a SCRYPT Hashed secret will follow
```

- On R2, privilage mode `ssh -l user1 192.168.1.1` (i.e. Trying to access R1 from R2 via ssh) and enter the password and it should work :D

# 14. IPv6

## 14.1 Overview 
- IPv6 = latest verion of IP (= Internet Protocol)

# Lab 5: NAT, SSH, ACL

# Simulation
## Simulation 42

## Simulation 31
- Topology: ![](../../../../../assets/images/ccna/simulation/simulation_31.png)
- 
| Device      | Interface        | IP Address        |
| ----------- | -----------      | -----------       |
| R1          | Loopback 0       | 10.1.1.1/32       |
| R2          | Loopback 0       | 10.2.2.2/32       |
| R3          | Loopback 0       | 10.3.3.3/32       |
| SW101       | Loopback 0       | 10.101.1.1/32     |
| SW101       | VLAN 101         | 10.101.101.101/24 |


- Tasks:
    - Task 1: Refer to the diagram. Configure OSPF area 0 with process ID 1 on R1, R2 and R3 and SW101. Use a **single command** under the OSPD process to achieve this
    - Solution:Perform all the following on R1, R2, R3 and SW101
    - 
    ```text
        en
        config t
        router ospf 1
        network 10.0.0.0 0.255.255.255 area 0
        end
        copy run start
    ```
    - Task 2:
