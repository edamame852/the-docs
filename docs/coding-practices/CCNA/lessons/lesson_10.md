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
- IPv6 is 128 bits long (vs IPv4 which is 32 bits long)
- 128 buts is more than enough for global unique IP addresses (since number of IPv6 address is 2^128 = 340 undecillion addresses)

## 14.2 IPv6 Addressing Representation
- IPv6 has 32 hexadecimal digits
- Recall our [calcip.com](https://www.calcip.com/) 4 hexes * 8 groups = 32 hex digits (note 1 hex = 4 bit)

# Lab 5: NAT, SSH, ACL

# Simulation
## Simulation 42
- Topology: ![](../../../../../assets/images/ccna/simulation/simulation_42.png)

- Tasks:
    - Overall layout, all physical cabling is in place. R2 and R3 are inaccessible. Config OSPF routing for the network and ensure R1 has joined area 0 WITHOUT using network statements!
    - Task 1:
        - Need to configure OSPF on R1 iwth process ID and router ID only as the following...
            - Using process ID 33
            - Use e0/1 IP as the router ID

        - Solution:
            - on R1:
            ```text
                en
                sh run
            ``` 
            - This will help get the router ID and all the ip address of the connected interfaces!
            - Returns the following output
            - 
            ```text
                interface Loopback 0
                    ip address 10.11.11.11 255.255.255.255
                !
                interface Ethernet0/0
                    ip address 10.0.22.1 255.255.255.252
                    duplex auto
                !
                interface Ethernet0/1
                    ip address 10.0.33.1 255.255.255.248
                    duplex auto
                !
                interface Ethernet0/2
                    no ip address
                    duplex auto
                !
            ```
            - This means that the IP address for the int e0/1 is `10.0.33.1`. So we should configure ospf on that IP ! Note: `ospf 33` the process ID is then 33
            - Continuing on R1
            - 
            ```text
                en
                config t
                router ospf 33
                router-id 10.0.33.1
                end
                copy run start
            ```
            > Note: page 155 is for OSPF unification and page 159 is for clearing OSPF process

    - Task 2: Need to configure 2 things...
        - One, configure R1 to establish neighbor adjacencies with R2 and R3. DO NOT USE the network statements under the OSPF process
        - Two, Config R1 to ALWAYS be the DR for area 0!
        - Solution:
            - on R1
            ```text
                en
                config t

                int e0/0
                ip ospf 33 area 0
                ip ospf priority 255

                int e0/1
                ip ospf 33 area 0
                ip ospf priority 255

                end
                copy run start
            ```
        - Explanation: the `255` is merely to make R1 the DR always since it is the highest priority (default is 1). Hence R2 and R3 will be BDR and DROTHER respectively. `255` is the max priority value!



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
    - Task 1: Refer to the diagram. Configure OSPF area 0 with process ID 1 on R1, R2 and R3 and SW101. Use a **single command** under the OSPD process to achieve this.
        - Solution: Perform all the following on R1, R2, R3 and SW101
        - 
        ```text
            en
            config t
            router ospf 1
            network 10.0.0.0 0.255.255.255 area 0
            end
            copy run start
        ```
        - Explanation: Note that all IP starts with 10.x.x.x, hence we can use the wildcard mask of 0.255.255.255 to off set it. Hence `router ospf 1` + `network 10.0.0.0 0.255.255.255 area 0`

    - Task 2: Configure SW 101 so that it's always gonna be the DR for the VLAN 101 network. Note, there should be no BDR. Two things to be careful about.
        - First, don't use the neighbor command under the OSPF process to achieve this. (i.e. `ospf` has been banned)
        - Second, no config changes can be performed on SW 101 (no touching SW 101)
        - Solution: Perform on R1, R2 and R3 using priority, with ints facing SW101
            - For R1
            ```text
                en
                config t
                int e0/2
                ip ospf priority 0
                end
                copy run start
            ```
            - For R2
            ```text
                en
                config t
                int e0/1
                ip ospf priority 0
                end
                copy run start
            ```
            - For R3
            ```text
                en
                config t
                int e0/0
                ip ospf priority 0
                end
                copy run start
            ```
        - Explanation:
            - Doing `ip ospf priority 0` on all R1, R2 and R3 facing SW101 will ensure SW101 is always the DR since it has the highest priority (default is 1). Therefore eliminating the need to configure DR and BDR. `pirority 0` means it cannot be elected as DR or BDR = giving up on DR and BDR chances.
            - Had neighbor command been allowed, we could have configured SW101 as DR directly using neighbor command under OSPF process.
            - Recall in page 155 where we can do things like `sh ip ospf int g0/0` or `sh ip ospf neighbor` to verify the DR and BDR status. For refernce click [here](../lesson_8/#104-configuring-ospf-broadcast-on-cicso-router) 

