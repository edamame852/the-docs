---
title: lesson_2
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
2nd Lesson - CCNA Fast Track (May 16, 2025)

# 0. CCNA Exam Questions

# 4. Features in CISCO switches

## 4.2 Sapnning Tree protocols (STP)

- Data frame looping: Caused by broadcast storms when broadcasted frame is forwarded infinitely into an infinite loop, impacting bandwidth
    - Origin of infinite loop is caused by switch broadcasting frames...`host -> broadcast frame -> Switch A -> sent via all ports of Switch A -> Switch B`
- Redudant path: Set up for higher fault tolerance, since if one down can forward frame to another switch. Usual setup for this is with 2 switches and 2 hubs

- STP Overview:
    - Enterprise switches has STP and swtich loops are prevented
    - STP can block broadcast storms
    - STP is a layer 2 protocol that puts all ports into a forwarding/ blocking state as a way to prevent looping storm
    - By default: STP will block 1 path by default as a way to prevent storms
    - 2 differnt STP type/ variants:
        - Original STP (Defined as IEEE 802.1d)
            - Loop-free topology in network w/ redudant links
            - Speed: Slower
        - Rapid PVST+ (Rapid Per-VLAN Spanning tree) 
            - Speed: Faster in tacking STP events (converting blocking to forwarding states quickly)
            - Each VLAN is allowed to has it's own spanning tree design

- VERY VERY IMPORTANT STP Operations
    - CISCO switches use STP to talk to each other
    - STP Messages = BPDU (Bridge Protocol Data Units) which determines the port states

    - Determining Root Bridge, Root Port, Designated port !
        - Step 1: How to find Root Bridge? 
            - Method: Determined by lower Bridge ID (Bridge ID = Priority Value + MAC address). In total there are 2 steps 
                - Lowest priority value (default priority value = 32768)
                - Lowest MAC address value
            - Please locate Bridge ID with `sh version` or `sh spanning-tree` on previlaged level
            - The other bridge that's not root is regarded as non-root bridge
            - Example for determining the root bridge by priority values:
            - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_1.jpg)
            

        - Step 2: How to find the (already forwarding state) Root ports in the non-root brdiges
            - Method: There are 4 steps.
                - Lowest cumulative path cost towards the root bridge (1Gbps = 4 for short-mode STP/ 20,000 for short-mode STP)
                    - For example: 
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_2.jpg)
                    - Switch 1 DONE, Switch 3 still need further investigation
                - Lowest sender bridge ID (via `sh spanning-tree`)
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_3.jpg)
                    - still need further investigation !!
                - Lowest **port priority** by the received BPDU message from the sender bridge 
                - Lowest **port number** by the received BPDU message from the sender bridge 
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_4.jpg)

        - Step 3: How to find designated port (default as forwarding state) between segments!
            - If there are 6 segments, then there needs to be 6 desingated ports (?)
            - Method: There are 4 steps
                - If No BPDU Messages/ Spanning-tree message (i.e. STP Frames) is received in this port = Designated ports (e.g. PC, Printer... Since they don't since BPDU)  
                    - Like this: 
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_5.jpg)
                - The lowest cost to root bridge
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_6.jpg)
                    - At this port we are 4 out of 6 done!
                - The lowest bridge ID (again: Bridge ID = Priority Value + MAC Address)
                    - 5 out of 6 DONE ! 
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_7.jpg)
                - The lowest port ID ! (e.g. g1/19 vs g1/20 then g/19 wins!)
                    - Finished!!
                    - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_8.jpg)

        - Step 4: How to find Alterate port in a switch port? 
            - When the port is non root port nor designated port... BLOCK IT & Alternate port
            - Like so...
                - ![](../../../../../assets/images/ccna/lesson2/lesson_2_stp_9.jpg)

    - Summarizing RSTP switching ports
        - Fowarding root port
        - Fowarding Designated port
        - Blocking/discarding alternate port
        - Backup port (a special block port) (Rarely ask in CCNA, more in CCNP)
            - Will be put to discarding state hmmmm

