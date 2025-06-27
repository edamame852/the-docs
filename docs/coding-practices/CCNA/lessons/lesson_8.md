---
title: lesson_8
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
Lesson 8 - CCNA Fast Track (June, 2025). We left off at page 151.

# 0. CCNA Exam Questions

1. Why do we need OSPF?
- Ans: 2 reasons: To enter other networks, to resolve non-directly connected network 

# 10. Dynamic Roututing 
## 10.3 OSPF
### 10.3.6 Interface and OSPF network types

|  | Ethernet interfaces (e.g. f0/0, g0/0, ...)   | Serial Interfaces (e.g. s0/0/0)     |
| ----- | -------- | ----------- |
| Commonly used in | LAN/WAN  | Usually WAN (leased line)      |
|    Layer 2 protocols(s)   | Ethernet | HDLC/ PPP (Both are out syll) |
|    Default OSPF Network type (Default is changable)   | Broadcast | Point-to-point |

- 2 ways of configuring OSPF network:
    - ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_1.jpg)

### 10.3.7 OSPF Versioning
Under format RFC2328, most OSPF is version 2 (v2). But version 2 only supports IPv4. This tech is from the late 90s<br/>
If we have OSPF version 3 (v3) (specified in RFC5340) will support IPv6.

## 10.4 Configuring OSPF Broadcast on Cicso Router

- Let's look at the topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_2.jpg)
- Note: OSPF Area 0 is the backbone, only a single area.

- Recall how to determine BR and BDR:
    - step 1: OSPF pirority 0 / 1
    - step 2: OSPF Highest Router ID

- Recall how to determine Router ID:
    - No pre-set router id, verify with `do sh run`
    - No loopback int on g0/1, g0/0
    - highest physical IP: Router 1 = `192.168.1.1` 

- Router 1 setup
```bash
en
conf t
hostname Router1

int g0/1
ip address 10.0.0.1 255.0.0.0
no shut

int g0/0
ip address 192.168.1.1 255.255.255.0
no shut

end
```

- Router 2 setup (Please note OSPF number is unique to it's own device. Different regions don't interfere w/ each other.)
```bash
en
conf t
hostname Router2

int g0/1
ip address 172.16.0.2 255.255.0.0
no shut

int g0/0
ip address 192.168.1.2 255.255.255.0
no shut

end
```

- Router 2 
```
conf t
router ospf 1
network 192.168.1.0 0.0.0.255 area 0
network 172.16.0.0 0.0.255.255 area 0

```
- Note 1: ospf # must specify a number, but this number can be user defined/ random
- Note 2: Defining g0/1 so it can broadcast to other networks
- The end goal is this: ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_3.jpg)
- Code explaination:
    - `router ospf 1` = turns on ospf w/ process number 1 (For CISCO IOS the range must be 1-65535)
    - 



