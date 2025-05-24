---
title: lesson_3
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
3rd Lesson - CCNA Fast Track (May 20, 2025). We left off at page 43.

# 0. CCNA Exam Questions
1. How many default VLANs are in a normal switch ? 
> Ans: 5 (VLAN1, VLAN1002, VLAN1003, VLAN1004, VLAN1005), these cannot be deleted

2. What should one do when there are unused ports ? (2 steps)
> Ans: Those ports should be **shutdown** and assigned to an unused VLAN (we can create an unused VLAN). Else, cybersecurity risks.

3. During the CCNA practical exam, please **verify** after you **configure** !!  

4. MC will ask about Native VLAN mismatch, how do we tackle this issue?
> Ans: 2 answers, both works. Either **merge** (left and right native VLAN merges) or **spanning-tree block** blocking both VLANs together!

5. Need to learn to to check trunk links!
> Ans: using `switchport trunk encapsulation dot1q` & `switchport mode trunk` & `switchport trunk native vlan 1`

6. InterVLAN will be tested as MC! Q: Why do we need InterVLAN when we have VLAN 1 and VLAN 2?
> Because we can keep the 3 benefits of VLAN while maintaining VLAN 1 and VLAN 2 communication via L3 InterVLAN !

7. DTP stuff (Dynamic Trunk Protocol) will be tested in MC: DTP switchport modes...likely

8. Exam will cover lab on Ether Channel, bundling >=2 links into one big logical channel

9. 

# 4. Features in CISCO switches
## 4.3 Default VLAN

- Showing default vlan with `sh vlan`...
    - 
    ```bash
    VLAN    Name                Status      Ports
    -------------------------------------------------------------------------------
    1       default             active      Gi0/0, Gi0/1, Gi0/2, Gi0/3,
                                            Gi1/0, Gi1/1, Gi1/2, Gi1/3
    1002    fddi-default        act/unsup
    1003    token-ring-default  act/unsup
    1004    fddinet-default     act/unsup
    1005    trnet-default       act/unsup
    .
    .
    .
    ```
    - The 8 ports are all under VLAN 1.
    - The only usable VLAN is VLAN1 for now.

- VLAN has 2 different ranges:
    - VLAN 1-1005 = **Normal Range**
    - VLAN 1006-4094 = **Extended Range**

### 4.3.2 VLAN Configuration

- Practice 1: Creating VLAN 2 and assign g0/2 into VLAN 2!
    - Step 1: Create VLAN 2 on Switch 1 via `vlan 2` and takes you to VLAN COnfiguration mode and change name with `name Accounting`.
        - 
        ```bash
        en
        config t
        vlan 2
        name Accounting
        end
        ```
    - Step 2: Assign switch port g0/2 to VLAN2 via `int 0/2` = entering interface config mode and modify switch port setting and assign it to VLAN 2 with `switchport access vlan 2`.
        - 
        ```bash
        en
        config t
        int g0/2
        switchport access vlan 2
        end
        ```
    - Step 3: Verify with `sh vlan`! Done !
        - 
        ```bash
        VLAN    Name                Status      Ports
        -------------------------------------------------------------------------------
        1       default             active      Gi0/0, Gi0/1, Gi0/3,
                                                Gi1/0, Gi1/1, Gi1/2, Gi1/3
        2       Accounting          active      Gi0/2 <================================= NICEEEE
        1002    fddi-default        act/unsup   
        1003    token-ring-default  act/unsup
        1004    fddinet-default     act/unsup
        1005    trnet-default       act/unsup
        .
        .
        .
        ``` 

- Practice 2: Configuring multiple swtich ports? 
    - Ans: do these 2 things
        - Step 1: `int range g0/1-3` or `int range g0/1, g0/3`. These two expressions both works
        - Step 2: `switchport access vlan 2`


### 4.3.3 VLAN Trunk!! (VERY IMPORTANT!)
- Important:
    - VLAN Trunk can handle + forward all VLAN frames and all VLAN traffic through one single connection.
    - If VLAN Trunk doesn't exist... 1 new VLAN needs 1 new switch port... # of cables will be unmanageable in the long run... Hence, use **VLAN trunk**!
    - Trunk ports will add VLAN info = VLAN tag to the forwarded data frame.
- When do we use a tag ? Ans: all non-native VLANs's data frame will be tagged!