### 4.2.x RSTP port state and the underlying logic

- Changing port roles from blocking to forwarding
    - Current setup
        - ![](../../../../../assets/images/ccna/lesson2/lesson_2_rstp_1.jpg) 
        
    - Assume the link from top of switch A is broken

    - The Alternate port reopens as forwarding and became the root port
        - It will look like this in the end
        - ![](../../../../../assets/images/ccna/lesson2/lesson_2_rstp_2.jpg) 
        - Which it went through the state of 
            - Discarding (BLK): Data frame is blocked
            - Learning (LRN): Data frame is blocked, but MAC address can be learned/built at this stage
            - Forwarding (FWD): Data frame is forwarded

### 4.2.y Configuring RSTP Switches!
- This is the target network diagram design (= the current topology)
- ![](../../../../../assets/images/ccna/lesson2/lesson_2_rstp_3.jpg)

- Open switch3 at privileged mode with `sh spanning-tree`, it shows general STP info and roles/ states of the ports in the swtich
    - ieee means it's the traditional rstp. Let's change it to Rapid PVST+
    ```bash
    VLAN0001
        Spanning tree enabled protocol ieee 
    ```
    - Perform the following commands, most importantly `spanning-tree mode rapid-pvst`
    - Repeat this process for other switches 1 and 2 please.
    ```bash
    en
    config t
    spanning-tree mode rapid-pvst
    end
    ```
- Please recall Switch 2 is elected Root bridge due to it's lowest Brdige ID (i.e. acutally, lowest MAC address :D)

- Let's check Switch 2's info with `sh spanning-tree`
```bash
VLAN0001
    Spanning tree enabled protocol rstp
Root ID     Priority 32769 (Default for VLAN is 32768)
            Address 5001.0004.0000
            This bridge is the root (sometimes this gets convered up in the exam)
            Hello Time ...
Bridge ID   Priority 32769
            Address 5001.0004.0000
            Hello Time ...
Interface
--------------------
.
.
.
```

- Since the Root ID and (Current) Bridge ID (i.e. BID) are the same, the switch we're looking at is the elected Root Bridge! 


- Let's check Switch 3 again: `sh spanning-tree`
```bash
VLAN0001
    Spanning tree enabled protocol rstp
Root ID     Priority 32769 (Default for VLAN is 32768)
            Address 5001.0004.0000
            Cost 4
            Port 7
            Hello Time ...
Bridge ID   Priority 32769
            Address 5001.0005.0000
            Hello Time ...
```
```
Interface       Role        Sts     Cost        Prio.Nbr        Type
-----------     ------      ----    -------    ---------        ------     
Gi0/0           Desg        FWD     4           128.1           p2p
Gi0/1           Desg        FWD     4           128.2           p2p
Gi0/2           Desg        FWD     4           128.3           p2p
Gi0/3           Desg        FWD     4           128.4           p2p
Gi1/0           Desg        FWD     4           128.5           p2p
Gi1/1           Desg        FWD     4           128.6           p2p
Gi1/2           Root        FWD     4           128.7           p2p
Gi1/3           Alth        BLK     4           128.8           p2p
```

- Notice the following:
    - g1/2 is the root port
    - g1/1 is not connected to any switch. hence desingated port since no BPDU messages and it's connected to PC
    - g1/3 is not root port nor designated port, hence it's an alternate port and is set to discarded state


- Let's check Switch 1:
```bash
VLAN0001
    Spanning tree enabled protocol rstp
Root ID     Priority 32769 (Default for VLAN is 32768)
            Address 5001.0004.0000
            Cost 4
            Port 3
            Hello Time ...
Bridge ID   Priority 32769
            Address 5001.0006.0000
            Hello Time ...
```
    
```
Interface       Role        Sts     Cost        Prio.Nbr        Type
-----------     ------      ----    -------    ---------        ------     
Gi0/0           Desg        FWD     4           128.1           p2p
Gi0/1           Altn        BLK     4           128.2           p2p
Gi0/2           Root        FWD     4           128.3           p2p
Gi0/3           Desg        FWD     4           128.4           p2p
```
- Notice the following:
    - g0/2 is the root port
    - g0/1 is not root port nor designated port, hence it's an alternate port and is set to discarded state

