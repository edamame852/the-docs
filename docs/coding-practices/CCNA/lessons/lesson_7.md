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

2. On the exam we have [DR and BDR election](./#1035a-how-to-elect-dr) stuff, every other device is priority value = 0 
3. [Changing OSPF priority value on CCNA exam](./#1035b-configuring-interface-priority)

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
        - Hence the broadcast IP can go up to 63 -> `192.168.16.63/26`
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
### 9.3.g Handling exceptions if destination address is 1.1.1.1
- if we check it with `sh ip route 1.1.1.1`, we'll get an error for this `Network not in table` 
- We need to handle this with static default routes/ default routes
- What Franco mentioned:
    - We are forced to use the final trump card: default gateway address `0.0.0.0` (exhausting all host bits)


# 10 Dynamic Routing

## 10.1 Introduction
- Maintaining static routes in a large company with many routers and many networks... IMPOSSIBLE for network admins.

- Using dynamic routing = network admin can maintain routing tables for routers by using routing protocol (e.g. RIP, EIGRP, OSPF, etc...) to add/remove routing entries from ip routing tables AUTOMATICALLY

- Let's look at the topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_dynamic_1.jpg)
    - 1. 10.0.0.0/8 attempting to reach non-directly connected network
    - 2. 10.0.0.0/8 is about to do so via a directly connected interface (i.e. 192.168.1.1)
    - 3. Routing table automatically adds this entry !
    - 4. Similarly, 172.16.0.0 is also attempting to connect to 10.0.0.0
    - 5. 172.16.0.0 was able to do so via 192.168.1.2's interface !
    - 6. The logic `172.16.0.0/16 via 192.168.1.2` is auto added to the routing table
    - 7. So now, on both sides, 10.0.0.0 can properly reach 172.16.0.0
    - 8. and 172.16.0.0 can also reach 10.0.0.0 

### 10.1.1 Distance vector vs link state routing protocols = 2 Routing Protocols
- 1. Distance Vector (e.g. RIP, IGEP or EIGRP, ...)
    - Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_dv_1.jpg)
    - Core idea: The mechanism ot set up routing one-by-one
    - Distance Vector Routing Protocol = neighbor routers will continue routing and learning them into it's routing table

- 2. Link state routing protocols (e.g. OSPF, IS-IS, etc...)
    - Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_ls_1.jpg)
    - Core idea: Mapping out the router map, exchanging topology info and calculate and conclude
    - Each router calculates the best path to every network into the routing table

### 10.1.2 Hop Counts
- Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_hop_1.jpg)
- Hop Count = # of routers the data packet needs to pass through before arriving at destination
- Some routing protocols likes shortest hop counts, I'm talking about you `RIP`!


## 10.2 AD / Administrative distance & metric

### 10.2.1 Administrative distance (AD)
- Background:
    - Please memorize this table !!!!
    - Cisco router's AD = decides which routing protocol will be providing the route
- Table for AD routing values on some common protocols
| Name of Route Source    | Symbol used in Cisco `sh ip route` | Default AD Value | 
| ----------------------- | ---------------------------------- | ---------------- |
| Connected interface (direct)  | C                            |  0               |
| Static Route  | S                            |  1               |
| External BGP = eBGP  | B `will be discussed in CCNP`            |  20               |
| Internal EIGRP  |  D            |  90               |
| OSPF  | O            |  110               |
| IS-IS  | i            |  115               |
| RIP  | R            |  120               |
| External EIGRP  | D EX            |  170               |
| Internal BGP = iBGP  | B `will be discussed in CCNP`            |  200               |

- How to make use of this table ?
    - The network with the lowest AD value will enter the routing table and used for packet routing!
