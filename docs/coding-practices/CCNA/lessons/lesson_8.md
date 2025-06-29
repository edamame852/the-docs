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

2. MC : Which port plays OSPF ?
- Check with `sh run` idk 

3. Pratical exam: Need to config and verify OSPF 

4.  MC might test diagram page 3... if I have the following config, then which IPs will participate OSPF ?
    - 
    ```bash
    en
    conf t
    router ospf 1
    network 192.168.0.0 0.0.0.63 area 0
    ```
    - Let's look at the break down
        - IP in decimal is              192.168.0.0
        - IP in binary is               11000000.10101000.00000000.00000000
        - Wildcard mask in decimal      0.0.0.63
        - Wildcard mask in binary       00000000.00000000.00000000.00111111
        - Recall: 0 (means outcome cannot change), 1 (means outcome can change)
        - Hence the outcome is: 11000000.10101000.00000000.00xxxxxx. Where x is all variables
            - Min value: 11000000.10101000.00000000.00(000000) = 192.168.0.0
            - Max value: 11000000.10101000.00000000.00(111111) = 192.168.0.63
    - Hence these IP 192.168.0.0 - 192.168.0.63 will participate in OSPF

5. What is consider a good AD (Administrative Distance)?
    - Ans: The lower the AD, the more likely it'll get picked

6. MC: Quite a lot of questions on topics like InterVLAN routing ! (aka: router-on-a-stick)


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
- 
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
- 
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
- 
```bash
conf t
router ospf 1
network 192.168.1.0 0.0.0.255 area 0
network 172.16.0.0 0.0.255.255 area 0

```
- Note 1: ospf # must specify a number, but this number can be user defined/ random
- Note 2: Defining g0/1 so it can broadcast to other networks
- The end goal is this: ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_3.jpg)
- Code explaination:
    - `router ospf 1` = turns on ospf w/ process number 1 (For CISCO IOS the range must be 1-65535 and must be unqiue w/in internal router)
    - `network 192.168.1.0 0.0.0.255 area 0` does 3 things
        - Firstly, Router 2's int of g0/0 w/ IP "192.168.1.x" allow to send + receive OSPF routes + data (地圖碎片) 
        - Secondly, Router 2 can propagate (aka 宣傳) routes DIRECTLY connected by router 2's int with IP of "192.168.1.x"
        - Thirdly, Router 2's int, the IP network of "192.168.1.x" is defined under **OSPF area 0** (Typically single area, you won't have other areas to choose from) 

- Time to configure Route 1, using wildcard mask
- 
```bash
en
conf t
router ospf 1
network 10.0.0.0 0.255.255.255 area 0
network 192.168.1.0 0.0.0.255 area 0
end
```

- Verify Route 1 is indeed picking up the OSPF route via `sh ip route` & `ping 172.16.0.2` from Router 1
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

        10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
    C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/1
    L       10.0.0.1/8 is directly subnetted, GigabitEthernet0/1
    O   172.16.0.0/16 [110/2] via 192.168.1.2, 00:50:00, GigabitEthernet0/0
        192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C       192.168.1.0/24 is directly subnetted, GigabitEthernet0/0
    L       192.168.1.1/32 is directly subnetted, GigabitEthernet0/0

