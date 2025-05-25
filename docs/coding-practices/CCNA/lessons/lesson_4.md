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
4. CCNA MC: What is a LLDP re-init time? Ans: Default is 5 seconds to implement all the changes done to the port.
5. CCNA Lab/ Exam: Will test you how to set up Voice VLAN
6. MC will test the cocepts of PCP/Priority bits
7. MC will test your knowledge of converting decimals to binary values
8. There will be no calculators on the CCNA exam


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

    Time remaining: 97 seconds 
    System Capabilties: B, R
    Enabled Capabilities: R <------ Only Router
    Management Addresses:
        IP: 10.0.0.1 <------ IP is visable
    Auto Negotiation - Not Supported
    Physical media capabilities - not advertised
    Media Attachment Unit type - not advertised
    Vlan ID: - not advertised

    Total entries displayed: 1 <------ the word 'cdp' is removed

```

#### Lab 2: Checking what other lldp comamnds is avaliable in the console

- 
```bash
config t
int g1/1
lldp ?
```
- This is the output of `lldp ?` under interface config mode
    - 
    ```bash
    switch1(config-if) #lldp ?
        med-tlv-secret      Selection of LLDP MED TLVs to send
        receive             Enable LLDP reception on interface
        tlv-select          Selection of LLDP TLVs to send
        transmit            Enable LLDP transmission on interface
    ```
    - We only have to pay attention to the 2 lddp commands for on/off:
        - `lldp receive` & `lldp no receive` = Allowing/ Dis-allowing port to receive LLDP messages
        - `lldp transmit` & `lldp no transmit` = Allowing/ Dis-allowing port to transmitting LLDP messages


#### Lab 3: Resetting LLDP re-initilization delay timer away from the default 5 seconds.

- LLDP Re-initilization time = The delayed time for LLDP to be re-useable
- Adjusting the LLDP reinit time can avoid frequent initialization causing by frequent settings changes to LLDP

- Step 1: Re-init the time for LLDP port
    - 
    ```bash
    config t
    lldp reinit 5
    end
    ```
- Step 2: Verify lldp information with `sh lldp`:
    - 
    ```bash
    GLobal LLDP Information:
        Status: ACTIVE
        LLDP advertisements are sent every 30 seconds
        LLDP hold time advertised is 120 seconds
        LLDP interface reinitialisation delay is 5 seconds
    ```

## 4.7 Voice VLAN !
- Meaning: Voice VLAN = a VLAN for sending VoIP/ Voice Over IP data frames (i.e. those that are sent/received by IP Phones)

- Usually the topology for Voice VLAN:
    - ![](../../../../../assets/images/ccna/lesson4/lesson_4_ip_phone_1.jpg)

- Why do we need the Voice VLAN feature ? AKA why not send data frames through normal VLAN ? Why use Voice VLAN
    - Voice VLAN can distinguish normal user data frames vs voice data frame
    - Without this distinguishing the two, voice data frame quality can be greatly affected (Since voice is sensitive to delay & packet drops)

- Let's do some labs

#### Lab 1: Did not set up Voice VLAN

- This is the current topology diagram:
    - ![](../../../../../assets/images/ccna/lesson4/lesson_4_ip_phone_2.jpg)

```bash
en
config t
vlan 2
name Accounting
int g0/2
switchport access vlan2
end
```

> Notice: User PC -- data --> Cicso IP Phone -- data --> Switch
- There is no tag in the data frame
- If the bandwith is HUGE then there won't be any package drop/ delay but vice versa, it will cause some issues.

#### Lab 2: Set up Voice VLAN

- To fix the issue: Additionally configure Voice VLAN on access port by the interface mode `switchport voice vlan <VLAN ID>`
- IP Phone will get the Voice VLAN settings via CDP, thus tagging all the VoIP traffic with the VLAN 200 tag.

- This is the current topology diagram:
    - ![](../../../../../assets/images/ccna/lesson4/lesson_4_ip_phone_3.jpg)

```bash
en
config t
vlan 2
name Accounting

