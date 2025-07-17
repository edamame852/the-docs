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
Lesson 9 - CCNA Fast Track (June, 2025). We left off at page 163. It ends at the top of pg 186.

# 0. CCNA Exam Questions
1. MC will test which summaruzation will best summarize 3 routes at the same time. Ans = Route Summization to cover multi routes
2. MC will provide you with multiple routes and ask you corresponding masks can cover all these routes (i.e. /8, /16, /24 ...)
3. MC can also ask you to bunch/ summarize 4 routes into 3 routes, grouping 2 

4. You will be tested on configuring BGP
5. You will be tested on identifying BGP numbers 
6. There is practical for ACL, which is to filter unwanted traffic

7. Some good techniques... if you see `$` in the cli, then there's more info in the summary!!

8. Please also note... ACL can be applied to interfaces... as well as **VLAN**!

9. You will be tested [Named Access List](./#117-named-access-list) praticals
10. You will be tested [Dynamic NAT](./#122-dynamic-nat-with-overload) pratical

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

## 10.11 EIGRP FD, RD/AD, Successor, Feasible Successor
- ![](../../../../../assets/images/ccna/lesson9/lesson9_eigrp_3.jpg)
- Background:
    - Numbers here are **EIGRP Metrics**
    - R3 gets the same network from R1 and R2
- Let's talk about a few terminologies:
    - 1 - Path Metric (PM): Cost (i.e. EIGRP Metric) to jump to backend network
        - For example:
            - Upper road: Next hop 192.168.13.1, PM is 256 + 256 = 512 (Wins, the lower the better)
            - Lower road: Next hop 192.168.23.2, PM is 512 + 256 = 768
    - 2 - Feasible Distance (FD): smallest Path Metric, hence it was the upper road
    - 3 - Advertised or Reported Distance (AD or RD): The cost of hopping over to the next neighbor (aka distance for R2 to backend network or R3 to backend network)
        - For example:
            - R2 next hop = 256
            - R3 next hop = 256
    - 4 - Feasible Successor (FS): It's kinda like a backup tbh
        - Rule of being an FS : AD/FD must be  < FD, if yes then it's an FS
        - Note: We can have more than 1 FS
    - 5 - Successor  
        - Rule of being a successor: Lowest Path Metric (aka FD)!
        - Example:
            - Hence, 192.168.13.1 is the successor since it is the FD

- How do we verify these PM, FD, AD/RD, FS, S... we can check with `sh ip eigrp topology` + `sh ip route`.
    - `sh ip eigrp topology`
        - The summary will be:
        - 
        ```text
            EIGRP-IPv4 Topology Table for AS(123)/ID(192.168.23.3)
            Codes: P - Passive, A - Active, U - Update, Q - Query, R - Reply,
                   r - reply Status, s - sia status

            P   192.168.23.0/24, 1 successors, FD is 512
                via Connected, GigabitEthernet0/3 
            P   192.168.12.0/24, 1 successors, FD is 512
                via 192.168.13.1 (512/256), GigabitEthernet0/2
                via 192.168.23.2 (768/256), GigabitEthernet0/3
            .
            .
            .
        ```
    - Meanwhile `sh ip route` will get you this
    - The summary will be:
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
                + - replicated route, % - next hop override, p - overrides from PfR
        
        D   192.168.12.0/24 [90/512] via 192.168.13.1, 00:22:38, GigabitEthernet0/2
            192.168.13.0/24 is variably subnetted 2 subnets, 2 masks
        C       192.168.13.0/24 is directly connected, GigabitEthernet0/2
        L        192.168.13.3/32 is directly connected, GigabitEthernet0/2
            192.168.23.0/24 is variably subnetted, 2 subnets, 2 masks
        C       192.168.23.0/24 is directly connected, GigabitEthernet0/3
        L       192.168.23.0/24 is directly connected, GigabitEthernet0/3
    ```

- `variance` command will reveal the route with he larger metric in the routing table
    - Note again: only the **smallest AD can enter the routing table**
    - Punch in these commands:
    - This commands means to show route that has metric smaller than (FD * 2 = 1024) will be shown
    - Since `768` is smaller than 1024, but bigger than 512, hence it shows up now but not before!
    ```text
        router eigrp 123
        variance 2
        end
    ```
    - Time to verify with `sh ip route`. You will see `[768]` now !
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
                + - replicated route, % - next hop override, p - overrides from PfR
        
        D   192.168.12.0/24 [90/768] via 192.168.23.2, 00:22:38, GigabitEthernet0/2
                            [90/512] via 192.168.13.1, 00:22:38, GigabitEthernet0/2
            192.168.13.0/24 is variably subnetted 2 subnets, 2 masks
        C       192.168.13.0/24 is directly connected, GigabitEthernet0/2
        L        192.168.13.3/32 is directly connected, GigabitEthernet0/2
            192.168.23.0/24 is variably subnetted, 2 subnets, 2 masks
        C       192.168.23.0/24 is directly connected, GigabitEthernet0/3
        L       192.168.23.0/24 is directly connected, GigabitEthernet0/3
    ```

## 10.12 BGP = Border Gateway Protocol 
- Background:
    - BGP is a routing protocol used for inter-domain routing within orgs/ ISPs.
    - Usually each orgs/ ISP has a unqiue Autonoumous System (AS) for number of identification
    - Hence, BGP allows routing different AS's, also known as Exterior Gateway Protocol (EGP)
    - But OSPF, EIGRP are considered as Interior Gateway Protocol(IGP)
    - Gist:
        - IGP = Intra-AS = Within the same AS
        - EGP = Inter-AS = Routing between diff AS
- Common AS in HK
    - HSBN = AS 4515

## 10.13 Basic configs of BGP
- Topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_bgp_1.jpg)
- Setup R1
    - 
    ```text
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

- Setup R2
    - 
    ```text
        en
        conf t
        hostname Router1

        int g0/0
        ip address 192.168.1.2 255.255.255.0
        no shut

        int g0/1
        ip address 172.16.0.2 255.255.0.0
        no shut

        end
    ```

- Setting up R1 for BGP. Turning on bgp with `router bgp 100`.
    - 
    ```text
        conf t
        router bgp 100
        neighbor 192.168.1.2 remote-as 200
        network 10.0.0.0 mask 255.0.0.0
    ```
    - Break down:
        - `router bgp 100` = startup BGP + setup router in AS 100
        - `nei 192.168.1.2 remote-as 200` = configure next hop (R2) as a neighbor with AS number of 200.
        - `network 10.0.0.0 mask 255.0.0.0` = Configure BGP announcing 10.0.0.0/8 as neighbor/peer. This network is from R1 (own self).

- Setting up R2 for BGP as well
    - 
    ```text
        conf t
        router bgp 200
        neighbor 192.168.1.1 remote-as 100
        network 176.16.0.0 mask 255.255.0.0
    ```
    - Break down:
        - `router bgp 100` = startup BGP + setup router in AS 200
        - `nei 192.168.1.2 remote-as 200` = configure next hop (R1) as a neighbor with AS number of 100.
        - `network 10.0.0.0 mask 255.0.0.0` = Configure BGP announcing 176.16.0.0/16 as neighbor/peer for propagation. This network is from R2 (own self).

- Verify with `sh ip route`, you can also `ping 172.16.0.2` (ping the real IP)
    - `B` here means `BGP` btw
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
                + - replicated route, % - next hop override, p - overrides from PfR
        
            10.0.0.0/8 is variably subnetted 2 subnets, 2 masks
        C       10.0.0.0/8 is directly connected, GigabitEthernet0/1
        L       10.0.0.1/8 is directly connected, GigabitEthernet0/1
        B   172.16.0.0/16 [20/0] via 192.168.1.2, 00:00:17
            192.168.1.0/24 is variably subnetted, 2 subnets, 2 masks
        C       192.168.1.0/24 is directly connected, GigabitEthernet0/0
        L       192.168.1.1/24 is directly connected, GigabitEthernet0/0
    ```
    - We will study what the `0` means in `[20/0]` in CCNP


# 11. Access Control Lists (ACL)

- Background:
    - By deafult, router routes data to other devices
    - To enhance routing security and reducing routing network traffic = **USE A FILTER**
    - Gist: ACL = filtering unwanted traffic

## 11.1 Rules fo ACL

- Command: `sh access list 1` to check what ACL rules are already present
- Important facts:
    - 1 ACL has 1 or more ACL rules
    - 1 ACL rule = a condition + an action 
    - Something like this ... topology ![](../../../../../assets/images/ccna/lesson9/lesson9_acl_1.jpg)
    - The rule conditions contain parameters, e.g. IP address, TCP/UDP port number..., if the parameters condition is matched -> action is executed. Packet is denied/ allowed :D
- Let's look at AL logic gate in action !
    - topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_acl_2.jpg)