```
- Explanation of the summary:
    - `O` = source of the route is OSPF
    - `[110/2]` = AD (Administrative Distance) is 110 since OSPF Route and 2 = OSPF Route Metric
        - Recall the math... in [Section-10.3.2](../lesson_7/#1032-ospf-ad--metric-ie-cost)
- Ping will also work :D (Router 1 pinging `172.16.0.2`)

- Verify Router 1 with `sh ip ospf int g0/0`, showing OSPF Router IP, hello + dead interval, netwrok type, DR/BDR and OSPF Priority 
    - `State BDR`
    ```bash
    GigabitEthernet0/0 is up, line protocol is up
        Internet Address 192.168.1.1/24, Area 0, Attached via Netwro kStatement
        Process ID 1, Router ID 191.168.1.1 Network Type BROADCAST, Cost: 1
        Topology-MTID       Cost        Disabled        Shutdown        Topology Name
            0                 1             no              no              Base
        Transmit Delay is 1 sec, State BDR, Priority 1
        Desinated Router (ID) 192.168.1.2, Interface Address 192.168.1.2
        Backup Designated Router (ID) 192.168.1.1, Interface Address 192.168.1.1
        Timer intervals configured, Hello 10, Dead 40, Wait 40, Retransmit 5
            oob-resync timeout 40
            Hello due in 00:00:02
        Supports Link-local SIgnaling (LLS)
        Cisco NSF helper support enabled
        IETF NSF helper support enabled
        Index 1/2/2, flood queue length 0
        Next 0x0(0)/0x0(0)/0x0(0)
        Last flood scan length 1, maximum is 2
        Last flood scan time is 0 msec, maximum is 0 msec
        Neighbor Count is 1, Adjacent neighbor count is 1
            Adjacent with neighbor 192.168.1.2 (Designated Router)
        Suppress hello for 0 neighbor(s)  
    ```
- Further Verification for Router 1: `sh ip ospf neighbor`
    - Router 1 has neighbor 192.168.1.2 which is FULL state. 192.168.1.2 is DR.
    - 
    ```bash
    Neighbor ID     Pri     State       Dead Time       Address         Interface
    192.168.1.2     1       FULL/DR     00:00:31        192.168.1.2     GigabitEthernet0/0
    ```
    - Recall to the idea of [Fullstate](../lesson_7/#1035b-configuring-interface-priority)

- Further Verification for Router 2: `sh ip ospf neighbor`
    - Router 2
    - 
    ```bash
        Neighbor ID     Pri     State       Dead Time       Address         Interface
        192.168.1.1     1       FULL/BDR    00:00:31        192.168.1.1     GigabitEthernet0/0
    ```

- Verify Router 2 with `sh ip ospf int g0/0`, showing OSPF Router IP, hello + dead interval, netwrok type, DR/BDR and OSPF Priority 
    - `State DR`
    - 
    ```bash
        GigabitEthernet0/0 is up, line protocol is up
            Internet Address 192.168.1.2/24, Area 0, Attached via Netwro kStatement
            Process ID 1, Router ID 191.168.1.2 Network Type BROADCAST, Cost: 1
            Topology-MTID       Cost        Disabled        Shutdown        Topology Name
                0                 1             no              no              Base
            Transmit Delay is 1 sec, State DR, Priority 1
            Desinated Router (ID) 192.168.1.2, Interface Address 192.168.1.2
            Backup Designated Router (ID) 192.168.1.1, Interface Address 192.168.1.1
            Timer intervals configured, Hello 10, Dead 40, Wait 40, Retransmit 5
                oob-resync timeout 40
                Hello due in 00:00:03
            Supports Link-local SIgnaling (LLS)
            Cisco NSF helper support enabled
            IETF NSF helper support enabled
            Index 1/1/1, flood queue length 0
            Next 0x0(0)/0x0(0)/0x0(0)
            Last flood scan length 1, maximum is 2
            Last flood scan time is 0 msec, maximum is 0 msec
            Neighbor Count is 1, Adjacent neighbor count is 1
                Adjacent with neighbor 192.168.1.1 (Backup Designated Router)
            Suppress hello for 0 neighbor(s)  
    ```

## 10.5 Configuring OSPF (point-to-point) on Cisco Routers

Topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_4.jpg)

- Rotuer 1 setup
- 
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

- Router 2 setup
- 
```bash
en
conf t
hostname Router2

int g0/0
ip address 192.168.1.2 255.255.255.0
no shut

int g0/1
ip address 172.16.0.2 255.255.0.0
no shut