vlan 200
name Voice
int g0/2
switchport access vlan 2
switchport voice vlan 200
end
```
- Q: What is a pirority bit?
    - Ans: Priority bit/ Priority/ PCP (Priority Code Point)/ CoS (Class of Service) bits are the initial 3bit field tag for handling voice data frames under a priority queue
    - Usually this piroirty bit is 5 in decimal, in binary, it's **101** (during phone call, actively exchanging voice data frames)
        - It's **011** in binary, when the call is still connecting/ dialing

- There are 3 parts to the enriched data frame that is getting sent through VLAN 200:
    - The 3 bit priority bit/ PCP : i.e. 101 in binary or 5 in decimal
    - The VLAN 200 tag, i.e. 200
    - original data frame

# 5. IP Address

## 5.1 IP Address's structure

- There are 2 IP address formats:
    - in binary
    - in decimal

- Each IP is 32 bits long = 4 * 8 bit fields (octects) = 4 octects
- These octects are seperated by periods
- Each octect can live between the range 0 ~ 255 in decimal (00000000 ~ 11111111 in binary)

## 5.2 Binary numbers

- Converting from bianry to decimal
    - `00000000` in binary = 0 in decimal
    - `00010001` in binary = 2**0 + 2**4 = 1 + 16 = 17 in decimal
- Converting from decimal to binary
    - e.g. `30` = 30/2 = 15 R **0**, 15/2 = 7 R **1**, 7/2 = 3 R **1**, 3/2 = 1 R **1**, 1/2 = 0 R **1**
        - Start from the bottom you'll get `11110` = 16 + 8 + 4 + 2 + 0 = 30 (which is our answer !)

- Concept of bits:
    - 1 bit: Either 0 or 1 (maximum 2 combinations)
    - 2 bits: Either 00, 11, 01, 10 (maximum 4 combinations)
    - 3 bits: Either 000, 001, 010, 011, 100, 101, 110, 111 (maximum 8 combinations)
    .
    .
    .
    - 24 bits: Either .... (maximum 16,777,216 combinations = 2**24)

## 5.3 Discussing Network ID without subnetting
There are 4 classes. Class A,B,C,D; Each class uses different lengths/number of Network ID bits

### 5.3.1 Class A: 1-126
- Format: The 4 octects = Network ID + Host ID + Host ID + Host ID. However there are 4 rules to follow!!
- Rule 1: Class A's first octect = The Network ID must be from 1 - 126 (Exlcuding 0 and 127 !!!) (withholding prefix starting with `0` hence the range is **0**0000000 ~ "**0**0000001 ~ **0**1111110" ~**0**1111111)
    - 0: or 0.0.0.0 is reseved as this host on the network
        - 0.0.0.0 is used as the source IP address, for a device that yet to have an IP, the device requests an IP via DHCP to talk to 0.0.0.0 to request an IP on the network.
        - Note: 0 is not considered as class A
    - 1-126: Normal Class A IP Address
    - 127: Reserved for internal loopback and testing (i.e.`127.0.0.1`)
        - Most OS when you `ping 127.0.0.1` you can verify whether your TCP/IP protocol stack is healthy and corrected installed
        - 
        ```bash
        pinging 127.0.0.1 with 32 bytes of data:
        Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
        Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
        Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
        ```

- Rule 2: First octet/ First 8 bits = The class A's NetworkID. The next 24 bits represent the HostID
- Rule 3: For a useable HostID to represent a network but not a host, the rest of the host IDs bits cannot be all 0s
    - Represents a network: 125.`0.0.1` 
    - Represents just a host: 10.`0.0.0`, 111.`0.0.0`
- Rule 4: To become a valid Host IP Address, the rest of the host IDs bits cannot all be 1 (i.e. 11111111 in binary = 255 in decimal)
     - Represents a network: 125.`0.0.1` 
     - Represents a directed broadcast: 10.`255.255.255`, 111.`255.255.255`


### 5.3.2 Class B: 128-191
- Format: The 4 octects = Network ID + Network ID + Host ID + Host ID. Again, there are 4 rules to follow!!
- Rule 1: Class B's **first** octect = The Network ID must be from 128 - 191 (withholding prefix starting with `10` hence the range is **10**000000 ~ **10**111111)
- Rule 2: Class B's first 2 octets = Network ID, the next 2 octets = Host ID
- Rule 3: To become a valid host IP address. The last 2 octets bits cannot be all 0s
    - Represents this network: 172.16.`0.0` (the last 2 octets are 0)
    - Represents this host: 172.16.`0.1` (the last 2 octets are NOT 0)
- Rule 4: To become a valid host IP address. The last 2 octets bits cannot be all 1s (i.e. 11111111 in binary = 255 in decimal)
    - Represents this network: 172.16.`254.255` (the last 2 octets are 1s)
    - Represents a directed broadcast: 172.16.`255.255` (the last 2 octets are NOT 1s)


### 5.3.3 Class C: 192-223 (We use this at home)
- Format: The 4 octects = Network ID + Network ID + Network ID + Host ID. Again, there are 4 rules to follow!!
- Rule 1: Class C's **first** octect = The Network ID must be from 192 - 223 (withholding prefix starting with `110` hence the range is **110**00000 ~ **110**11111) = 
- Rule 2: Class C's first 3 octets = Network ID, the last octet = Host ID
- Rule 3: To become a valid host IP address. The last octet bit cannot be 0
    - Represents this network: 192.16.0.`0` (the last octet is 0)
    - Represents this host: 192.16.0.`1` (the last octet is NOT 0)
- Rule 4: To become a valid host IP address. The last octet bit cannot be 1 (i.e. 11111111 in binary = 255 in decimal)
    - Represents this network: 172.16.254.`254` (the last octet is 1)
    - Represents a directed broadcast: 172.16.255.`255` (the last octet is NOT 1)

### 5.3.4 Class D: 224-239
- Rule 1: Class D's **first** octect = The Network ID must be from 224-239 (withholding prefix starting with `1110` hence the range is **1110**0000 ~ **1110**1111)
- Class D is used for multi-casting
- Topology of uni-cast vs multi-cast
    - uni-cast
        - ![](../../../../../assets/images/ccna/lesson4/lesson_4_unicast_1.jpg)
    - multicast
        - ![](../../../../../assets/images/ccna/lesson4/lesson_4_multicast_1.jpg)


### 5.3.5 Class E: 240 - 255
- Rule 1: Class E's **first** octect = The Network ID must be from 240 - 255 (withholding prefix starting with `11110` hence the range is **11110**000 ~ **11110**111)
- Class E is reserved for future use (reserved for IPv6 now)


#### Special address: 255.255.255.255 - local broadcast
    - When a host computer sends a local broadcast packet, this packet will be accepted by all other host PCs on the lcoal network! (With excepts to router, as router does not forward packages like these)
    - Local Broadcast topology:
        - ![](../../../../../assets/images/ccna/lesson4/lesson_4_local_broadcast_1.jpg)

## 5.x.3 Simulation labs!
Please refer to this [website for simulation](https://simulation.redirectme.net/na_crt_tftp_pt722_3cd_3150/SIMULATION%20%28Part%29.pdf)

### Simulation Lab 1 (CCNA Exam Practical Style 1): Swtich, VLAN
- Task 1: Switch 1 needs to initiate vlan12 and vlan 34. Switch 2 needs only vlan 12. Please verify the proper setup using `sh vlan brief` 
- Techniques: `copy run start` allows you to save configs for the exam
- Task 2: Setting up VLAN 99, and don't forget to include the switchport e0/1 for that. Please wait for the access port to warm up...otherwise, you might screw yourself...
- Task 3: No trunk, so we're using access trunk, `switchport access vlan12`
- Task 4: IP Phone
- Task 5: Neighbor discovery protocl (use CDP), turn off cdp for the port! 

### Simulation Lab 2 (CCNA Exam Practical Style 2):: LARP EtherChannel = bundling 
- Task 1: Setting up channel group to be ALL active (this might change in the real exam, i.e. one passive, one active)
- Task 2: EhterChannel tunk link set up, verify with `sh vlan brief`
- Task 3: Careful with the dot1q command. 2 switches needs to be set. 
- Task 4: untag data frames = native VLAN (This part must be set up first before everything else)
- Important ! Define the dot1Q first, before you set up your trunks


### Simulation Lab 3 (CCNA Exam Practical Style 3): Different VLAN and different switches
- Task 0: Don't touch the VTP settings and define the 2 VLANs yourself, VLAN 202 and VLAN 303
- Task 1-3:
    - Switch 1: Need only VLAN 303
    - Switch 2: Need both VLAN 202 and VLAN 303, int just 1 port
    - Switch 3: Need both VLAN 202 and VLAN 303, int 2 ports (i.e. int e0/3 for allowing both VLAN 202 and VLAN 303)
- Performing sanity checks: please chekc with `sh int trunk`

### Simulation Lab 4: Subset setting (next time)

