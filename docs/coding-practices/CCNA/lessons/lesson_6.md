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
- 2. Need to know how to use vty to telnet and verify the connection + something else

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
| Stored in RAM, all commands are lost when router reloads  | Stored in [NVRAM](./lesson_5/#713-nvram-non-volatile) |
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
Router
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

### Lab 1: Backuping configs to TFTP server
- Topology: ![](../../../../../assets/images/ccna/lesson5/lesson6_tftp_1.jpg)

- Step 1: Sanity Check from router 1: `ping 172.23.66.3`.
```bash
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.23.66.3, timeout is 2 seconds:
!!!!
Sucess rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
```

- Step 2: `copy run tftp`, you then punch in your address/ name of remote host
```bash
Address or name of remote host []? 172.23.66.3
Destination filename [router1-confg]?
!!
1159 bytes copied in 1.097 secs (1057 bytes/sec)
```

- You'll then see in the tftp server

## 8.4 Configuring Password and Telnet Access
- There are 4 types of password can be configured
    - Enable Password/ secret
        - Use: Preventing unauthroized access to Privileged Mode
        - Example: with password as `sadmin`
        ```bash
        en
        config t
        hostname Router1
        enable secret sadmin
        end
        disable
        ```
    - Console password
        - Use: Preventing CLI access through console port connection. `line console 0`/ `line con 0` refers to interface console 0.
        - `login` means this password checking rule is actually implements
        - Example:
        ```bash
        config t
        line console 0
        password cadmin
        login
        end
        ```
    - VTY = Virtual Teletype (like remote access)
        - Use: Preventing CLI access to telnet connection
            - Configuring IP address on a router interface/ VLAN interface for a switch
            - Configuring password in Line config mode for telnet connection = setting VTY Password
        - Topology: ![](../../../../../assets/images/ccna/lesson5/lesson6_telenet_1.jpg)
        - Example:
        ```bash
        config t
        int g0/0
        ip address 10.0.0.1 255.0.0.0
        no shut
        line vty 0 4
        password tadmin
        transport input telnet
        end
        ```
        - `line vty 0 4` : entering line config mode for vty for remote access, we configure 5 vty lines (0-4 vty lines). Max 5 telnet sessions is allowed
        - `transport input telnet` : Configuring line vty 0 4 accept telnet connections

        - After this configuraiton, Router 2 can TCP/IP to Router 1
        ```bash
        config t
        int g0/0
        ip address 10.0.0.2 255.0.0.0
        no shut
        end
        ```
        <br/>
        When you telnet in Router 2 `telnet 10.0.0.1`, you'll need password now
        
        ```bash
        Trying 10.0.0.1 ... Open

        User Access Verification

        Password:
        ```
    - ## 8.5 service password-encryption
        - `sh run` will tell you you have `no service password-encryption`
        ```bash
        show run
        ```
        - Any secret will be hashed but other passwords won't
            - secret: auto encryption
            - passwords: manual encryption
        - To setup and enable service password... you do `service password-encryption` when your passwords are NOT encrypted on the run config
        - 
        ```bash
        config t
        service password-encryption
        ```
        - Sanity check with `sh run` again
        - Note: These encrypted passwords are NOT save, use cisco 7 password 7 website can easily decrypt this. Password should better to stored on AAA servers!

# 9. Static Routing

## 9.1 Route entries for directly connected networks

### 9.1.1 Routes for directly connected networks
- Note: please reload your system and clear everything with `reload`
- Suppose router has 2 interfaces (= 2 ports) with different IP address on different networks
    - IP 10.0.0.0/8 connected to g0/0 on Router 1 on IP 10.0.0.1/8 
    - s0/0/0 on Router 1 on IP 192.168.1.1/24 connected to 192.168.1.0/24
- Routing table of Route 1 auto includes routes for 10.0.0.0 and 192.168.1.0
```bash
Routing table of router 1
-----------------------------------

Network Destination         Gateway                 Interface
10.0.0.0/8                  directly connected      g0/0
192.168.1.0/24              directly connected      s0/0/0
```
- The topology: ![](../../../../../assets/images/ccna/lesson5/lesson6_dcn_1.jpg)
- The setup
    - Step 1: `no shut` meaning no ip is set
    ```bash
    en
    config t
    hostname Router1
    int g0/0
    no shut
    end
    ```
    - Step 2: `sh ip route`.
    ```bash
    Codes: I - IGRP derived, R - RIP derived, O - OSPF derived
       C - connected, S - static, E - EGP derived, B - BGP derived
       * - candidate default route, IA - OSPF inter area route
       E1 - OSPF external type 1 route, E2 - OSPF external type 2 route
    ```
