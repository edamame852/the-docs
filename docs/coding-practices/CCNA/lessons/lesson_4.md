---
title: lesson_4
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
4rd Lesson - CCNA Fast Track (May 23, 2025). We left off at page 68.

# 0. CCNA Exam Questions
1. The CCNA exam will be using virtual devices, never real physical ones
2. Turing off CDP on global config level & on interface level will both be tested
3. LLDP and CDP will both be tested! LLDP is non-cisco proprietary, CDP is.


# 4. Features in CISCO switches
## 4.6 CDP and LLDP (CDP was already discussed in lesson 3, will focus on LLDP now)

#### Lab 1: CDP Topolgy from Router perspective (continued) [Syll pt2.3]

- Last time: we talked about `sh cdp neighbors g1/1` to view neighbors

- Step 3: You can check the cdp neighbors in detail! `sh cdp neighbors g1/1 detail`
    - 
    ```bash
    ----------------------------------
    Device ID:  Router1
    Entry address(es):
    Platform:   Cisco,  Capabilities: Router Source-Router-Bridge
    Interface: GigabitEthernet1/1,  Port ID (Outgoing port): GigabitEthernet0/0
    Holdtime: 175 sec

    Version:
    Cisco IOS Software, IOSv Software (VIOS-ADVENTERPRISEK9-M), Version 15.6(2)T, RELEASE
    SOFTWARE (fc2)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2016 by Cisco Systems, Inc.
    Compile Tue 22-Mar-16 16:19 by prod_rel_team

    advertisment version: 2

    Total cdp entries displayed: 1
    ```

#### Lab 2: Configure IP Address for L2 Router into L3
- Topology diagram:
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_cdp_1.jpg)
- L2 Router cannot check neighbor IP address
- Step 1: Setup IP onto the Router1
```bash
    config t
    int g0/0
    ip address 10.0.0.1 255.0.0.0
    end
```

- Please wait up to 1min for the new IP to take affect

- Step 2: Verify cdp neighbor with detail `sh cdp neighbors g1/1 detail` on the Switch
- 
    ```bash
    ----------------------------------
    Device ID:  Switch1
    Entry address(es):
        IP address : 10.0.0.1 <---------------------- These are NEW :D
    Platform:   Cisco,  Capabilities: Router Source-Router-Bridge
    Interface: GigabitEthernet1/1,  Port ID (Outgoing port): GigabitEthernet0/0
    Holdtime: 175 sec

    Version:
    Cisco IOS Software, IOSv Software (VIOS-ADVENTERPRISEK9-M), Version 15.6(2)T, RELEASE
    SOFTWARE (fc2)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2016 by Cisco Systems, Inc.
    Compile Tue 22-Mar-16 16:19 by prod_rel_team

    advertisment version: 2
    Management address(es): <---------------------- These are NEW :D
        IP address: 10.0.0.1 <---------------------- These are NEW :D

    Total cdp entries displayed: 1
    ```

> Note: Now IP is set up for Router1, you can remove control (i.e. ssh/telnet/...etc) to the Router!

#### Lab 3: Turning off cdp for Switch1 (global + interface level turn off)

- Topology diagram:
    - ![](../../../../../assets/images/ccna/lesson3/lesson_3_cdp_1.jpg)

- Note: There are 2 ways to stop CDP
    - Stopping ALL ports: Do `no cdp run` at global config mode
    - Stopping a single port: Do `no cdp run` at interface config mode

- Step 1a: Stopping cdp (on global level). No CDP messages will be sent/received through ALL ports.
    - 
    ```bash
    config t
    no cdp run
    end
    ```
- Step 1b: Stopping cdp (on interface level). e.g. for g0/0
    - 
    ```bash
    config t
    int g0/0
    no cdp run
    ```

- Step 2: Verify neighbors cannot send/receive cdp messages with `sh cdp neighbors`
    - 
    ```bash
    % CDP is not enabled
    ```
