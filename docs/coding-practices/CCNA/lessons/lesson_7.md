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

1. MC will cover Routing Entries Matching orders, 2 Questions in the past, study [this topic](./lesson_7/#934-routing-entries-matching-order) well.
    - Distinguish between what is route and what is non-route 
        - Those with eng characters are routes lmao
        - We can count up the routes, in the example of pg.137 we have 7 routes in total. We include static route and default route !

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
    - If we refer to this topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_static1.jpg)

    - Let's look at Router 1 and Router 2's Routing table before any human intervention
        - Router 1 routing table:
         - 
        ```bash
            Network Destination         Gateway                 Interface
            ---------------------------------------------------------------
            192.168.1.0/24              Directly Connected      s0/0/0
            10.0.0.0/8                  Directly Connected      g0/0
        ```

        - Router 2 routing table:
        - 
        ```bash
            Network Destination         Gateway                 Interface
            ---------------------------------------------------------------
            192.168.1.0/24              Directly Connected      s0/0/0
            172.16.0.0/16               Directly Connected      g0/1
        ```
    - Issue: For networks that are NOT directly connected, and admin can manually add the routing entries ! For example...
        - Router 1 routing table:
        - 
        ```bash
            Network Destination         Gateway                 Interface
            ---------------------------------------------------------------
            192.168.1.0/24              Directly Connected      s0/0/0
            10.0.0.0/8                  Directly Connected      g0/0
            172.16.0.0                  192.168.1.2             s0/0/0
        ```

        - Router 2 routing table:
        - 
        ```bash
            Network Destination         Gateway                 Interface
            ---------------------------------------------------------------
            192.168.1.0/24              Directly Connected      s0/0/0
            172.16.0.0/16               Directly Connected      g0/1
            10.0.0.0/8                  192.168.1.1             s0/0/0
        ```

### 9.3.2 Configuring static route on Router1 (will setup host route too)

- Setup: Will include host route!
- Our topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_static2.jpg)

- Step 1: Setup Router 1
```bash
en
config t
hostname Router1

int g0/1
ip address 10.0.0.1 255.0.0.0
no shut

int g0/0
ip address 192.168.1.1 255.255.255.0
no shut

end
```

- Step 2: Setup Router 2
```bash
en
config t
hostname Router2

int g0/0
ip address 192.168.1.2 255.255.255.0
no shut

int g0/1
ip address 172.16.0.2 255.255.0.0
no shut

end
```

- Step 3: Router 1 `ping 172.16.0.2`, success rate is 0 !
    - Can also verify with `sh ip route`
    - Due to: In router 1 doesn't have 172.16.0.2 in it's routing table D:


- Step 4: Resolve the issue with adding a static route

    - Static Route format: `ip route <dest network> <subnet mask> then <gateway access> or <outgoing ip interface>`. FYI, IPv6 static route configs are similar.
    - 
    ```bash
        config t
        ip route 172.16.0.2 255.255.0.0 192.168.1.2
    ```
#### 9.3.2.x Network Route ... Static Route :D
Note: 192.168.1.2 is set as static route here, it's also known as a network route !

- Step 5: Sanity Check on Router 1 with `sh ip route`
    - The summary returned
    ```bash
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
    S       172.16.0.0/16 [1/0] via 192.168.1.2
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/1
    L           192.168.1.1/32 is directly connected, GigabitEthernet0/1
    ```
    - Note: "S" meaning a static route for the network 172.16.0.0/16

- Step 6: `ping 172.16.0.2`. The packets are now well received
```bash
Sending 5, 100-byte ICMP Echos to 172.16.0.2, timeout is 2 seconds:
!!!!!
Success rate is 100% (5/5), round-trip min/avg/max = 1/2/4 ms
```

- Step 7: Removing the static route with `conf t` & `no ip route 172.16.0.0 255.255.0.0 192.168.1.2`
- Step 8: On Router1, set up another ip route
    - 
    ```bash
    conf t
    ip route 172.16.0.2 255.255.255.255 192.168.1.2
    end
    ```
    - Logic behind the 2 parameters, let's look at the topology again: ![](../../../../../assets/images/ccna/lesson7/lesson7_static2.jpg)
        - `172.16.0.2` since that's our target destination address (next to Router 2)
        - `255.255.255.255` is the host route, we're using host route, since there's only 1 IP in the network 172.16.0.0
        - `192.168.1.2` is the gateway address, it's the interface on Router1 that is closest shoot out interface from Router1