- Two trunk protocols:
    - IEEE:
    - ISL: Inter-Switch Link (Cisco proprietary)

- **Native VLAN**, default is VLAN 1. However, native VLAN can be set by specifying a VLAN ID during trunk port configurations.
    - Adding VLAN information to data frames is under this protocol: **IEEE 802.1Q** or **802.1q encapsulation** (dot 1 Q)
    - Please note! MUST configure the same native VLAN for the trunk ports for both sides of the connection!!! Otherwise, Native VLAN Mismatch !!!
    - Refer to this diagram for an example for VLAN
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_vlan_1.jpg) 

- Native VLAN mismatch:
- You'll see this on the log...
    - Meaning VLAN 7 and VLAN 88 are clashing since they're both configured as Native VLAN in their own respective trunks!
    ```bash
    Switch1#
    %CDP-4-NATIVE_VLAN_MISMATCH: Native VLAN mismatch discovered on GigabitEthernet1/2 (8), with Switch2 GigabitEthernet1/2 (99).
    ```
    - Diagram of the VLAN mismatch
        - ![](../../../../../assets/images/ccna/lesson3/lesson_3_vlan_2.jpg) 


- Practice 3: Configure VLAN trunk IEEE 802.1q between Switch 1 and Switch 2's g1/2. Native default VLAN 1. Also verify VLAN status for Switch 1.

    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_vlan_3.jpg) 

    - Configure switch 1:
    ```bash
    en
    config t
    int g1/2
    switchport trunk encapsulation dot1q
    switchport mode trunk
    switchport trunk native vlan 1
    ```
    - `switchport trunk encapsulation dot1q`: Setting encapsulation, setting trunk port to be dot1Q
    - `switchport mode trunk`: Configuring the port to trunk port
    - `switchport trunk native vlan 1`: set native VLAN to VLAN 1 (optional command, since default is VLAN 1)

    - Configure switch 2:
    ```bash
    en
    config t
    int g1/2
    switchport trunk encapsulation dot1q
    switchport mode trunk
    end
    ```

    - Verify switch 1: `show int trunk` (= shows info of all trunk ports)
        - Trunk encapsulation the trunk showing 802.1q
        - Native VLAN of trunk is VLAN 1
        - VLAN can only be sent through 1-4094 (Cisco default opens all VLAN 1-4094) (VLAN is 12 bit, has 4095)

    ```bash
    Port        Mode        Encapsulation       Status      Native vlan
    Gi1/2       on          802.1q              trunking    1

    Port        vlans allowed on trunk
    Gi1/2       1-4094
    .
    .
    .
    ```

- Practice 4: Configure multiple native VLANs for multiple  
    - Command: `swtichport trunk allowed vlan` to define all allowed VLANs on the trunk link.
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_vlan_4.jpg)
    
    - 
    ```bash
    en
    config t
    int g1/2
        switchport trunk encapsulation dot1q
        switchport mode trunk
        switchport trunk allowed vlan 1,3-4
    int g1/3
        switchport trunk encapsulation dot1q
        switchport mode trunk
        switchport trunk allowed vlan 2
    end
    ```

    - Verify switchport ! `show interfaces g1/2 switchport`
    - 
    ```bash
    Name: Gi 1/2
    Switchport: Enable
    Administrative Mode: trunk
    Operational Mode: trunk
    Admin...: ...
    Operational Trunking eEncapsulation: dot1q
    .
    .
    .
    ```

    - Verify switchport! `show vlan brief` (shows only the VLAN descriptions top part) as oppose to `show vlan`
    - Notice! Gi1/2 (or g1/2) is removed from the all ports since trunk port BELONG TO ALL (not just one single VLAN)
    ```bash
    VLAN    Name        Status      Forts
    -------------------------------------------------
    1       default     active      Gi0/0, Gi0/1, Gi0/3, Gi1/0
                                    Gi1/1, Gi1/3
    2       Accounting  active      G0/2
    1002    fddi-default        act/unsup   
    1003    token-ring-default  act/unsup
    1004    fddinet-default     act/unsup
    1005    trnet-default       act/unsup
    .
    .
    ```

### 4.3.5 IMPORTANT: InterVLAN Routing
- On L2, different VLANs cannot communicate...but with L3/ IP routing it's possible, we call this method: **InterVLAN routing**!
- This is how InterVLAN works:
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_vlan_5.jpg)