- Let's look at this idea in action:
    - Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_ad_1.jpg)
    - Due to the smallest AD distance, OSPF will triumph over RIP
    - The summary would be:
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

    O       10.0.0.0/0 [110/0] via 192.168.13.3, 00:01:16, GigabitEthernet0/2
            192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.12.0/24 is directly connected, GigabitEthernet0/2
    L           192.168.12.1/32 is directly connected, GigabitEthernet0/2

            192.168.13.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.13.0/24 is directly connected, GigabitEthernet0/2
    L           192.168.13.1/24 is directly connected, GigabitEthernet0/2
    ```
    - As you can see, `[110]` is referring to OSPF's AD score and it's used here !

    ### 10.2.2 Metric

    - Background:
        - If routes are in the same AD, then we determine using the lowest Metric value will enter into the routing table
        - Note: different routing protocols has different ways of calculating Metrics!
            - i.e. RIP metric = hop count
            - Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_metric_1.jpg)
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

            Gateway of last resort is not set

            O       10.0.0.0/0 [120/0] via 192.168.13.3, 00:01:16, GigabitEthernet0/2
                    192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
            C           192.168.12.0/24 is directly connected, GigabitEthernet0/2
            L           192.168.12.1/32 is directly connected, GigabitEthernet0/2

                    192.168.13.0/24 is variably subnetted, 2 subnets, 2 masks
            C           192.168.13.0/24 is directly connected, GigabitEthernet0/2
            L           192.168.13.1/24 is directly connected, GigabitEthernet0/2
            ```
            - So we see the metric is `[120]` means the one with the lowest hop count is chosen :D

    - Q: What happens if it has the same metric, same AD ? 
    - A; then the packet flow will use each route **alternatively**. Sharing the packet load = equal cost load-balancing or equal-cost multi-path (ECMP)!

        - Let's check out the topology:
            - ![](../../../../../assets/images/ccna/lesson7/lesson7_metric_2.jpg)
            - The summary would be:
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

            Gateway of last resort is not set

            R       10.0.0.0/0 [120/1] via 192.168.13.3, 00:01:16, GigabitEthernet0/2
                               [120/1] via 192.168.12.2, 00:00:24, GigabitEthernet0/0
                    192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
            C           192.168.12.0/24 is directly connected, GigabitEthernet0/2
            L           192.168.12.1/32 is directly connected, GigabitEthernet0/2

                    192.168.13.0/24 is variably subnetted, 2 subnets, 2 masks
            C           192.168.13.0/24 is directly connected, GigabitEthernet0/2
            L           192.168.13.1/24 is directly connected, GigabitEthernet0/2
            ```
            - As you can see, both `R` are being used here! So both routes are sharing the packet flow load!

## 10.3 OSPF = Open Shortest Path First

- Background:
    - OSPF = a link state dynamic routing protocol developed by IETF (i.e. the Internet Engineering Task Force).
    - OSPF supports [VLSM](../lesson_5/#56-vlsm--variable-length-subnet-mask)

### 10.3.1 Router ID
- Router ID = identify the source of routing protocol's packets of who sent it
- How does Router ID get chosen in Cisco Routers

- Picking the Router ID:
    - Step 1: `sh run` to check if there's any `router-id` pre-assigned value in the run config
    - Step 2: Router ID can be manually configured with `router-id <value>`. where `value` is random, but must be unique.
        - example:
        - 
        ```bash
        conf t
        hostname Router1
        ospf 1
        router-id 1.1.1.1
        end
        ```
        - `1.1.1.1` = this ip is the router ID, and it doesn't even need to be ping-able
    - Step 3: If router ID didn't exist in run config, then highest IP among all active loopback interfaces is elected as the Router ID
        - loopback interface = virtual interfaces that are created on the router (e.g. `int lo0` & `int lo1`)
        - Typically, loopback interface are more stable than physical interfaces
        - For example in the summary table...
            - 
            ```bash
            conf t
            
            int lo1
            ip address 172.255.255.254 255.255.255.255

            int lo2
            ip address 192.0.0.1 255.255.255.255
            
            end
            ```
            - `sh ip int brief` = to show all ip
            - 
            ```bash
            Interface               IP-address          OK?     Method      Status                  Protocol
            GigabitEthernet0/0      192.168.1.1         YES     manual      up                      up
            GigabitEthernet0/1      10.0.0.1            YES     manual      up                      up
            GigabitEthernet0/2      unassigned          YES     NVRAM       administratively down   up
            GigabitEthernet0/3      unassigned          YES     NVRAM       administratively down   up
            Loopback1               172.255.255.254     YES     manual      up                      up
            Loopback2               192.0.0.1           YES     manual      up                      up
            ```

    - Step 4: Let's sort out the highest IP (the non-loopback interfaces)
        - Note: please drop the loopback, since we're interested in active physical interfaces!
        - 
        ```bash
        Interface               IP-address          OK?     Method      Status                  Protocol
        GigabitEthernet0/0      192.168.1.1         YES     manual      up                      up
        GigabitEthernet0/1      10.0.0.1            YES     manual      up                      up
        GigabitEthernet0/2      unassigned          YES     NVRAM       administratively down   up
        GigabitEthernet0/3      unassigned          YES     NVRAM       administratively down   up
        ```

### 10.3.2 OSPF AD & Metric (i.e. Cost)
- Background:
    - Accorinding to [10.2.1](./#1021-administrative-distance-ad), the OSPF AD is 110
    - OSPF Metric = Cost, which is calculated based on bandwiths
- Exercise: Finding the OSPF Cost! :D
    - Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_ospf_1.jpg)
    - 3 steps to find the OSPF cost !
        - Step 1: Find all outgoing interfaces (i.e only factoring in `s0/0/0` & `g0/1`). Do not calculate `g0/0` please
        - Step 2: Vertify the bandwith values with `sh int s0/0/0` & `sh int g0/0`
            
            - We're interested in the `BW` value!

            - Summary of `sh int s0/0/0`
            - 
            ```bash
            Serial0/0/0 is up, line protocol is up
                Hardware is GT98K Serial
                Internet Access is 192.168.1.1/24
                MTU 1500 Bytes, BW 1544 Kbit/sec, DLY 2000 usec,
                    reliability 255/255, txload 1/255, rxload 1/255
            <ommitted>
            ```


            - Summary of `sh int g0/0`
            - 
            ```bash
            GiagbitEthernet0/1 is up, line protocol is up
                Hardware is GT98K Serial
                Internet Access is 192.168.1.1/24
                MTU 1500 Bytes, BW 1000000 Kbit/sec, DLY 10 usec,
                    reliability 255/255, txload 1/255, rxload 1/255
            <ommitted>
            ```

        - Step 3: Calculate the metric/ cost! But there's 2 rules to follow
            - Rule 1: 1st value is truncated to the nearest integer (basically rounded down)
            - Rule 2: 2nd value min is 1 (basically min(1,x))
            - The numerator is ALWAYS 100 Mb as the reference bandwith (i.e. **RoundDown(100M/x) + Min(1, 100M/y)**)
            - In our case:
                - x is 1.544M (= 1544Kbit/sec)
                - y is 1000M (= 1000000 Kbit/sec)
            - Hence the equation is 100M/1.544M + 100M/1000M = 64.766 + 0.1 = 64 + 1 = 65 **This is the OSPF Cost**
            - Note: One should consider changing the ref bandwidth to >1000M (instead of the 100Mb) to prevent all links >100M to have same cost of 1!

        - Step 4: Let's verify with `router ospf 1` to enter router interface

            - 
            ```bash
            conf t
            router ospf 1
            auto-cost reference-bandwidth ?
            ```

### 10.3.3 OSPF Area
- Note 1: We always just focuss on area 0 (a single area) for CCNA exams
- Note 2: Area = logical collection of OSPF networks, routers, links. With hundreds of routers = achieving convergence
- Note 3: Convergence happens when all routers have the same LDA in DB and all routing entries are recalculated (=Full State)

- Let's dig deep into the ospf DB `sh ip ospf database` to display OSPF link state DB
    - Summary returned: Don't worry too much about the details here, out syll in CCNA
    ```bash
                    OSPF Router with ID (192.168.1.1) (Process ID 1)
                        Router Link States (Area 0)
    Link ID         ADV Router          Age         Seq#            Checksum        Link Count
    192.168.1.1     192.168.1.1         215         0x8000002       0x00491F        2
    192.168.1.2     192.168.1.2         216         0x8000002       0x009A18        2
                        Net Link States (Area 0)
    Link ID         ADV Router          Age         Seq#            Checksum        
    192.168.1.2     192.168.1.2         216         0x8000001       0x00A2E6        
    ```

- Multi-area design (in CCNP) (aka: The hierarchical design) has some benefits: (Out syll as well)
    - 1. Faster convergence
    - 2. Less routing overhead (less downtime)
    - 3. Limitting network instability to single area
    - 4. Allows extensive control routing updates (passing from 1 area to another), non-multi area cannot filter

- In non-cisco specific OSPF, area 0 = backbone area for connecting other area. In normal setting, all ABRs should have link connecting to area 0

### 10.3.4 OSPF Adjacency or OSPF Neighbor Relationships
- 3 OSPF opertrations
    - 1. Neighbor Discover (Very Important)
    - 2. Link-state info exchange 
    - 3. Best-path calculation

- OSPF main neighbor tables with hello packets during router start up
    - Hello packets are sent to all OSPF enabled interfaces on every 10 sec intervals
    - If no hello packet is sent before dead interval is up (defualt it's 40 sec), OSPD neiighbor is considered dead and will be removed from the neighbor list
    - Set up hello interval and dead interval with these `ip ospf hello-interval ?` & `ip ospf dead-interval ?`
        - 
        ```bash
        conf t
        int g0/0

        ip ospf hello-interval ?
        ip ospf dead-interval ?
        ``` 

- Requirements of forming OSPF Adjacency, there are 4
    - 1 - Same OSPF Area ID
    - 2 - Same OSPF Hello Intervals
    - 3 - Same MTU = Maximum Transmission Unit, largest prootocl data unit (PDU) to communicate in single network layer transactions
    - 4 - Outsyll other itms to be discussed in CCNP!

- Good OSPF topology design
    - ![](../../../../../assets/images/ccna/lesson7/lesson7_ospf_2.jpg)

- Bad OSPF topology designs
    - 1,2,3 - are the following
    - ![](../../../../../assets/images/ccna/lesson7/lesson7_ospf_3.jpg)


### 10.3.5 OSPF Network Types (Point to Point Broadcast) & Designated Router (DR)
- Background:
    - OSPF has different network types to affect adjacency and OSPF interface behavior
    - CCNA will focus on 2 types of network types: **p2p (point to point)** & **broadcast**

#### 10.3.5.1 Point to Point
- Suitable Enviornment? Ans: Point to point env
- No concept of BDR & DR
- Default run point to point for OSPF serial interfaces
- Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_ospf_4.jpg)

#### 10.3.5.2 Broadcast
- Suitable Enviornment? Ans: multi-point / point to multipoint env
- Will elect and pick out BDR & DR.
- DR = Designated Router = Collect and redistribute LDA + other info
- BDR = Backup Designated Router = act as backup of DR
- Topology: ![](../../../../../assets/images/ccna/lesson7/lesson7_ospf_5.jpg)

#### 10.3.5.a How to elect DR
1. Highest OSPF interface priority default is 1, if set pirority = 0 then the device gives up on being DR/ BDR
2. Highest OSPF Router ID will be DR after priority values

> Note: By default: IP 224.0.0.5 is reserved for all OSPF devices (routers), excluding Computer
> Note: By default: IP 224.0.0.6 is reserved for all OSPF DR and BDR Devices

#### 10.3.5.b Configuring interface priority
- 
```bash
conf t
int g0/0
ip ospf priority ?
```
            