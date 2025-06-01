---
title: lesson_6
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
5th Lesson - CCNA Fast Track (May 27, 2025). We left off at page 80.

# 0. CCNA Exam Questions
- 1. You need to save ram before clicking next in the CCNA exam via `copy run start`
- 2. 

# 7. Overview of Cisco Routers
## 7.3 Interfaces

Let's conclude and compare teh serial and ethernet interfaces

- Terminologies:
    - LAN = Local Area Network
    - WAN = Wide Area Network (e.g. Leased Line)

| N/A |  Ethernet Interfaces (e.g. f0/0, g0/0)  | Serial Interfaces (e.g. s0/0/0) |
|  :---: | :---:  | :---:  | 
| Typically used in  | LAN/ WAN | LAN only |
| L2 Protocol  | Ethernet | HDLC/PPP (OutSyll!) |
| Config setup | see below | see below |

- Configuration setup:
    - Ethernet:
        - 
        ```bash
        en
        config t
        int g0/0
        ip address 10.0.0.1 255.0.0.0
        no shut
        end
        ```
    - Serial: (treat is as normal routing port)
        - 
        ```bash
        en
        config t
        int s0/0/0
        ip address 10.0.0.1 255.0.0.0
        no shut
        end
        ```

# 8. Basic Router Management

## 8.1 Features of CLI (useful comamnds I guess)

### 8.1.1 Help System 
- `help`, help system can help you with commands instructions
- `show ?` in user mode can tell you a list of commands to type

### 8.1.2 Abbreviations
- `show version` can also be typed as `sh version`
- `config t` = `conf t`, it works since there's no other command than config when you type conf

### 8.1.3 Editing Features
- ctrl + a = jump to start of the line in cli
- ctrl + e = jump to end of the line in cli

### 8.1.4 Command History
- You can call history buffer using the up arrow

## 8.2 Obtaining General info as a router
- You can use `sh ver` to disaplay software and hardware infos
- Primary RAM: 249856 byte
- Secondary RAM: 12288 byte
- Flash memory size is now 2256 Mb

## 8.3 Config Management (VERY IMPORTANT)
There are 2 diff locations in the rouer to store configs

|  `running-config`  | `startup-config` |
| :---:  | :---:  | 
| Stored in RAM, all commands are lost when router reloads  | Stored in [NVRAM](./lesson_5.md/#713-nvram-non-volatile) |
| Contect is dynamic, updated per config command entered | Router boost up and load startup-config file to running config |
| Can be checked with `sh running-config` | Can be checked with `sh startup-config`|

- To preserve the content in running-config `copy run start` & `copy running-config startup-config`

- Step 1: Setting IP address 
```bash
en
config
hostname Router2
int g0/0
ip address 10.0.0.2 255.0.0.0
no shut
end
```
- Step 2: `sh run` = shows configs are being run right now

- Step 3: `sh start`. Oh, no configuration saved in startup-config
```bash
startup-config is not present
```

- Step 4: `copy run start` to copy the running-config from RAM to startup-config in NVRAM
```bash
copy run start
Destination filename [startup-config]?
Building configuration...
[OK]
```

- Step 5: `sh start` to check your new config copied over ti startup-config :D

### Lab 1: Backup