#### Lab4: Checking more info (i.e. VTP, native VLAN, IEEE 802.1Q trunk, ...) with CDP

- Assume that CDP is on (I also assumed VLAN and trunk was setup)

- Step 1: `sh cdp neighbors g1/2 detail`

    ```bash
    ----------------------------------
    Device ID:  Switch1
    Entry address(es):
        IP address : 10.0.0.1 <---------------------- These are NEW :D
    Platform:   Cisco,  Capabilities: Router Source-Router-Bridge
    Interface: GigabitEthernet1/1,  Port ID (Outgoing port): GigabitEthernet0/0
    Holdtime: 175 sec

    Version:
    Cisco IOS Software, IOSv Software (VIOS-ADVENTERPRISEK9-M), Version 15.6(2)T, RELEASE
    SOFTWARE (fc2)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2016 by Cisco Systems, Inc.
    Compile Tue 22-Mar-16 16:19 by prod_rel_team

    advertisment version: 2
    VTP Management Domain: 'FrancoDomain' 
    Native VLAN: 2 <---------------------- Removed IP Management address. These are NEW :D
    Duplex: full <---------------------- Removed IP Management address. These are NEW :D

    Total cdp entries displayed: 1
    ```

### 4.6.2 LLDP = Link Layer Discovery Protocol

- Background: 
    - LLDP is a vendor neutral protocol/ non-cisco propietry protocol (so can be used in i.e. Juniper)
    - This protocol is specified by IEEE 802.1AB
    - LLDP is L2 protocol and serves the same function as CDP
    - Unlike CDP, which refreshes every 60s, LLDP refreshed every **30 seconds**
    - LLDP is disabled by default, unlike cdp!

#### Lab 1: Showing capabilities of LLDP
- Topology Diagram: ![](../../../../../assets/images/ccna/lesson3/lesson_3_cdp_1.jpg)
- Step 1: Verify that LLDP is off by default
    - `sh lldp`.
    ```bash
    % LLDP is not enabled
    ```
- Step 2: Turn on LLDP in Router1 & Switch 1. Wait up to 30 seconds to wait for LLDP message to exchange.

    - `lldp run` for Router 1.
    ```bash
    config t
    lldp run
    end
    ```
    - `lldp run` for Switch 1.
    ```bash
    config t
    lldp run
    end
    ```

- Step 3: Verify that LLDP is able to discover neighbors in 2 ways. Either with `show lldp neighbors` or `show lldp neighbors detail`.
- `show lldp neighbors`
```bash
    Capability codes: (R) Router,   (B) Bridge,   (T) - Telephone,
                      (C) DOCSIS Cable Device, (W) WLAN Access Point, (P) Repeater, 
                      (S) Station, (O) Other

    Device ID       Local Intrfce       Holdtme     Capability      Platform        PortID
    Router          Gig 1/1             120             R                          Gig 0/0 

                    <Local Interface: This is the neighbor>                         <PortID: This is Yourself>

    Total cdp entries displayed : 1
```
> Note: The hold time is ALWAYS 120s, the count down process is NOT visable in LLDP, unlike in CDP.

- This time with detail: `show lldp neighbors detail`.
```bash
----------------------------------
    Device ID:  Router1
    Entry address(es):
    Platform:   Cisco,  Capabilities: Router Source-Router-Bridge
    Interface: GigabitEthernet1/1,  Port ID (Outgoing port): GigabitEthernet0/0
    Holdtime: 175 sec

    Version:
    Cisco IOS Software, IOSv Software (VIOS-ADVENTERPRISEK9-M), Version 15.6(2)T, RELEASE
    SOFTWARE (fc2)
    Technical Support: http://www.cisco.com/techsupport
    Copyright (c) 1986-2016 by Cisco Systems, Inc.
    Compile Tue 22-Mar-16 16:19 by prod_rel_team

    advertisment version: 2

    Total cdp entries displayed: 1

```