## 11.2 IP Standed, extended ACL !

- 2 different ACL/ Access List:
    - (IP) Standard Access List = Simpler, fewer parameters (usually only Source IP address + IP wildcard mask)
    - (IP) Extended Access List = Complex, more params 
        - params can include...
            - TCP/IP protocol type (TCP, UDP, ICMP, IP, ... etc)
            - Source IP address and source IP wildcard mask
            - Source port number for TCP/UDP
            - Destination IP address & destination IP wildcard mask
            - Destination port number
            - etc...

## 11.3 Access List numbering
- Background:
    - The numbering can help determine the type, kind of access list
    - Typically speaking:
        - ACL number 1-99 = (IP) Standard Access List
        - ACL number 100-199 = (IP) Extended Access List

## 11.4 ACL for inbound + outbound data
- Uses of ACL = filter data flowing into/out of a specific direction
- Terminology:
    - In-bound data = data flowing from network into router
    - Out-bound data = data flowing from router out to network

## 11.5 Examples of configuring IP access lists

- Applying it in real life, goal is to block/allow traffic into R1 !

- Let's look at the topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_acl_3.jpg)

- Step 1: R1 setup
    - 
    ```text
        en
        conf t
        hostname R1

        int g0/0
        ip address 192.168.1.1 255.255.255.0
        no shut
    ```