# SIMULATION 3: LAB
- Topology Diagram: ![](../../../../../assets/images/ccna/simulation/simulation_3.jpg)
- We have a set of tasks and instructions...
    - Instructions: 
        - OSPF and IP connections are pre-configured
        - Do not change IP and Do not change OSPF
        - For this setup, all next hops and connected interfaces are used to configure static routes
        - only exceptions are for load balancing or redudancy without floating static
        - Connection must be established between subnet 172.20.20.128/25 & LAN at 192.168.0.0/24 (Basically LAN and Internet needs to be connected)
    - Tasks:
        - Task 1: Connect SW1 LAN subnet in R2 (Router2) 
            - Solution: make a static route
            - Recall: `ip route <destination network> <network masking> <gateway address>/<outgoing address>`
            - That outgoing address = next-hop-IP-to-SW1 : "Replace next-hop-IP-to-SW1" with the IP address of the interface on R2 that connects to SW1, or the IP of SW1 itself if it's Layer 3 capable.
            - 
            ```bash
            en
            conf t
            ip route 192.168.0.0 255.255.255.0 10.10.31.1
            copy run start
            ```
            - Destination network for LAN is `192.168.0.0` since for E0/1 it's 192.168.0.1 (with a dot 1 notation)
            - Network masking is `/24`: hence it's `255.255.255.0`
            - outgoing address (on switch side?): we're leaving through E0/0 without a doubt from R2. Hence the ip should be `10.10.31.1` 

        - Task 2: Connect Internet subnet to R1 Router
            - Solution: Setting default route and default gateway
            - Recall: `0.0.0.0 0.0.0.0` = default route. `10.10.13.3` = default gateway
            - Do these on R1
            ```bash
            en
            conf t
            ip route 0.0.0.0 0.0.0.0 10.10.13.3
            copy run start
            ```
            - `10.10.13.3` = default gateway since `10.10.13.0` is what R1 sees and `.3` is the notation R2 receives
        - Task 3: Make a single static route in R2 to Internet subnet. Factor in redudancy links between R1 and R2. R2 default route is NOT ALLOWED.
            - Solution: First check OSPF and setup static route
            - Recall: `sh ip route` to view a partial routing table
            - Do these on R2
            ```bash
            en
            sh ip route
            ```

            ```bash
            o       10.10.1.1/32 [110/11] via 10.10.12.129, 00:43:32, Ethernet0/2
                                 [110/11] via 10.10.12.1, 00:43:32, Ethernet 0/1
            ```
            Means that an OSPF to 10.10.1.1/32 load balancing w/ outgoing interfaces E0/2 and E0/1 already exist in R2 routing table

            ```bash
            conf t
            ip route 172.20.20.128 255.255.255.128 10.10.1.1 ???
            end
            copy run start
            ``` 
            or `ip route 172.20.20.128 255.255.255.128 e0/2` and `ip route 172.20.20.128 255.255.255.128 e0/1`s
            
        - Task 4: Make a static route in R1 to Switch LAN subnet. Primary link must be E0/1, backup link must be E0/2 via floating route. Change AD/ Administractive distance if needed.
            - Solution: Check ip route and setup AD route, no need to set floating static route
            - Recall:
            - Do these on R1
            ```bash
            en
            sh ip route
            ```

            ```bash
            o       192.168.0.0/24 [110/20] via 10.10.12.130, 00:01:08, Ethernet0/2
            ```

            ```bash
            conf t
            ip route 192.168.0.0 255.255.255.0 10.10.12.2
            end
            copy run start
            ```
            or maybe `ip route 192.168.0.0 255.255.255.0 e0/1`

# SIMULATION 15: LAB
- Topology Diagram: ![](../../../../../assets/images/ccna/simulation/simulation_15.jpg)
- Description:
    - Physical Cables are in place
    - R4 and C1 are fully configured and cannot be accessed
    - R4 LAN interface use .4 in last octet for each subnet
    - Need to establish connection e2e

- Tasks:
    - Task 1: Setup static routing to ensure R1 piroritize path to R2 to reach only PC1 on R4's LAN
        - Ans: PC1 is the host route. Do these on R1, then on R2
        - Note: `10.0.41.10` is the computer IP
        ```bash
        en
        conf t
        ip route 10.0.41.10 255.255.255.255 e0/0
        end
        copy run start
        ```

        ```bash
        en
        conf t
        ip route 10.0.41.10 255.255.255.255 10.0.24.4
        end
        copy run start
        ```

    - Task 2: Setup static routing to ensure R1 traffic will take another path through R3 to PC1 during outage
        - Answer: Do these on R1, then R3
        ```bash
        en
        conf t
        ip route 10.0.41.10 255.255.255.255 e0/1 2
        end
        copy run start
        ```
        - The extra 2 at the end refers to AD = 2. Also this is the primary route

        - Answer: Do these on R1, then R3
        ```bash
        en
        conf t
        ip route 10.0.41.10 255.255.255.255 10.0.34.4
        end
        copy run start
        ```

    - Task 3: Setup default routes on R1 and R3 to internet while minimizing hops
        - Answer: Do these on R1, then R3
        ```bash
        en
        conf t
        ip route 0.0.0.0 0.0.0.0 e0/1
        end
        copy run start
        ```

        ```bash
        en
        conf t
        ip route 0.0.0.0 0.0.0.0 209.165.201.1
        end
        copy run start
        ```