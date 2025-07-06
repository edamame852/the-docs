---
title: lesson_9
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
Lesson 9 - CCNA Fast Track (June, 2025). We left off at page 163.

# 0. CCNA Exam Questions
1. MC will test which summaruzation will best summarize 3 routes at the same time. Ans = Route Summization to cover multi routes
2. MC will provide you with multiple routes and ask you corresponding masks can cover all these routes (i.e. /8, /16, /24 ...)
3. MC can also ask you to bunch/ summarize 4 routes into 3 routes, grouping 2 

# 10. Dynamic Roututing 
## 10.9 EIGRP = Enhanced Interior Gateway Routing Protocol (Dynamic)
- Intro:
    - EIGRP = Cicso proprietry dynamic routing protocol 
    - Default AD for EIGRP is 90, refer to this [AD-List](../lesson_7/#1021-administrative-distance-ad)

### 10.9.1 EIGRP AD and Metric (= Distance) & AS 
- EIGRP uses composite metric (Erog, EIGRP Metric = Bandwith + Delay)
- Let's revist some important conecepts between EIGRP vs OSPF, also refer to this [AD-list](../lesson_7/#1021-administrative-distance-ad)

| Feature                    | EIGRP                                              | OSPF                         |
|:--------------------------:|:--------------------------------------------------:|:----------------------------:|
| **Metric**                 | Composite metric (bandwidth + delay)                | Math formula: (100M/x) + (100M/y) |
| **Cisco only / Proprietary** | YES                                               | NO                           |
| **Default AD Value**       | 90                                                 | 110                          |

- AS = Autonomous Number, determined by network admin. Same AS numbers allow devices to communicate with each other.

### 10.9.2 Configuring EIGRP in Cisco IOS
- Topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_eigrp_1.jpg)
- Step 1: Setup R1
    - 
    ```text
        en
        conf t

        int g0/1
        ip address 10.0.0.1 255.0.0.0
        no shut

        int g0/0
        ip address 192.168.1.1 255.255.255.0
        no shut

        end
    ```

- Step 2: Setup R2
    - 
    ```text
        en
        conf t
        
        int g0/1
        ip address 172.16.0.2 255.255.0.0
        no shut

        int g0/0
        ip address 192.168.1.2 255.255.255.0
        no shut
        
        end
    ```

- Step 3: Set EIGRP R1 via `router eigrp 11`. Recall the syntax is `router eigrp <Autonomous system / AS >`
    - 
    ```text
        conf t
        router eigrp 11
        network 192.168.1.0 0.0.0.255
        network 10.0.0.0 0.255.255.255
        end
    ```
    - Couple of things we noticed:
        - Recall: Wildcard masks bits 1 means cannot change and 0 means we can change into any number!
        - IP `192.168.1.x`  for g0/0 to participate in EIGRP
        - Also setting up `10.0.0.0` network to propogate in EIGRP

- Step 4: Set EIGRP R2 via `router eigrp 11`
    - 
    ```text
        conf t
        router eigrp 11
        network 192.168.1.0 0.0.0.255
        network 172.16.0.0 0.0.255.255
        end
    ```

- Step 5: Verify R1 status with `sh ip route`. Dynamic Routing will be denoted as `D`.
    - 
    ```text
        Codes:  L - local, C - connected, s - static, R - RIP, M - mobile, B - BGP
                D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
                N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
                E1 - OSPF external type 1, E2 - OSPF external type 2
                i - IS-IS, su - IS-IS summary, L1 - IS-IS level 1, L2 - IS-IS level 2
                ia - IS-IS inter area, * - candidate default, U - per-user static route
                o - ODR, P - periodic downloaded static route, H - NHRP, l - LISP
                a - application route
                + - replicated route, % - next hop override, p - overrides from pfR

        Gateway of last resort is not set
                10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
        C           10.0.0.0/8 is directly connected, GigabitEthernet0/1
        L           10.0.0.0/32 is directly connected, GigabitEthernet0/1
        D       172.16.0.0/16 [90/3072] via 192.168.1.2, 00:02:06, GigabitEthernet0/0
                192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
        C           192.168.1.0/24 is directly connected, GigabitEthernet0/0
        L           192.168.1.1/32 is directly connected, GigabitEthernet0/0
    ```
    - Notice: `D` = Dynamic Routing as EIGRP. AD is 90, Metric Value is 3072

    - `ping 172.16.0.2` Will also work as we try to ping R2's back network

## 10.10 Route Summarization and Auto Summarization

### 10.10.1 Route Summarization
- Intro:
    - Aims to use one/few routes to cover multiple routes
    - 4 Routes:
        - `192.168.15.16/30` = (11000000.10101000.00001111.00010000/30)
        - `192.168.15.21/30` = (11000000.10101000.00001111.00010101/30)
        - `192.168.15.23/30` = (11000000.10101000.00001111.00010111/30)
        - `192.168.15.27/30` = (11000000.10101000.00001111.00011011/30)
    - After summarization:
        - `192.168.15.16/28` = (11000000.10101000.00001111.00010000/28) = (11000000.10101000.00001111.00010000/ 255.255.255.240)
    - Process of summarization:
        - Step 1: Turn all pre-summarized routes into binaries
        - Step 2: Sort them into host and network part (i.e. Those that have matching 0, 1 and those that have completely different 0, 1)
            - Since The common network bits among these IP addresses are 11000000.10101000.00001111.0001. This is a /28 network. One /28 network covers all 4 routes !
            - Since classful network type is `A` (due to >192) so the mask is default to be `/24` then we add `/4` for flexiblity
        - Step 3: Convert back to decimal. `192.168.15.16` with `/28` mask.
        - Step 4: Figuring out the partition
            - For a /28 subnet, there are 16 IP addresses (2^(32-28) = 16), but 2 addresses are reserved for network and broadcast addresses.
            - Network address: 192.168.15.16
            - Broadcast address: 192.168.15.31
            - Usable IP range: 192.168.15.17 to 192.168.15.30

- Side note: 
    - Performing summarization on AWS cloud has a limit of summarizing 100 routes since the max prefix is 100 routes.

### 10.10.2 Auto Summarization in EIGRP
- ![](../../../../../assets/images/ccna/lesson9/lesson9_eigrp_2.jpg)
- Recall the classful A (/8), B (/16), C (/24) network 
- `auto-summary` = to bunch up multiple network

## 10.11 EIGRP FD, RD/AD, Successor, Fesible Successor
- ![](../../../../../assets/images/ccna/lesson9/lesson9_eigrp_3.jpg)