### 4.3.6 Other VLAN and Trunk related features


#### 4.3.6.1 Important: DTP concepts
- DTP = Dynamic Trunking Protocol (Cisco proprietary)
    - DTP allows negotiation (via DTP messages) between 2 switches and decides whether a trunk link should be formed! 

- There are 4 different DTP switchport modes:
    - 1. switchport modes `trunk` = permanently perming trunking (Compatible modes: ALL but access)
    - 2. switchport modes `dynamic desirable` = actively requesting trunking (Compatible modes: ALL but access)
    - 3. switchport modes `dynamic auto` = willing to passively perform trunking (Compatible modes: ALL but access + dynamic auto)
    - 4. switchport modes `access` = permanently NOT performing trunking (Compatible modes: None)

- Verify trunk mode with `show interface trunk`
- If both switch port modes are access then are a few possibilities other than just no trunk being formed...
    - other issues...
    - To solve it: Setting up Native VLAN to resolve this issue! (out syll)

#### 4.3.6.2 Important: VTP concepts
- Important concepts:
    - Trunk Link must be set up before VTP can be used.
    - VTP MUST be propagated via trunk link under the same domain link (set same domain with `vtp domain SysDomain`)
    - VTP can propagate VLAN info (VLAN ID, VLAN Name) **automatically** via trunk links to all switches as long as they are under the same domain link
    - VTP guarantees setting same VLAN across all switches across the network (passwords must be the same too)

- 3 modes of VTP:
    - Server Mode: Will attempt to affect other switches by taking charge of sending VTP messages
        - Configuring Server Mode: `vtp mode server`
        - 
        ```bash
        en
        config t
        vtp domain SysDomain
        vtp mode server
        vtp password ccna
        vlan 2
        name Accounting
        end
        ```
    - Client Mode: Pass on VTP message nit cannot initiate removal/adding of VLAN
        - Configuring Client Mode: `vtp mode client`
        - 
        ```bash
        en
        config t
        vtp domain SysDomain
        vtp mode client
        vtp password ccna
        exit
        ```
    - Transparent Mode: Can remove/add VLAN but doesn't join in the fun and pass on VTP message
        - Configuring Transparent Mode: `vtp mode transparent`
        - 
        ```bash
        en
        config t
        vtp domain SysDomain
        vtp mode transparent
        vtp password ccna
        end
        ```
    - Note: If we want to set another server mode Switch... we don't have to create another vlan like `vlan 2`

## 4.4 EtherChannel

### 4.4.1 Overview
- EtherChannel = Aggregating >= 2 ethernet connection into 1 (i.e. 4 * 1Gi = 4 Gi)
- Ensuring stability and grouping, the individual physical links works best at **same speed** + **same duplex mode**
- Layer 2 (Trunk/ VLAN & cannot set IP) vs Layer 3 (can set IP, mainly Routing)

### 4.4.2 Configuring L2 EtherChannel (Lab)
- Topology of the design of EtherChannel configuration
- ![](../../../../../assets/images/ccna/lesson3/lesson_3_ether_1.jpg)


- Step 1: Swtich left = Switch 1: Resetting to default status
    - 
    ```bash
    en
    config t
    default interface g1/2
    default interface g1/3
    end
    ```
    - assign clean up/ resetting switch ports to default with `default interface g1/2`

- Step 2: Bundle the 2 switch ports `int <switch ports>` then `channel-group 1 mode active`
    - 
    ```bash
    en
    config t
    int range g1/2-3
    channel-group 1 mode active <-------- 2 ports will send LACP messages requesting to form EtherChannel
    end
    ```
    - Note: `active` here means the LACP is active, allowing the 2 switches to negotiate whether a EtherChannel should be constructed. LACP is IEEE 802.3ad protocol, so it's also available on non-cisco devices.

    - There are 2 LACP modes: `active` and `passive`
        - `active`: LACP packet is sent by port requesting to form EtherChannel
        - `passive`: Port accepts EtherChannel request when received LACP request. LACP confirmation packet is sent ONLY IF another LACP request packet is sent. 
        - > Don't think too hard... just LACP messages is okay

    - Out Syll stuff: Cisco proprietary protocol (PAgP)
        - ........... later ..... (on page 54)

