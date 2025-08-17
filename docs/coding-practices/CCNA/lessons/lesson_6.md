---
title: lesson_6
layout: default
parent: CCNA
grand_parent: Coding Practices
nav_order: 6
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
5th Lesson - CCNA Fast Track (May 27, 2025). We left off at page 80.

# 0. CCNA Exam Questions
- 1. You need to save ram before clicking next in the CCNA exam via `copy run start`
- 2. Need to know how to use vty to telnet and verify the connection + something else

# 7. Overview of Cisco Routers
## 7.3 Interfaces

Let's conclude and compare teh serial and ethernet interfaces

- Terminologies:
    - LAN = Local Area Network
    - WAN = Wide Area Network (e.g. Leased Line)

| N/A |  Ethernet Interfaces (e.g. f0/0, g0/0)  | Serial Interfaces (e.g. s0/0/0) |
|  :---: | :---:  | :---:  | 
| Typically used in  | LAN/ WAN | LAN only |
| L2 Protocol  | Ethernet | HDLC/PPP (OutSyll!) |
| Config setup | see below | see below |

- Configuration setup:
    - Ethernet:
        - 
        ```bash
        en
        config t
        int g0/0
        ip address 10.0.0.1 255.0.0.0
        no shut
        end
        ```
    - Serial: (treat is as normal routing port)
        - 
        ```bash
        en
        config t
        int s0/0/0
        ip address 10.0.0.1 255.0.0.0
        no shut
        end
        ```

# 8. Basic Router Management

## 8.1 Features of CLI (useful comamnds I guess)

### 8.1.1 Help System 
- `help`, help system can help you with commands instructions
- `show ?` in user mode can tell you a list of commands to type

### 8.1.2 Abbreviations
- `show version` can also be typed as `sh version`
- `config t` = `conf t`, it works since there's no other command than config when you type conf

### 8.1.3 Editing Features
- ctrl + a = jump to start of the line in cli
- ctrl + e = jump to end of the line in cli

### 8.1.4 Command History
- You can call history buffer using the up arrow

## 8.2 Obtaining General info as a router
- You can use `sh ver` to disaplay software and hardware infos
- Primary RAM: 249856 byte
- Secondary RAM: 12288 byte
- Flash memory size is now 2256 Mb

## 8.3 Config Management (VERY IMPORTANT)
There are 2 diff locations in the rouer to store configs