- Step 9: Verify and sanity check:
     - The summary returned
    ```bash
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
            172.16.0.0/32 is subnetted, 1 subnets
    S           172.16.0.2 [1/0] via 192.168.1.2
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/1
    L           192.168.1.1/32 is directly connected, GigabitEthernet0/1
    ```
#### 9.3.2.y : Host Route
- Note:
    - A static route/ host route (`/32`) for network 172.16.0.2/32 can now found & now marked with "S" as static. Host Route is used since the route only has 1 IP address here. 
    - Host Route can only access 1 IP

- Step 9: `ping` the target. 
    - 
    ```bash
    Sending 5, 100-byte ICMP Echos to 172.16.0.2, timeout is 2 seconds:
    !!!!!
    Success rate is 100% (5/5), round-trip min/avg/max = 1/2/4 ms
    ```
    - ping is working now

- Alternative:
    - `ip route 172.16.0.2 255.255.255.255 g0/0`
    - `ip route 172.16.0.2 255.255.255.255 192.168.1.2`
    - Idea: now Router 1 can go to 172.16.0.2/32 via it's own Router1's interface g0/0

### 9.3.3 Static Default Route

- Background:
    - If we have many static routes to set up for different networks
    - Better to use a **single default route** (1 gateway for all other networks)
    - Please note default route is also known as **gateway of last resort**

- Note: we're using the same topology as 9.3.1's static route
    - Topology:![](../../../../../assets/images/ccna/lesson7/lesson7_static2.jpg)

- Step 1: Configure Router1 on int g0/1 and int g0/0
    ```bash
    en
    conf t
    hostname Route1

    int g0/1
    ip address 10.0.0.1 255.0.0.0.0
    no shut

    ip g0/0
    ip 192.168.1.1 255.255.255.0
    no shut

    end
    copy run start
    ```
- Step 2: Configure Router2 on int g0/0 and int g0/1

    ```bash
    en
    conf t
    hostname Router2

    int g0/0
    ip 192.168.1.2 255.255.255.0
    no shut

    int g0/1
    ip 172.16.0.0.2 255.255.0.0
    no shut

    end
    copy config run
    ```

- Step 3: Back to Router 1! Let's set up that default route!

    - 
    ```bash
    conf t
    ip route 0.0.0.0 0.0.0.0 192.168.1.2
    end
    copy run start
    ```
    - Explanation:
        - the default route is : `0.0.0.0`
        - the default gateway in Router 1 is set for int g0/0 on Router1's side
        - You almost only do this when your routing table is empty

- Step 4: Verify Router1's ip table with `sh ip route` 
    - The default route will show up as `S*`
        - Where `S` = static route
        - Where `*` = default route
    - The return info of `sh ip route`.
    - Please note that the default route info is shown here as `S*`
    ```bash
    Codes:  L - local, C - connected, s - static, R - RIP, M - mobile, B - BGP
            D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
            N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
            E1 - OSPF external type 1, E2 - OSPF external type 2
            i - IS-IS, su - IS-IS summary, L1 - IS-IS level 1, L2 - IS-IS level 2
            ia - IS-IS inter area, * - candidate default, U - per-user static route
            o - ODR, P - periodic downloaded static route, H - NHRP, l - LISP
            a - application route
            + - replicated route, % - next hop override, p - overrides from pfR

    Gateway of last resort is 102.168.1.2 to network 0.0.0.0

    Gateway of last resort is not set
    S*      0.0.0.0/0 [1/0] via 192.168.1.2
            10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
    C           10.0.0.0/8 is directly connected, GigabitEthernet0/1
    L           10.0.0.0/32 is directly connected, GigabitEthernet0/1

            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/1
    L           192.168.1.1/32 is directly connected, GigabitEthernet0/1
    ```
- Step 5: Try to ping the ip on Router 2's side which is 172.16.0.2 with `ping 172.16.0.2`
    - Returned on the console we have:
    - Packets are well received
    ```bash
    Sending 5, 100-byte ICMP Echos to 172.16.0.2, timeout is 2 seconds:
    !!!!!
    Success rate is 100% (5/5), round-trip min/avg/max = 1/2/4 ms
    ```

 ### 9.3.4 Routing Entries Matching Order
 - Background:
    - Please note this topic is related to **longest prefix match**
    - Essentially, we are sorting the importance of these 7 routes !