- Step 2: R2 setup
    - 
    ```text
        en
        conf t
        hostname R2

        int g0/0
        ip address 192.168.1.2 255.255.255.0
        no shut
    ```

- Step 3: R1 setting up the first rule - to setup the deny thing
    - 
    ```text
        conf t
        access-list 100 deny tcp 0.0.0.0 255.255.255.255 192.168.1.1 0.0.0.0 eq 23
        end
    ```
    - Let's break it down
        - `access-list 100 deny tcp 0.0.0.0 255.255.255.255 192.168.1.1 0.0.0.0 eq 23`, let's break it down further
            - `access-list 100` = if ACL number is larger than 100, then it's IP Extended Access list
            - `deny tcp` = denying TCP protocol (it's important to note `telnet` = tcp port 23)
            - `0.0.0.0 255.255.255.255` = The source IP address and source IP wildcard mask = meaning ALL ADDRESSESSSS
            - `192.168.1.1 0.0.0.0` = The destination IP address and the destination IP wildcard mask = targeting only `192.168.1.1`
            - `eq 23` = This tag placed after the destination means destination port number 23 (port number for telnet server)

- Step 4: R1 setting up the second rule, allowing anything else!

    - 
    ```text
        en
        conf t
        access-list 100 permit ip any any
    ```
    - Let's break it down
        - `ip` means ALL TCP/IP protocol
        - `any` = is the same as `0.0.0.0 255.255.255.255` = any is the source IP address and source IP wildcard mask
        - `any` = is the same as `0.0.0.0 255.255.255.255` = any is the destination IP address and destination IP wildcard mask

- Step 5: Now the 2 rules are configured, time to activate them!
    - 
    ```text
        conf t
        int g0/0

        ip access-group 100 in

        end
    ```
    - `ip access-group 100 in` means ACL number 100 on int g0/0 will filter inbound data (works for VLAN too!)
    - BTW `in` means implementing the access group !
    - Note: ACL number is also found in L3 headers!

- Step 6: Attempt to send a telnet from R2 to R1
    - In R2 try `telnet 192.168.1.1`, it should fail as expected since the application of the access list 100 to intg0/0 is to filter inbound data

- Step 7: Let's check what rules and verify the 2 rules in R1, `sh access-list`
    - The summary should contain the 2 ACL rules we have set. Note the `(1 match)` means someone tried to attack this rule before
    - 
    ```text
        Extended IP Access list 100
            10 deny tcp any host 192.168.1.1 eq telnet (1 match)
            20 permit ip any any
    ``` 
    - IMPORTANT note: The order of these rules are VERY IMPORTANT, top one gets filtered first !! For example, if we switch the order, everything is allowed and nothing is blocked... GG 

- Step 8: We can also verify the ACL rules that is imposed on the interface directly through `sh ip int g0/0`
    - Summary table:
        - Note: Outbound has NO filter, Inbound is ACL and has 2 rules !
        ```text
            GigabitEthernet0/0 is up, line protocol is up
                Internet address is 192.168.1.1/24
                Broadcast address is 255.255.255.255
                Address determined by setup command
                MTU is 1500 bytes
                Helper address is not set
                Directed broadcast forwarding is disabled
                Outgoing access list is not set
                Inbound access list is 100
                Proxy ARP is enabled
        ```

- Step 9: `ping 192.168.1.1`, ping is not telnet so it is allowed through ACL list


## 11.6 Second Example for Data traffic filtering

- Topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_acl_4.jpg)