end
```

- Setup Router 1 point to point.
- Note: point to point is not default, needs manual setup
- 
```bash
conf t
int g0/0
ip ospf network point-to-point
end
```

- Setup Router 2 point to point. Same as Router 1.
- Note: point to point is not default, needs manual setup
- 
```bash
conf t
int g0/0
ip ospf network point-to-point
end
```

- Router 1: No different from setting up broadcast OSPF
- 
```bash
conf t
router ospf 1
network 10.0.0.0 0.255.255.255 area 0
network 192.168.1.0 0.0.0.255 area 0
end
```

- Router 2: No different from setting up broadcast OSPF
- 
```bash
conf t
router ospf 1
network 192.168.1.0 0.0.0.255 area 0
network 171.16.0.0 0.0.255.255 area 0
end
```

- Okay time to perform a sanity check
    - Note: `sh ip route` doesn't show OSPF. dead interval, BDR ...... much rather we use `sh ip ospf int g0/0` or `sh ip ospf neighbor`

    - Sanity Check verification on Router 1: `sh ip route` + `ping 172.16.0.2`
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

            10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
        C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/1
        L       10.0.0.1/8 is directly subnetted, GigabitEthernet0/1
        O   172.16.0.0/16 [110/2] via 192.168.1.2, 00:00:27, GigabitEthernet0/0
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
        C       192.168.1.0/24 is directly subnetted, GigabitEthernet0/0
        L       192.168.1.1/32 is directly subnetted, GigabitEthernet0/0
        ```

    - `sh ip ospf int g0/0` point-to-point. As you see, there's nothing in the list
        - 
        ```bash
        GigabitEthernet0/0 is up, line protocol is up
            Internet Address 192.168.1.1, Area 0, Attached vai Network Statement 
            Process ID 1, Router ID 192.168.1.1, Network Type POINT_TO_POINT, Cost: 1
            Topology-MTID       Cost        Disabled        Shutdown        Topology Name
        ```

    - `sh ip ospf neighbor` no DR and BDR. Note: It's full state, so no DR/ BDR!!
        - 
        ```bash
        Neighbor ID     Pri     State       Dead Time       Address         Interface
        192.168.1.2     0       FULL/-      00:00:37        192.168.1.2     GigabitEthernet0/0
        ```

- Clean up ! `clear ip ospf processes` to reload and refresh into new configs
- Remark: to enable OSPF on the int ports you can try `ip ospf 1 area 0`
    - `router ospf 1` and `int g0/1` are the same
    - Let's try ways to enable OSPF on an interface
        - Enabling with router ospf: 
            - 
            ```bash
            en
            conf t
            int g0/1
            ip address 10.0.0.1 255.0.0.0
            no shut
            exit

            router ospf 1
            network 10.0.0.0 0.255.255.255 area 0
            end
            ```
        - Enabling with interfaces:
            - 
            ```bash
            en
            conf t
            int g0/1
            ip address 10.0.0.1 255.0.0.0
            no shut
            exit

            int g0/1
            ip ospf 1 area 0
            end
            ```
    - Troubleshooting:
        - (1) First ping yourself
        - (2) Ping one's own default gateway
        - (3) Ping other's default gateway
        - (4) Ping other people's IP

## 10.6 Passive interfaces for OSPF and other routing protocols
- Intro:
    - Topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_5.jpg)
    - To disable routing updates on an **singular** interface = `no passive-interface g0/0` under router config mode.
    - To disable **all** interfaces = `passive-interface default` on global mode