- Step 3: Don't forget to configure the other switch!! This switch will take `passive` modes for its port
    - 
    ```bash
    en
    config t
    default interface g1/2
    default interface g1/3
    int range g1/2-3
    channel-group 1 mode passive
    end
    ```

- Step 4: Sanity check and verify !!
    - In left switch: use `show etherchannel summary`. This command shows an easy output with all the port channel interface, the negotiation protocol and # of member port, and its status
    - You should see the summary like this:
    - 
    ```bash
        Flags:  D - down ... S - layer 2
                P - bundled in port channel
                M - not in use, minimum links not met
                m - not in use, port not aggregated due to minimum links not met

        Number of channel-groups in use:    1
        Number of aggregators:              1
        
        Group       Port Channel        Protocol        Ports
        ------------------------------------------------------------------------
        1           Po1(SU)             LACP            Gi1/2(P)        Gi1/3(P)
    ```
    - If you see `(SD)` then it's down, `(SU)` then it's up.

- Step 5: Check LACP passive and active protocols
    - Verify in swtich 1: `show lacp neighbor`. `(SP)` means it's configured into **LACP Passive mode**.
        - result:
        ```bash
            Flags:  S   - Device is requesting slow LACPDUs
                    F   - Device is requesting fast LACPDUs
                    A   - Device is in Active Mode          P   - Device is in Passive Mode
            
            Channel Group 1 neighbors

            Partners information:

                                    LACP Port                                   Admin   Oper    Port        Port
            Port        Flags       Priority        Dev ID              Age     key     Key     Number      State
            Gi 1/2      SP          32768           5001.0004.8000      12s     0x0     0x1     0x103       0x3C
            Gi 132      SP          32768           5001.0004.8000      12s     0x0     0x1     0x103       0x3C
        ```
    - Verify in swtich 2: `show lacp neighbor`. `(SA)` means it's configured into **LACP active mode**.
        - result:
            ```bash
            Flags:  S   - Device is requesting slow LACPDUs
                    F   - Device is requesting fast LACPDUs
                    A   - Device is in Active Mode          P   - Device is in Passive Mode
            
            Channel Group 1 neighbors

            Partners information:

                                    LACP Port                                   Admin   Oper    Port        Port
            Port        Flags       Priority        Dev ID              Age     key     Key     Number      State
            Gi 1/2      SA          32768           5001.0005.8000      19s     0x0     0x1     0x103       0x3C
            Gi 132      SA          32768           5001.0005.8000      19s     0x0     0x1     0x103       0x3C

        ```

- Step 6: We check the new etherChannel with command `sh int po1`.
    > Note: Both port channel + line protocl needs to be up together!!
    - 
    ```bash
    Port-channel1 is up, line protocol is up (connected)
        Hardware is EtherChannel address is  .... omitted the rest ...
    ```
    - EtherChannel is formed, hence logical interface of Po1 is "up" here.

- Step 7: Further verifying EtherChannel with spanning-tree with `sh spanning-tree`
    - 
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
        Gi0/0
        Gi0/1
        Gi0/2
        Gi0/3
        Gi1/0
        Gi1/1
        .
        .
        .
        Po1
    ```
    - Note these findings:
        - g1/2 and g1/3 are no longer shown (since they are bundled by EtherChannel)
        - A single interface called Po1 is showed (has 1+1 Gb = a total of 2Gb of speed)

### 4.4.x Configuring EtherChannel as trunk link (Assuming EtherChannel is already formed) (Lab)
- Step 1: Do everything all at once... for Switch1
    - Config new VLAN, called VLAN 2
    - int the new EtherChannel Po1 (Port Channel 1)
    - Encapsulate as 802.1 dot1Q trunk port
    - Enable trunk mode
    - Assign trunk to VLAN 2 (VLAN 2 as native VLAN)
    - 
    ```bash
        en
        config t
        vlan 2
        name Accounting
        exit
        int Po1
        switchport trunk encapsulation dot1q
        swtichport mode trunk
        switchport trunk native vlan 2
        end
    ```

- Step 2: Repeat the same setup for Switch2
    ```bash
        en
        config t
        vlan 2
        name Accounting
        exit
        int Po1
        switchport trunk encapsulation dot1q
        swtichport mode trunk
        switchport trunk native vlan 2
        end
    ```

- Step 3: Please verify with `sh int trunk`

- If you see this, Channel Port 1, has native vlan 2 and successfully configured as IEEE 802.1Q trunk link
```bash
    Port        Mode        Encapsulation       Status      Native vlan
    Po1         on          802.1q              trunking    2

    Port        vlans allowed on trunk
    Po1         1-4094
    .
    .
    .