- Background of this topology:
    - We wish to filter going into Server A from host in the subnet of 192.168.2.0/26. We will setup 2 rules:
        - Rule 1: No ping !
        - Rule 2: Allowing other protocols through

- Step 1: `access-list 100 deny icmp 192.168.2.0 0.0.0.63 10.10.1.1 0.0.0.0 echo`
    - Note! `eq` is NOT Required before `echo`
    - Note! You can replace the last part `... 10.10.1.1 0.0.0.0 ... ` into `... host 0.0.0.0 ... `
    - Recall subnet mask vs wilcard mask
        - subnet mask: `/26` -> `11111111.11111111.11111111.11000000`
        - wildcard mask: inverted `/26` (Hence 32-26 so it's `/6` bits) `00000000.00000000.00000000.00111111` = `0.0.0.63`
- Step 2: `access-list 100 permit ip any any` = permitting other protocol!

## 11.7 Named Access List
- Background: Besides creating a numbered access list (100, 200...) you can create a **NAMED** one to see the ACL better :D
- `extended dropTelnet` = the new ACL group name
```text
    en
    conf t
    
    ip access-list extended dropTelnet

    deny tcp any any eq 23
    permit ip any any

    intg0/0
    ip access-group dropTelnet in
    end
```

# 12. NAT =  Network Address Translation

## 12.1 Public IP Address and Private IP Address
- Background:
    - For a computer host to communicate with other host, a public IP address is needed (of course, this is not free)

- Private IP Address ranges:
    - `10.0.0.0` - `10.255.255.255` (all IP that starts with `10.x.x.x` are private IP address)
    - `172.16.0.0` - `172.31.255.255`
    - `192.168.0.0` - `192.168.255.255` = Our usual private IP address
    - Note: Private IP can be used without internet!

- IANA = Internet Assigned Numbers Authority
    - In charge of Public IP and supplying BGP AS numbers!
    - Does NOT supply and apply IP address
    - Routers on the internet has no responsiblity to route data packets for private IP address

- Topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_nat_1.jpg)

## 12.2 Dynamic NAT with overload
- Background:
    - Dynamic NAT overload is good at bunching up 
    - Via public network, allowing a single IP to be shared by multiple devices (this involves port number translation). This is why Dynamic NAT is also known as **Port Address Translation(PAT)**

## 12.4 Configuration of Dynamic NAT with overloadding

- Topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_nat_2.jpg)

- Setup walkthrough:
    - Step 1: Properly setup R1
        - 
        ```text
            en
            conf t
            hostname R1

            int g0/2
            ip address 192.168.1.1 255.255.255.0
            no shut

            int g0/0
            ip address 210.17.166.28 255.255.255.0
            no shut

            end
        ```
    - Step 2: Properly setup R2
        - 
        ```text
            en
            conf t
            hostname R2

            int g0/0
            ip address 210.17.166.25 255.255.255.0
            no shut
            end
        ```

    - Step 3: Properly setup R3
        - Note: Currently no NAT configs, R3 with private IP can only access 192.168.1.1 but not the internet!
        - Currently: default gateway is pointing to 192.168.1.1
        - 
        ```text
            en
            conf t
            hostname R3

            int g0/2
            ip address 192.168.1.3 255.255.255.0
            no shut

            exit

            ip route 0.0.0.0 0.0.0.0 192.168.1.1
            
            end
        ```

    - Step 4: trying `ping`-ing in R3
     - 
     ```text
        ping 192.168.1.1
        !!!!!
        Success rate is 100 percent

        ping 210.17.166.25
        .....
        Success rate is 0 percent
     ```

    - Step 5: R1 activate Dynamic NAT on the int, first entering int g0/0 `ip nat outside` = connecting to outside network (i.e. internet)
    - Step 6: R1 activate Dynamic NAT on the int, first enter int g0/2 `ip nat inside` = connecting to inside network (i.e. private network where NAT clients are located)
    - Step 7: Do this on R1
        - 
        ```text
            access-list 100 permit ip 192.168.1.1 0.0.0.255 any
        ```
    - Step 8: Define which public IP can be included in NAT, The NAT pool name = public ip pool `ip nat pool public-ip-pool 210.17.166.28 210.17.166.28 netmask 255.255.255.0`
        - pool start ip: `210.17.166.28`
        - pool end IP public: `210.17.166.28`
        - Only 1 IP can play NAT
    - Step 9: Verify with `do sh run | inc ip nat`