## 10.7 Floating Static Route
- Format: `ip route <target gateway network> <wildcard mask of target gateway> <Next hop own int> <New AD Number>`
- Intro: Floating Static Route = special static route with customized AD that is NOT 1 (recall: the default AD is 1)
    - Command: `ip route 10.0.0.0 255.0.0.0 192.168.0.2 254`. `254` here is the new updated AD. Refer to page 141! Or refer to  [AD](../lesson_7/#1021-administrative-distance-ad)


## 10.8 Configuring Floating Static Route as backup route for OSPF

- Topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_ospf_6.jpg)
- Let's set it up... Note: No need to setup switch since we assume all the interface has the SAME VLAN !!!
    - Step 1a: Setup R1
        - 
        ```bash
        en
        conf t
        int g0/0
        ip address 192.168.1.1 255.255.255.0
        no shut
        end
        ```
    - Step 1b: Setup R2
        - 
        ```bash
        en
        conf t

        int g0/0
        ip address 192.168.1.2 255.255.255.0
        no shut
        end

        int g0/3
        ip address 172.16.0.2 255.255.0.0
        no shut
        end
        ```
    - Step 1c: Step R3
        - 
        ```bash
        en
        conf t
        
        int g0/0
        ip address 192.168.1.3 255.255.255.0
        no shut
        end        

        int g0/3
        ip address 172.16.0.3 255.255.0.0
        no shut
        end
        ```
    - Step 2: Enable OSPF on R1, R2, R3
        - Step 2a: Setup R1 via wildcard mask
            - 
            ```bash
            conf t
            router ospf 1
            network 192.16.1.0 0.0.0.255 area 0
            end
            ```
        - Step 2b: Setup R2 via wildcard mask
            - 
            ```bash
            conf t
            router ospf 1
            network 192.16.1.0 0.0.0.255 area 0
            network 172.16.0.0 0.0.255.255 area 0
            end
            ```
        - Er...we're not setting up R3

        - Step 3: Setup R1 with a static route. 
            - The format is: `ip route <target underlaying network> <normal mask for> <next hop in R3> <AD Number>`
            - 
            ```bash
            conf t
            ip route 172.16.0.0 255.255.0.0 192.168.1.3 254
            ```
        - Step 4: Verify AD and notice static route is hidden since it's using lowest AD. Check with `sh ip route` on R1.
            - Lowest AD right now is 110, from default setup.
            - Static route AD is 254, so it remains hidden
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

            O       172.16.0.0/16 [110/2] via 192.168.1.2, 00:01:19, GigabitEthernet0/0
                    192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
            C           192.168.11.0/24 is directly connected, GigabitEthernet0/0
            L           192.168.1.1/32 is directly connected, GigabitEthernet0/0
            ```
        - Step 5: Prioritize static route on R1 please, by shutting off OSPF all together, thus allowing static route 
            - 
            ```bash
            conf t
            route ospf 1
            shutdown
            end
            ```
        - Step 6: Verify again !!
            - Static route has cost of 0 (Note: BGP can also have cost of 0)
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

            S       172.16.0.0/16 [254/0] via 192.168.1.2, 00:01:19, GigabitEthernet0/0
                    192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
            C           192.168.11.0/24 is directly connected, GigabitEthernet0/0
            L           192.168.1.1/32 is directly connected, GigabitEthernet0/0
            ```

# Simulation
## SIMULATION 3: LAB
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
            - Recall: `ip route <destination gateway network> <network masking> <origin int ip next hop address>`
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

## SIMULATION 15: LAB
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

# Lab 4:

## Lab 4a: InterVLAN routing / Router-on-a-stick
- Topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_1.jpg)
- Step 1: Setup Sw1 (setup VLAN then setup trunk)
    - No need to create VLAN 1, since it's default. But neeed to create vlan 2

    ```bash
    en
    conf t

    vlan2

    int g0/3
    switchport mode access
    switchport access vlan 1

    int g1/1
    switchport mode access
    switchport access vlan2

    int g0/2
    switchport trunk encapsulation dot1q
    switchport mode trunk
    end
    ```
- Step 2: Setup R1. Reset g0/2 and setup sub interfaces
    - Some notes:
        - `no ip address` = Removing all IPs
        - `int g0/2.2` are entering sub-interfaces
    - 
    ```bash
    en
    conf t
    
    int g0/2
    no ip address
    no shutdown

    int g0/2.1
    encapsulation dot1q 1 native
    ip address 10.0.0.1 255.0.0.0
    no shutdown

    int g0/2.2
    encapsulation dot1q 2
    ip address 172.16.0.1 255.255.0.0
    no shutdown
    
    end
    ```

- Step 3: Setup R2. Setting up port and default gateway
    - 
    ```bash
    en
    conf t

    int g0/3
    ip address 10.0.0.100 255.0.0.0
    no shutdown
    exit

    ip route 0.0.0.0 0.0.0.0 10.0.0.1
    end
    ```

- Step 4: Setup Sw2
    - 
    ```bash
    en
    conf t

    ip routing

    int g1/1
    no switchport
    ip address 172.16.0.200 255.255.0.0
    no shutdown
    exit

    ip route 0.0.0.0 0.0.0.0 172.16.0.1
    end
    ```

