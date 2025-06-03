---
title: lesson_7
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
7th Lesson - CCNA Fast Track (June 03, 2025). We left off at page 124.

# 0. CCNA Exam Questions

# 9 InterVLAN Routing 
# 9.2 InterVLAN Routing 

### 9.2.3 InterVLAN 3 - Router-on-a-stick

- High level understanding: 
    - Router-on-a-stick = a trunk link (between switch and router) carrying all sub-routed VLAN traffic!
    - Achieved by allowing the an interface port to get 802.1Q trunk, thus forming trunk link
    - For packets to leave a VLAN group, must do it through the default gateway 

- Pros and cons of Router-on-a-stick
    - Pro:
        - Suitable for classical equipments
        - No need multi-layer/L3 involvement, L2 is also okay
        - This method for sub-interfacing is over 20 years old lmao, very backwards compatiable
        - Non-cisco protocol 
    - Cons:
        - SPOF = Single point of failure; Due to us having only 1 trunk link
        - Data packet Traffic in trunk link

- Q: How to turn on sub-interfaces?
- A: You need 2 things:
    - set VLAN
    - set IP

#### 9.2.3.x VLAN 1 doesn't require setup cuz it's the default VLAN
- Current Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_ivlan1.jpg)
    - Step 1: Setup VLAN 2 on switch 1 (no need to setup VLAN 1)
        - Note: `no vlan 1` is impossible lmao
        - Note: `switchport mode access` means this port is NEVER trunk link
        - Note: `switchport trunk encapsulation dot1q` must come before switching to trunk mode! 
        - 
        ```bash
        en
        config t

        vlan 2

        int g1/1
        switchport mode access
        switchport access vlan 1

        int g0/2
        switchport mode access
        switchport access vlan 2

        int g0/0
        switchport trunk encapsulation dot1q
        switchport mode trunk

        end
        ```
 
    - Sanity check with `do sh vlan brief`or `sh vlan brief`

    - Step 2: Set up Router 3 (configure 802.1q trunk interface for VLAN 1 & VLAN 2)
        - Note: `encapsulation dot1q 1 native` is considered to be the sub-interfacing step and it's connected to VLAN 1 
        - In VLAN 2, we don't put native VLAN obviously
        - We don't put `no shut` for both VLAN 1 and VLAN 2, as we assume the main interface is no shut by default, others should be too
        ```bash
        en
        config t
        hostname Router3

        int g0/0
        no ip address
        no shut

        int g0/0.1
        encapsulation dot1q 1 native
        ip address 10.0.0.1 255.0.0.0

        int g0/0.2
        encapsulation dot1q 2
        ip address 172.16.0.1 255.255.0.0

        end
        ```
        - `no shut` = Physical interfaces for g0/0 needs to be `no shut`
        - `no ip address` = If there's any IP set on the physical interface, then IP needs to be removed with this
        - `int g0/0.1` = This creates sub-interface 1, and will enter sub-interface Config mode ("subif")
            - Note: By convention, we set the VLAN ID the same as our sub-interface #, it's better trust me.
        - `encapsulation dot1q 1 native` = native means native VLAN, all frames sent here has NO VLAN tag!
        - `encapsulation dot1q 2` = VLAN 2 is not the native VLAN, it's responsible for VLAN ID 2
        - `ip address 10.0.0.1 255.0.0.0` = configuring for the sub-interface

    - Step 3: Verify on Router 3 using `sh ip route`

    ```bash
        Codes:  I - IGRP derived, R - RIP derived, O - OSPF derived
                C - connected, S - static, E - EGP derived, B - BGP derived
                * - candidate default route, IA - OSPF inter area route
                E1 - OSPF external type 1 route, E2 - OSPF external type 2 route

        Gateway of last resort is not set
            10.0.0.0/8 is variably subnetted, 2 subnet, 2 masks
        C   10.0.0.0/8 is directly connected, GigabitEthernet1/1
        L   10.0.0.1/32 is directly connected, GigabitEthernet1/1

            172.16.0.0/16 is variably subnetted, 2 subnet, 2 masks
        C   172.16.0.0/16 is directly connected, GigabitEthernet0/2
        L   172.16.0.1/32 is directly connected, GigabitEthernet0/2
    ```
    - Note: LOOKS GOOD

    - Step 4: Setup Router 1 as well. Note: `0.0.0.0 0.0.0.0` is the default gateway

    ```bash
    en 
    config t
    hostname Router1

    int g0/0
    ip address 10.0.0.100 255.0.0.0
    no shut
    exit

    ip route 0.0.0.0 0.0.0.0 10.0.0.1
    end
    ``` 

    - Step 5: Setup Router 2 as well. Note: `0.0.0.0 0.0.0.0` is the default gateway

    ```bash
    en 
    config t
    hostname Router2

    int g0/2
    ip address 176.16.0.200 255.255.0.0
    no shut
    exit

    ip route 0.0.0.0 0.0.0.0 172.16.0.1
    end
    ```

    - Step 6: Let's ping for sanity checks ! Please ping it from Router 2
    ```bash
    ping 10.0.0.100
    ``` 
    Looking good! InterVLAN setup is up and running
    ```bash
    Sending 5, 100-byte ICMP Echos to 10.0.0.100, timeout is 2 seconds:
    !!!!!
    Success rate is 100% (5/5), round-trip min/avg/max = 3/4/6 ms
    ```


## 9.3 Static Routing Entries

### 9.3.1 Static Routing Introduction
- Intro:
    - Routing table contains only directly connected networks. Beyond that direct interface, it's not visable 
    - If we refer to this topology:

    - Let's look at Router 1 and Router 2's Routing table