### 4.2.z Configuring ports into PortFast (PF) = Edge Ports!
- Meaning:  
    - Originally: Discarding State --> Learning State --> Forwarding state
    - Now: Discarding State ------directly----> Forwarding state
- Limitation:  
    - Only ports that are NOT connected to any switch/hub (i.e. comptuer, printer, any non-hub non switch thingy. Things without loops)
- How to configure ports into edge ports: `spanning-tree portfast`

- Diasters happens if portFast/edge ports are configured on ports that are connected to swtich/hubs...
    - **(temp) Broadcast storms**
    - However, if BPDU is received on any PF ports, it losses it's edge port feature and becomes normal port 


### 4.2.A Topology changes (TC)!
- TC Occurs when non-edge port becomes edge ports!
- RSTP logic during TC
    - Step 0: Assume we only have 2 switch, 2 ports with these connections
        - ![](../../../../../assets/images/ccna/lesson2/lesson_2_tc_1.jpg) 
    - Step 1: New connection is set, Switch 2 (Root Bridge) sends STP message for setting new connection
        - ![](../../../../../assets/images/ccna/lesson2/lesson_2_tc_2.jpg) 
    - Step 2: Root port and Desinated port is elected and verified
        - Switch 1 finds g1/2 is a superior port from BPDU messages
        - Switch 1 blocks g1/3 other non-edge ports
        - Switch 1 tells Switch 2, it agrees g1/2 is a designated port
        - ![](../../../../../assets/images/ccna/lesson2/lesson_2_tc_3.jpg)
    - Step 3: Block is lifted and put directly into forwarding state
        - ![](../../../../../assets/images/ccna/lesson2/lesson_2_tc_4.jpg)

- MAC Address Flushing = removing old records (applicable to all non-edge ports)

## 4.2.B Lab: Tuning RSTP

- Tune RSTP Practice 1: Configure port pirority and making the counter port as a (preferred) root port
    - Switch 3 `sh spanning-tree` g1/3 is an alterate port
    - Switch 2, promote to interface configuration mode! Switch 2's g1/3's Prio.Nbr becomes 64.8 `spanning-tree port-priority 64`
    - 
    ```bash
    en
    config t
    int g1/3 
    spanning-tree port-priority 64
    end
    ```
    - Check Switch 3 again `sh spanning-tree` g1/3 is Root port
    - In switch 3: g1/2 and g1/3 has swtiched roles (alterate <> root)
- Tune RSTP Practice 2: Configure Bridge ID pirority and making the current bridge into a root bridge
    - Swtich 1, set VLAN root root priority `spanning-tree vlan 1 root primary`. Swtich 1 is not the root yet.
    - 
    ```bash
    en
    config t
    int g1/3 
    spanning-tree vlan 1 root primary
    end
    ```
    - Switch 1 is now the root bridge!!
- Tune RSTP Practice 3: Configure Switch 3 to be the secondary root brdige
    - In swtich3
    - 
    ```bash
    en
    config t
    int g1/3 
    spanning-tree vlan 1 root secondary
    end
    ```
    - As shown, with `sh spanning-tree` swtich 1 is still the root brdige (Pirority Value 24576) and switch 3 is configured as a secondary root bridge (Pirority Value 28672)
- Tune RSTP Practice 4: Configure port into an edge port `spanning-tree portfast`
    - Assume we want to configure swtich 2's g1/1 & g0/2 as edge ports
    - 
    ```bash
    en
    config t
    int g1/1 
    spanning-tree portfast
    int g0/2
    spanning-tree portfast
    end
    ```
    - Type p2p is converted to p2p Edge
    > Note: Even if g0/2 is converted to Edge Port, since it keeps on getting BPDU messages from other swtiches, it will NEVER reach edge port status!!