- Step 5: Verify on R1 `sh ip route`, can also try pining `172.16.0.200`
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
            10.0.0.0/0 is variably subnetted, 2 subnets, 2 masks
    C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/2.1
    L       10.0.0.1/32 is directly subnetted, GigabitEthernet0/2.1
            172.16.0.0/16 is variably subnetted, 2 subnets, 2 masks
    C           172.16.0.0/16 is directly connected, GigabitEthernet0/2
    L           172.16.0.1/32 is directly connected, GigabitEthernet0/2

    ```

## Lab 4b: Setting up routing labs
- Back to the basics ~ Let's check the topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_2.jpg)

- Step 1: Setup R1
    - 
    ```bash
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
    ```bash
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

- Step 3: Ping from R1 to `192.168.1.2` FAILS cuz no routes have been set up yet


## Lab 4c: Static Routing (aka `S`)
- Using the same topology: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_2.jpg)

- Step 1: Setup Static Route for R1
    - Recall static route syntax... `ip route <destination gateway network> <network masking> <origin int ip next hop address>`
    - 
    ```bash
    en
    conf t
    ip route 172.16.0.0 255.255.0.0 192.168.1.2
    end
    ```
- Step 2: Verify with `sh ip route`
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
            10.0.0.0/0 is variably subnetted, 2 subnets, 2 masks
    C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/2.1
    L       10.0.0.1/32 is directly subnetted, GigabitEthernet0/2.1
    S       172.16.0.0/16 [1/0] via 192.168.1.2
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/2
    L           192.168.1.0/32 is directly connected, GigabitEthernet0/2
    ```
- Step 3: NOW you can ping haha `ping 172.16.0.2`

- Optional: Deleting static route with `no ip route 172.16.0.0 255.255.0.0 192.168.1.2`

## Lab 4d: Staic Default Routing (aka: `0.0.0.0`, also `S*`)
- Same topology again: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_2.jpg)
 Recall static default route syntax... `ip route 0.0.0.0 0.0.0.0 <origin int ip next hop address>`

- Step 1: Setup R1
    - 
    ```bash
    en
    conf t
    ip route 0.0.0.0 0.0.0.0 192.168.1.2
    ``` 

- Step 2: Verify and ping
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
    S*      0.0.0.0/16 [1/0] via 192.168.1.2
            10.0.0.0/0 is variably subnetted, 2 subnets, 2 masks
    C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/2.1
    L       10.0.0.1/32 is directly subnetted, GigabitEthernet0/2.1
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/2
    L           192.168.1.0/32 is directly connected, GigabitEthernet0/2
    ```

- Optional: Please remove the static default route `no ip route 0.0.0.0 0.0.0.0`

## Lab 4e: Static Host Route (Also `S` same as normal staic route but with `255.255.255.255`)

- Topology ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_2.jpg)

- Recall static route syntax... `ip route <destination ip> <32 bit network masking> <origin int ip next hop address>`

- Step 1: Setup R1
    - 
    ```bash
    en
    conf t
    ip route 172.16.0.2 255.255.255.255 192.168.1.2
    end
    ```
- Step 2: Verify and ping
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
            10.0.0.0/0 is variably subnetted, 2 subnets, 2 masks
    C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/2.1
    L       10.0.0.1/32 is directly subnetted, GigabitEthernet0/2.1
            172.16.0.0/32 is subnetted, 1 subnets
    S       172.16.0.2 [1/0] via 192.168.1.2
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
    C           192.168.1.0/24 is directly connected, GigabitEthernet0/2
    L           192.168.1.0/32 is directly connected, GigabitEthernet0/2
    ```
    - One difference I noticed is `172.16.0.0/32 is subnetted, 1 subnets` is only is static host route, not in normal static route

- Optional: Please remove the static default route `no ip route 172.16.0.2 255.255.255.255`


## Lab 4f: Configuring basic OSPFv2 Broadcast
- Topology with OSPF Area: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_3.jpg)

- Step 1: Setup R2's OSPF
    - 
    ```bash
    en
    conf t
    router ospf 1

    network 172.16.0.0 0.0.255.255 area 0
    network 192.168.1.0 0.0.0.255 area 0
    end
    ```

- Step 2: Setup R1's OSPF
    - 
    ```bash
    en
    conf t
    router ospf 1

    network 172.16.0.0 0.0.255.255 area 0
    network 192.168.1.0 0.0.0.255 area 0
    end
    ```