- Step 1 : Assume we hae these 7 routes in the ip routing table
    - 
    ```bash
    Codes:  L - local, C - connected, s - static, R - RIP, M - mobile, B - BGP
            D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
            N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
            E1 - OSPF external type 1, E2 - OSPF external type 2
            i - IS-IS, su - IS-IS summary, L1 - IS-IS level 1, L2 - IS-IS level 2
            ia - IS-IS inter area, * - candidate default, U - per-user static route
            o - ODR, P - periodic downloaded static route, H - NHRP, l - LISP
            a - application route
            + - replicated route, % - next hop override, p - overrides from pfR

    Gateway of last resort is 102.168.1.2 to network 0.0.0.0

    Gateway of last resort is not set
    S*      0.0.0.0/0 [1/0] via 192.168.1.2
            10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
    C           10.0.0.0/8 is directly connected, GigabitEthernet0/1
    L           10.0.0.0/32 is directly connected, GigabitEthernet0/1

            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/1
    L           192.168.1.1/32 is directly connected, GigabitEthernet0/1

            192.168.16.0/24 is variably subnetted, 2 subnets, 2 masks
    S           192.168.16.0/26 [1/0] via 192.168.1.3
    S           192.168.16.0/27 [1/0] via 192.168.1.2
    ```

- 
```
S*      0.0.0.0/0 [1/0] via 192.168.1.2
C           10.0.0.0/8 is directly connected, GigabitEthernet0/1
L           10.0.0.0/32 is directly connected, GigabitEthernet0/1
C           192.168.1.0/24 is directly connected, GigabitEthernet0/1
L           192.168.1.1/32 is directly connected, GigabitEthernet0/1
S           192.168.16.0/26 [1/0] via 192.168.1.3
S           192.168.16.0/27 [1/0] via 192.168.1.2
```
    
- Step 2: Sorting most specific sub-mask to lowest, aka, /32 is the most specific, /1 is the least specific
    - Let's sort by `/` subnet mask's size. Note the `192` and `10` has no difference in using this sort method
    ```
    L           192.168.1.1/32 is directly connected, GigabitEthernet0/1
    L           10.0.0.0/32 is directly connected, GigabitEthernet0/1
    S           192.168.16.0/27 [1/0] via 192.168.1.2
    S           192.168.16.0/26 [1/0] via 192.168.1.3
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/1
    C           10.0.0.0/8 is directly connected, GigabitEthernet0/1
    S*          0.0.0.0/0 [1/0] via 192.168.1.2
    ```

- A: we would assume our destination address is 192.168.16.3

- Step 3a: Finding the longest prefix route by removing certain routes from this list. Assume our designation is 192.168.16.3 please
    - the 2 L's will be dropped as they only go to 1 place (i.e. host route -> one IP). It cannot go to 192.168.16.3.
    - Let's decide whether the 3rd one on th list will stay `192.168.16.0/27 [1/0] via 192.168.1.2`
        - Step 1: Find the network ID and broadcast network
            - network id: `192.168.16.0/27` -> 32 - 27 = 5 host bits -> Max range is `00011111` = 16+8+4+2+1 = 31, ergo the broadcast range can go up to that.
            - broadcast network `192.168.16.31/27`
            - meaning the full network range is `192.168.16.0` ~ `192.168.16.31`
        - Step 2: Conclusion:
            - Meaning `192.168.16.3` is in range!

- Step 4a: Feel free to do sanity check with `sh ip route 192.168.16.3`
    - 
    ```bash
    Routing entry for 192.168.16.0/27
        known via "static", distance 1, metric 0
        Routing Descriptor Blocks:
        * 192.168.1.2
            Route metric is 0, traffic share counter is 1
    ```


- B: we would assume our destination address is 192.168.16.50

- Step 3b: Finding the longest prefix route by removing certain routes from this list. Assume our destination is 192.168.16.50 please
    - the 2 L's will be dropped as they only go to 1 place (i.e. host route -> one IP). It cannot go to 192.168.16.50
    - The first S will also be dropped, since the mask `/27` doesn't reach until 192.168.16.50
    - What about the other S route is `192.168.16.0/26` via `192.168.1.3`
    - The available range for `192.168.16.0/26` is...
        - 26 network bits, so 32 - 26 = 6 host bits = 32 + 31 = 63!
        - Hence the braodcast IP can go up to 63 -> `192.168.16.63/26`
        - So Yes, this connection can reach 192.168.16.50, no issue

- Step 4: Let's verify this last IP with `sh ip route 192.168.16.50`
    - 
    ```bash
    Routing entry for 192.168.16.50
        known via "static", distance 1, metric 0
        Routing Descriptor Blocks:
        * 192.168.1.3
            Route metric is 0, traffic share counter is 1
    ```

##