```

### 4.4.3 Configuring L3 EtherChannel
- Idea: L3 EtherChannel = L2 EtherChannel + IP address [Syll 1.1.b]
- ![](../../../../../assets/images/ccna/lesson3/lesson_3_ether_2.jpg)
- Step 1: Configure for Switch 1

```bash
    config t
    hostname Switch1
    int range g1/2-3
    channel-group 1 mode active
    exit

    int po1
    no switchport
    ip address 172.16.0.1 255.255.0.0
    end
```

- `no switchport` configure port to L3 port/  Router port. The IP 172.16.0.1 can be 

- Step 2: Configure for Switch 2

```bash
    config t
    hostname Switch1
    int range g1/2-3
    channel-group 1 mode active
    exit

    int po1
    no switchport
    ip address 172.16.0.1 255.255.0.0
    end
```

- Step 3: Verify to see if can ping 172.16.0.2 with `show etherchannel summary`
    - 
    ```bash
        Flags:  D - down                P - bundled in port-channel
                I - stand-alone         s - suspended
                H - Hot-standby (LACP only)
                R - Layer3              S - Layer2
                U - in use              N - not in use; no aggregation
                f - failed to allocate aggregator

                M - not in use, minimum links not met
                m - not in use, port not aggregated due to minimum links not met
                u - unsuitable for bundling
                w - waiting to be aggregated
                d - default port

                A - formed by Auto LAG

        Number of channel-groups in use:    1
        Number of aggregators:              1
        
        Group       Port Channel        Protocol        Ports
        ------------------------------------------------------------------------
        1           Po1(SU)             LACP            Gi1/2(P)        Gi1/3(P)
    ```

### 4.4.z New Skills
- `erase startup-config` = resetting switch and no save config
- `reload` --> `no` = not saving config
    - if fails to reload:
        - `int range g1/2-3`
        - `shut`
        - `no shut`

## 4.5 Port Security [Syll pt. 5.7]
- Port security can block host/ MAC address that are accessing the LAN
- Why do we need port security? Ans: Attacker can access with hub
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_ps_1.jpg)
 
- Topology for port security in Router & Switch
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_ps_2.jpg)

    - Step 1: Set up Router 1 (note: the port is int g0/0), Recall router is off by default.
        - 
        ```bash
            en
            config t
            int g0/0
            no shutdown
            end
        ```
    - Step 2: Set up Switch 1 (note: the port is int g1/1), Recall router is off by default.
        - 
        ```bash
            config t
            int g1/1
            switchport mode access
        ```
        - `switchport mode access` = Set DTP switchport mode to "access"
            - Setting it to "access" or "trunk" to enable port security later

    - Step 3: Set up port-security in switch 1
        - 
        ```bash
            switchport port-security maximum 1
            switchport port-security mac-address 0000.1111.111
            switchport port-security violation shutdown
            switchport port-security
            end
        ```
        - `switchport port-security maximum 1` = Setting the maximum number of MAC Address to 1 (default is already 1)
        - `switchport port-security  mac-address 0000.1111.111` = The allowed MAC address
        - `switchport port-security violation shutdown` = Setting violation actions
            - `shutdown` = "error-disable", will display logs, violation counter will increase.
            - `restrict` = violation frames will drop, will display logs, violation counter will increase.
            - `protect` = violation frames will drop, will NOT display logs, violation counter will NOT increase.
        - `switchport port-security` = enabling port security

    - Step 4: Let's check Switch 1 and verify it's mac address is blocked
        - 
        ```bash
        *Mar 1 16:20:18.376: %PORT_SECURITY-2-PSECURE_VIOLATION: Security violation occurred, caused by MAC address 50001.0001.0000 on port GigabitEthernet1/1.
        .
        .
        .
        *Mar 1 16:20:18.376: %LINK-3-UPDOWN: Interface GigabitEthernet1/1, changed state to down.
        ```
    