- Step 3: From R1, Verify with `sh ip route` / `ping 172.16.0.2` / `sh ip ospf int g0/0` / `sh ip ospf neighbor`
    - `sh ip ospf int g0/0` returns the following:
    -   
    ```bash
    GigabitEthernet0/0 is up, line protocol is up
        Internet Address 192.168.1.1/24, Area 0, Attached via Netwro kStatement
        Process ID 1, Router ID 191.168.1.1 Network Type BROADCAST, Cost: 1
        Topology-MTID       Cost        Disabled        Shutdown        Topology Name
            0                 1             no              no              Base
        Transmit Delay is 1 sec, State BDR, Priority 1
        Desinated Router (ID) 192.168.1.2, Interface Address 192.168.1.2
        Backup Designated Router (ID) 192.168.1.1, Interface Address 192.168.1.1
        Timer intervals configured, Hello 10, Dead 40, Wait 40, Retransmit 5
            oob-resync timeout 40
            Hello due in 00:00:03
        Supports Link-local SIgnaling (LLS)
        Cisco NSF helper support enabled
        IETF NSF helper support enabled
        Index 1/2/2, flood queue length 0
        Next 0x0(0)/0x0(0)/0x0(0)
        Last flood scan length 1, maximum is 2
        Last flood scan time is 0 msec, maximum is 0 msec
        Neighbor Count is 1, Adjacent neighbor count is 1
            Adjacent with neighbor 192.168.1.2  (Designated Router)
        Suppress hello for 0 neighbor(s)  

    ```

## Lab 4g: Configuring OSPFv2 point-to-point routing
- Topology with OSPF Area: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_3.jpg)

- Step 1: Setup R1 with resetting OSPF (ensuring no DR and BDR)
    - 
    ```bash
    en
    conf t
    int g0/0
    ip ospf network point-to-point
    end

    clear ip ospf process
    yes
    ```

- Step 2: Configure R2
    - 
    ```bash
    en
    conf t
    int g0/0
    ip ospf network point-to-point
    end

    clear ip ospf process
    yes
    ```

- Step 3: Verify with `sh ip ospf int g0/0`
    - Notice: `Router ID 1.1.1.1 Network Type POINT_TO_POINT`
    ```bash
    GigabitEthernet0/0 is up, line protocol is up
        Internet Address 192.168.1.1/24, Area 0, Attached via Netwro kStatement
        Process ID 1, Router ID 1.1.1.1 Network Type POINT_TO_POINT, Cost: 1
        Topology-MTID       Cost        Disabled        Shutdown        Topology Name
            0                 1             no              no              Base
        Transmit Delay is 1 sec, State BDR, Priority 1
        Desinated Router (ID) 192.168.1.2, Interface Address 192.168.1.2
        Backup Designated Router (ID) 192.168.1.1, Interface Address 192.168.1.1
        Timer intervals configured, Hello 10, Dead 40, Wait 40, Retransmit 5
            oob-resync timeout 40
            Hello due in 00:00:03
        Supports Link-local SIgnaling (LLS)
        Cisco NSF helper support enabled
        IETF NSF helper support enabled
        Index 1/2/2, flood queue length 0
        Next 0x0(0)/0x0(0)/0x0(0)
        Last flood scan length 1, maximum is 2
        Last flood scan time is 0 msec, maximum is 1 msec
        Neighbor Count is 1, Adjacent neighbor count is 1
            Adjacent with neighbor 2.2.2.2
        Suppress hello for 0 neighbor(s)  

    ```


## Lab 4h: Floating static Routing 
- Recall for floating static routing (`ip route <target gateway network> <wildcard mask of target gateway> <Next hop own int> <New AD Number>`)
- Topology with OSPF Area: ![](../../../../../assets/images/ccna/lesson8/lesson8_lab_3.jpg)

- Step 1: R1. Hence now OSPF is main, Static Route is floating
    - 
    ```bash
    en
    conf t
    ip route 172.16.0.0 255.255.0.0 192.168.1.2 111
    end
    ```
- Step 2: Verify with `sh ip route`. You should see `S`.
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

            10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
        C       10.0.0.0/8 is directly subnetted, GigabitEthernet0/1
        L       10.0.0.1/8 is directly subnetted, GigabitEthernet0/1
        S   172.16.0.0/16 [111/2] via 192.168.1.2
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
        C       192.168.1.0/24 is directly subnetted, GigabitEthernet0/0
        L       192.168.1.1/32 is directly subnetted, GigabitEthernet0/0

    ```