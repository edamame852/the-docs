---
title: lesson_4
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
4rd Lesson - CCNA Fast Track (May 23, 2025). We left off at page 68.

# 0. CCNA Exam Questions
1. The CCNA exam will be using virtual devices, never real physical ones
2. 


# 4. Features in CISCO switches
## 4.6 CDP and LLDP (CDP was already discussed in lesson 3, will focus on LLDP now)

#### Lab 1: CDP Topolgy from Router perspective (continued) [Syll pt2.3]

- Last time: we talked about `sh cdp neighbors g1/1` to view neighbors

- Step 3: You can check the cdp neighbors in detail! `sh cdp neighbors g1/1 detail`
    - 
    ```bash
    ----------------------------------
    Device ID:  Router1
    Entry address(es):
    Platform:   Cisco,  Capabilities: Router Source-Router-Bridge
    Interface: GigabitEthernet1/1,  Port ID (Outgoing port): GigabitEthernet0/0
    Holdtime: 175 sec

    Version:
    Cisco IOS Software, IOSv Software (VIOS-ADVENTERPRISEK9-M), Version 15.6(2)T, RELEASE
    SOFTWARE (fc2)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2016 by Cisco Systems, Inc.
    Compile Tue 22-Mar-16 16:19 by prod_rel_team

    advertisment version: 2

    Total cdp entries displayed: 1
    ```

#### Lab 2: Configure IP Address for L2 Router into L3
- Topology diagram:
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_cdp_1.jpg)
- L2 Router cannot check neighbor IP address
- Step 1: Setup IP onto the Router1
```bash
    config t
    int g0/0
    ip address 10.0.0.1 255.0.0.0
    end
```

- Please wait up to 1min for the new IP to take affect

- Step 2: Verify cdp neighbor with detail `sh cdp neighbors g1/1 detail` on the Switch
- 
    ```bash
    ----------------------------------
    Device ID:  Switch1
    Entry address(es):
        IP address : 10.0.0.1 <---------------------- These are NEW :D
    Platform:   Cisco,  Capabilities: Router Source-Router-Bridge
    Interface: GigabitEthernet1/1,  Port ID (Outgoing port): GigabitEthernet0/0
    Holdtime: 175 sec

    Version:
    Cisco IOS Software, IOSv Software (VIOS-ADVENTERPRISEK9-M), Version 15.6(2)T, RELEASE
    SOFTWARE (fc2)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2016 by Cisco Systems, Inc.
    Compile Tue 22-Mar-16 16:19 by prod_rel_team

    advertisment version: 2
    Management address(es): <---------------------- These are NEW :D
        IP address: 10.0.0.1 <---------------------- These are NEW :D

    Total cdp entries displayed: 1
    ```

> Note: Now IP is set up for Router1, you can remove control (i.e. ssh/telnet/...etc) to the Router!

#### Lab 3: Turning off cdp for Switch1 (global + interface level turn off)

- Topology diagram:
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_cdp_1.jpg)

- Note: There are 2 ways to stop CDP
    - Stopping ALL ports: Do `no cdp run` at global config mode
    - Stopping a single port: Do `no cdp run` at interface config mode

- Step 1: Stopping cdp (on global level). No CDP messages will be sent/received through ALL ports.
    - 
    ```bash
    config t
    no cdp run
    end
    ```
- Step 2: Verify neighbors