|  `running-config`  | `startup-config` |
| :---:  | :---:  | 
| Stored in RAM, all commands are lost when router reloads  | Stored in [NVRAM](./lesson_5/#713-nvram-non-volatile) |
| Contect is dynamic, updated per config command entered | Router boost up and load startup-config file to running config |
| Can be checked with `sh running-config` | Can be checked with `sh startup-config`|

- To preserve the content in running-config `copy run start` & `copy running-config startup-config`

- Step 1: Setting IP address 
```bash
en
config
hostname Router2
int g0/0
ip address 10.0.0.2 255.0.0.0
no shut
end
```
- Step 2: `sh run` = shows configs are being run right now
Router
- Step 3: `sh start`. Oh, no configuration saved in startup-config
```bash
startup-config is not present
```

- Step 4: `copy run start` to copy the running-config from RAM to startup-config in NVRAM
```bash
copy run start
Destination filename [startup-config]?
Building configuration...
[OK]
```

- Step 5: `sh start` to check your new config copied over ti startup-config :D

### Lab 1: Backuping configs to TFTP server
- Topology: ![](../../../../../assets/images/ccna/lesson6/lesson6_tftp_1.jpg)

- Step 1: Sanity Check from router 1: `ping 172.23.66.3`.
```bash
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 172.23.66.3, timeout is 2 seconds:
!!!!
Sucess rate is 100 percent (5/5), round-trip min/avg/max = 1/1/2 ms
```

- Step 2: `copy run tftp`, you then punch in your address/ name of remote host
```bash
Address or name of remote host []? 172.23.66.3
Destination filename [router1-confg]?
!!
1159 bytes copied in 1.097 secs (1057 bytes/sec)
```

- You'll then see in the tftp server

## 8.4 Configuring Password and Telnet Access
- There are 4 types of password can be configured
    - Enable Password/ secret
        - Use: Preventing unauthroized access to Privileged Mode
        - Example: with password as `sadmin`
        ```bash
        en
        config t
        hostname Router1
        enable secret sadmin
        end
        disable
        ```
    - Console password
        - Use: Preventing CLI access through console port connection. `line console 0`/ `line con 0` refers to interface console 0.
        - `login` means this password checking rule is actually implements
        - Example:
        ```bash
        config t
        line console 0
        password cadmin
        login
        end
        ```
    - VTY = Virtual Teletype (like remote access)
        - Use: Preventing CLI access to telnet connection
            - Configuring IP address on a router interface/ VLAN interface for a switch
            - Configuring password in Line config mode for telnet connection = setting VTY Password
        - Topology: ![](../../../../../assets/images/ccna/lesson6/lesson6_telenet_1.jpg)
        - Example:
        ```bash
        config t
        int g0/0
        ip address 10.0.0.1 255.0.0.0
        no shut
        line vty 0 4
        password tadmin
        transport input telnet
        end
        ```
        - `line vty 0 4` : entering line config mode for vty for remote access, we configure 5 vty lines (0-4 vty lines). Max 5 telnet sessions is allowed
        - `transport input telnet` : Configuring line vty 0 4 accept telnet connections

        - After this configuraiton, Router 2 can TCP/IP to Router 1
        ```bash
        config t
        int g0/0
        ip address 10.0.0.2 255.0.0.0
        no shut
        end
        ```
        <br/>
        When you telnet in Router 2 `telnet 10.0.0.1`, you'll need password now
        
        ```bash
        Trying 10.0.0.1 ... Open

        User Access Verification

        Password:
        ```
    - ## 8.5 service password-encryption
        - `sh run` will tell you you have `no service password-encryption`
        ```bash
        show run
        ```
        - Any secret will be hashed but other passwords won't
            - secret: auto encryption
            - passwords: manual encryption
        - To setup and enable service password... you do `service password-encryption` when your passwords are NOT encrypted on the run config
        - 
        ```bash
        config t
        service password-encryption
        ```
        - Sanity check with `sh run` again
        - Note: These encrypted passwords are NOT save, use cisco 7 password 7 website can easily decrypt this. Password should better to stored on AAA servers!

# 9. Static Routing

## 9.1 Route entries for directly connected networks

### 9.1.1 Routes for directly connected networks
- Note: please reload your system and clear everything with `reload`
- Suppose router has 2 interfaces (= 2 ports) with different IP address on different networks
    - IP 10.0.0.0/8 connected to g0/0 on Router 1 on IP 10.0.0.1/8 
    - s0/0/0 on Router 1 on IP 192.168.1.1/24 connected to 192.168.1.0/24
- Routing table of Route 1 auto includes routes for 10.0.0.0 and 192.168.1.0
```bash
Routing table of router 1
-----------------------------------

Network Destination         Gateway                 Interface
10.0.0.0/8                  directly connected      g0/0
192.168.1.0/24              directly connected      s0/0/0
```
- The topology: ![](../../../../../assets/images/ccna/lesson6/lesson6_dcn_1.jpg)
- The setup
    - Step 1: `no shut` meaning no ip is set
    ```bash
    en
    config t
    hostname Router1
    int g0/0
    no shut
    end
    ```
    - Step 2: `sh ip route`. Note the usable IP range is 10.0.0.1 ~ 10.255.255.254
    ```bash
    Codes: I - IGRP derived, R - RIP derived, O - OSPF derived
       C - connected, S - static, E - EGP derived, B - BGP derived
       * - candidate default route, IA - OSPF inter area route
       E1 - OSPF external type 1 route, E2 - OSPF external type 2 route

    Gateway of last resort is not set
        10.0.0.0/8 is variably subnetted, 2 subnet, 2 masks
    C   10.0.0.0/8 is directly connected, GigabitEthernet0/0
    L   10.0.0.1/8 is directly connected, GigabitEthernet0/0
    ```
    This route for the directly connected network (i.e. 10.0.0.1) on interface g0/0 is auto generated & found in routing table

    - Note:
        - If router goes downn, it resets and routing table is EMPTY even when IP address is assigned but interfaces are down
        - Showing a brief summary of all assigned IP and interface status via `shop ip interface brief`
        - status: representing L1 status, protocol: representing L2 status
        ```bash
        Interface           IP-Address      OK?     Method      Status                  Protocol
        GigabitEthernet0/0  unassigned      YES     NVRAM       up                      up
        GigabitEthernet0/1  unassigned      YES     NVRAM       adminstratively down    down
        GigabitEthernet0/2  unassigned      YES     NVRAM       adminstratively down    down
        GigabitEthernet0/2  unassigned      YES     NVRAM       adminstratively down    down
        ```
        - Note: 
            - `up up` = `no shutdown` is used to turn on ports and up up means a proper connection is detected
            - `adminstratively down    down`  = interface/ router is not broken, just down due to `shutdown` command

## 9.2 InterVLAN Routing (Router-on-a-strick & L3) examples 
- Single router designs with properly set up, routing can happen without extra configs
- Multilater or L3 Switch can route IP packets based on L3 info in IP packets

### 9.2.1 InterVLAN 1 -  Configuring Routing Using a Multi-layer Switch (via L3) 
- Topology: ![](../../../../../assets/images/ccna/lesson6/lesson6_ivlan_1.jpg)
    - Don't forget to set the correct IP
    - Step 1: The setup, `no switchport` will turn a port from L2 to L3
    ```bash
    en
    config t
    hostname Switch1
    ip routing
    int g1/1
    no switchport
    ip addr 10.0.0.1 255.0.0.0
    int g0/2
    no switchport
    ip addr 172.16.0.1 255.255.0.0
    ```
    - `ip routing` enabling L3 IP routing in multi-layer switch
    - Step 2: Perform sanity check with `show ip route`:
        - L represents the Host Route, can be disregarded
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
    - Step 3: Configure Router 1
    - `ip route 0.0.0.0 0.0.0.0 10.0.0.1` configure the default gate of Router 1 to 10.0.0.1 (Will go into detail next time)
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

    - Step 4: Configure Router 2
    - 
    ```bash
    en
    config t
    hostname Router2
    int g0/2
    ip address 172.16.0.200 255.255.0.0
    no shut
    exit
    ip route 0.0.0.0 0.0.0.0 172.16.0.1
    end
    ```
    - Step 5: sanity check previlage mode
    - 
    ```bash
    ping 10.0.0.100
    Type escape sequence to abort.
    Sending 5, 100-byte ICMP Echos to 10.0.0.100, timeout is 2 seconds:
    !!!!!
    Success rate is 100% (5/5), round-trip min/avg/max = 3/4/6 ms
    ```

    - If fail, debug with `sh ip route` 

### 9.2.2 InterVLAN 2 - Configuring Routing Using a Multi-layer Switch (via L2, VLAN interface)
- Topology diagram: ![](../../../../../assets/images/ccna/lesson6/lesson6_ivlan_2.jpg)

- Benefit of this topology:
    - No single point of failure
    - no physical issue/ connections
    - interVLAN hard to go down

- Step 1: Setup Switch 1
- `switchport mode access` gurantees there will be NO Trunk Link
```bash
en
config t
hostname Switch1

vlan 2

int g1/1
switchport mode access
switchport access vlan 1

int g0/2
switchport mode access
switchport access vlan 2

exit

```

- Step 2: Turn on InterVLAN routing
- `ip routing` enable IP Routing L3 or Multi-layer switch
```bash
ip routing
int vlan 1
id address 10.0.0.1 255.0.0.0

no shut
int vlan 2
ip address 172.16.0.1 255.255.0.0
no shut
end
```
- Note: `int vlan 1` and `int vlan 2`. The above enale routing feature and configures IP addresses

- Step 3: Sanity check Switch with `sh ip route`
-    
```bash
Codes: I - IGRP derived, R - RIP derived, O - OSPF derived
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

- Step 4: setting up Router 1
```bash
en
config t
hostname Router 1
int g0/0
ip address 10.0.0.100 255.0.0.0
no shut
exit
ip route 0.0.0.0 0.0.0.0 10.0.0.1
end
```

- Step 5: setting up Router 2
```bash
en
config t
hostname Router2
int g0/2
ip address 172.16.0.200 255.255.0.0
no shut
exit
ip route 0.0.0.0 0.0.0.0 172.16.0.1
```

- Step 6: Sanity Check Router 2 with `ping 10.0.0.1`.

```bash
ping 10.0.0.100
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 10.0.0.100, timeout is 2 seconds:
!!!!!
Success rate is 100% (5/5), round-trip min/avg/max = 3/4/6 ms
```

> Note: Lesson ended on page 124

# Simulation 13
- Topology diagram: ![](../../../../../assets/images/ccna/simulation/simulation_13.png)
- Further solution: ![](../../../../../assets/images/ccna/simulation/simulation_13_2.png)
