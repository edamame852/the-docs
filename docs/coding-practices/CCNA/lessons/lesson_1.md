---
title: lesson_1
layout: default
parent: CCNA
grand_parent: Coding Practices
nav_order: 1
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

1st Lesson - CCNA Fast Track (May 13, 2025)

# 0. CCNA Exam Questions

1. How to get MAC address/ physical access in...
- Windows : `ipconfig /all`
- MacOS : `ifconfig en0`: en0 = Apple's LAN card's name
- Linux: `ip address show`

2. How to find default gateway / routing tables
- MacOS : `netstat -nr`
- Linux: `ip route show`

3. Configuring switch/router with SecureCRT app (Do not get this wrong on the exam)
- Step by step:
    - 1. Open SecureCRT app, `File` -> `Quick Connect`
    - 2. Pop up window set up like the following:
        - Protocol: `Serial`
        - Port: `COM1` (The serial port your computer is connecting from, the insert point of COM cable)
        - Baud rate: `9600` (Baud rate = bps = bits per second)
    - 3. Click `Connect`, should see blank screen then hit [Enter], done.

4. How to distinguish if the machine is half duplex/ full duplex based on a collision report?
    - You can look up the report in `#` privileged mode, and check with `sh int f0/3`
    - Has late collision, but no CRC error => Half-duplex (since report is sent but crashed)
    - Has 0 late collision, but many CRC errors (by FCS) => Full-Duplex (since data loss)

# 1. Networking Model

## 1.1 OSI Reference Model / Open Systems Interconnection
- OSI model is released by ISO
- Has 7 layers, **Please Do Not Trust Sales Person Advice** (Layer 1 to Layer 7)
    - Layer 7: Application = protocols that directly supports user apps, interface for sending and getting data
        - Common Application layer: HTTPS (default port: 443), HTTP(default port: 80), SNMP, SSH, DHCP, FTP, TFTP
        .
        .
        *SKIPPING Layers 5 & 6*
        .
        .
    - Layer 4: Transport [information name: segment] = Segments + re-assemble data for transporting data efficiently. 
        - On layer 4, note ports numbers can differentiate different app data
        - Common Transport layer: TCP vs UDP
            - TCP (Transmission Control Protocol): CONNECTION oriented. First establish connect connection, then send data.
                - Examples: 
                    - HTTP (tcp/80)
                    - SMTP (tcp/25)
                    - SSH (tcp/22)
                    - FTP (tcp/21)
                    - etc...
            - UDP (User Datagram Protocol): CONNECTION**LESS** protocol, no need connection before sending data
                - Examples:
                    - SNMP (udp/161)
                    - TFTP (udp/69)
                    - VoIP (udp/1xxxx-3xxxx)
                    - etc...
    - Layer 3: Network [information name: packet]. Responsible for data delivery from source host to destination host via logical address such as IPv4 (aka, IP Address e.g. 10.1.1.1)
        - IPv4 Address has 2 parts: Network Address (e.g. 10) + host address (e.g. 1.1.1)
        - Layer 3 devices = e.g. routers, switches keeps tracks of data forwarding logic by maintaining routing tables
        - Switch can act like a road-sign
        - High level understanding: Network A (10.1.1.1) End user < -- > Switch < -- > Network B (20.1.1.1)
    - Layer 2: Data Link Layer [information name: frame]. Receive layer 3 data packet, then encapsulate the packet into frame for transmission.
        - Layer 2 can **perform error detection** on data frames, as it has a FCS (Frane Check Sequence) field at the end of the data frame.
            - FCS field contains a value that is calculated by CRC algorithm, the output of the algo is sent by the sender and checked again the value calculated by receiver
            - Whole high level flow:
                - Sender: Data -> CRC calculate -> sender FCS hash created
                - Receiver: Data -> CRC calculate -> receiver FCS bash created and compared with sender FCS.
                - If FCS Check fails = receiver dumps data frame = gives CRC error, frames are lost, input error count increases!! 
        - **MAC Address = physical address = hardware address**
            - MAC Address is 48 bits long = 24 bits Verdor Code/ OUI/ Organizationally Unique Identifier + 24 bits Vendor Assigned Code
            - Find MAC Address in cmd console: `arp -a`
        - Example protocol: Ethernal - Using MAC (Media Access Control) address (12 Dec code/16 Hex code). These MAC address are included in network interface devices (e.g. network cards)
        - Example of Layer 2 devices: 
            - Ethernet Bridges 
            - Switches/ Multi-port bridges 
    - Layer 1: Physical [information name: bit]
        - Deals with phsyically transmitting data. Data is sent via voltage/ lasers and sent & receives as 0,1 bits
        - Examples of layer 1 items: voltage, connectors, network cables, lasers, repeaters, hubs (= multi-port repeaters) ...
        - Use of repeaters/ multi-port repeaters = regenerate 0,1 signals from one port and sent to all ports while traveling further

## 1.2 Layer interactions
- How is data passed down the layers? Layer 7 -> Presentation -> Session -> Transport -> Network -> Data link -> physical
- **Data encapsulation** = Layer adds own layer info (= header) before sending to next layer 
- For example in layer 2 header: it contains Layer 3's protocol, since IPv4 address is layer 3 
```bash
Ehternet II, Src: Cisco_85...
 > Destination:
 > Source...
 < Types: IPv4 (0x0800) 
```

## 1.3 TCP/IP Model = Internet Reference Model = Department of Defense 4 layer model
- The 4 layers of TCP/IP Model
    - Layer 5 + 6 + 7: Application Layer
    - Layer 4: Transportation Layer
    - Layer 3: Internet/ Network Layer
    - Layer 1 + 2: Link/host-to-network Layer
- OSI vs TCP/IP Model
    - OSI: 7 layers
    - TCP/IP: 4 layers


# 2 Ethernet

- Ethernet data link layer protocol (layer 2) are commonly used in LAN
- This layer is now usually implemented by logical bus/ switching designs.

## 2.1 Logical Bus Design = computers connected to hub with cables
- Internal design core logic: if 1 computer sends, others WAIT. (Only 1 computer can send data frame at the same time). 
- Logical bus design provides only **shared connection** (not the best ethernet)
- Example Scenario:
    - 4 computers connected to a hub with bandwidth 100 Mbps, each computer has 25 Mbps optimistically

## 2.2 Logical Switching Design = computers connected to switch with cables
- Internal design core logic: Virtual circuit is formed inside the switch.
- Logical Switch provides **dedicated connection**.
- Example Scenario:
    - 4 computers connected to a hub with bandwidth 100 Mbps, each computer has 100 Mbps optimistically

## 2.3 Copper Ethernet Cable
- Typical pinout of copper ethernet cable
    - Max lengths all around 100m (typically how far copper can stretch)
- Types of copper ethernet cables: 
    - UTP = Unshielded Twisted Pair Cables
    - STP = Shielded Twisted Pair Cables (has metallic foil encasing the twisted pairs as conducting shield)
        - Benefits: Less noise = less electro-magnetic interference = better speeds!!

## 2.4 Rollover Console Cable/ Rollover Cable/ Console Cable/ Serial Cable
- Typical Console Cable: RF 45 (has 4+5 = 9 pins), we use it in Cisco often
- This cable is connected to COM ports/ Computer's serial port (computer + console cable = server's COM port)
    - Or nowadays, for computers without COM port, use USD to serial adapters us ok

- Configuring a switch (IMPORTANT will show up on exam) via SecureCRT (Check session 0)

## 2.5 Fiber Optic Cable
- Exam material!! FIber Optic Cable different layers. From outmost to inmost
    - Outer jacket
    - Strength Member
    - Coasting
    - Cladding (glass)
    - Core glass / The fiber optic cable
- Fiber optic cable benefits:
    - Longer distances (over 100m until 1-2 km)
    - Less attenuation
    - Less electro-magnetic interference
- Fiber optic cable types:
    - Single Mode fiber = single mode of light
        - Longer distances (=> 10km depending on transmission type and speed)
        - Expensive (due to equipments and connectors)
    - Multi-mode fiber = carries multiple nodes of light
        - Shorter distances (< 2km depending on transmission type and speed)
        - More expensive than single mode

- Realistic example for a 10 GbE ethernet cable
    - Multi-mode fiber: 220m, 440m
    - Single-mode fiber: 10km, 40km, 80km


## 2.6 Half duplex () vs Full-duplex ethernet (dedicated non-collision enviornment)

- Comparison:
    - Half duplex: Communication flowing in 1 direction, one at a time.
        - Basically the hub in the logical bus design
        - Data Collision may occur, resulting in data corruption
            - To prevent that, CMSA/CD (Carrier Sense Multiple Access with Collision Detection) is used to reduce data collision chances 
        - Operates in shared collision environment = low data bandwidth of transmission and receiving. Since half duplex cannot transmit and receive data at the same time
    - Full duplex: Communication flowing in 2 direction together.
        - Basically the switch in the logical switching design
        - Data collision cannot occur, automatically not use CSMA/CD by design = will not perform carrier sense before data transmission
        - Able to transmit and receive data to and from other computers
        - Dedicated non-collision environment = high combined bandwidth of transmitting and receiving
        - Bandwidth is doubled comparing to half-duplex

- Important terms in the world of duplexes:
    - 1. Carrier Sense: All computer listens until medium is completely silent before data transmission.
    - 2. Collision Detection
        - if corrupted data signal is found = collision happened
        - Perform immediate backoff and stops transmission
        - Random time is waited by computer before retrying transmission
    
- Auto Negotiations by ports
    - Port can auto detect port speed and duplex mode (when both devices has the same speed & duplex mode)
    - Otherwise manual negotiation is needed

- Lab: Check duplex in a Cisco Switch
    - 1. type `enable` in SecureCRT = normal User mode `>` -> Privileged Exec Mode `#`
    - 2. Type `configure terminal` = upgrade again
    - 3. Type `interface g0/1` setting up g0/1 that is connected to back of Cisco switch
    - 4. Check for duplex type `duplex ?`

- The complicated Duplex Mismatch 
    - Idea: When a port (e.g. LAN/ switch/ router port) is operating half-duplex and the connected port is the other type or vice versa. Resulting in intermittently slow performance

    - Two possible collision types in duplex mismatching (require layer 2 above to help)
        - if Late collision (= collision after first 512 bit of info) exists = then data is present
        - if NO late collision exists = then data is NOT present
    - How to distinguish if the machine is half duplex/ full duplex based on a collision report?
        - EXAM question! Check section 0.

# 3. Detail Concepts on Logical Switching

## Terminology:
1. Broadcast data frame has destination MAC address of FF-FF-FF-FF-FF-FF (= unknown unicast/ flooding)

## 3.1 How does Switching work
- Example: 3 hosts/ computers (Host A, B, C) connected to a switch with empty MAC address table
    - 1. Host A sends to Host B
        - idea: host A source address: 00-00-00-11-11-11 to destination address 00-00-00-22-22-22
        - But MAC address doesn't contain host B
        - Data frame is **flooded** = **unknown unicast**
        - Both host B and C got the frame, host B accepts and process the frame, host C dumps the frame.
    - 2. Host B sends back to host A
        - MAC address knows where the frame came from, address table updated
        - data frame sent to port 1 (host A) only
- Broadcast frame is flooded vs unicast frame has MAC address of a single device 

## 3.2 MAC Address table aging time
- Aging time is default set at 300 second (can be increased)
- When Source Hardware address is not received by MAC address table for 300s, switch deletes the hardware address from the table = MAC Aging
- Adding to Address table = MAC learning

## 3.3 Lab: Working with MAC Access table

- Working with a Switch
    - Normal mode `#` = User Exec Mode / User Mode, which you'll see `Switch>`. The default description name/ hostname of a Cisco switch is "Switch"
        -  Display software and hardware information with `show version` or `sh ver`, press [spacebar] for more info
        - Report will tell you Switch3 has 24 FastEthernet (100Mbps) ports & 2 GB Ethernet ports
        - press [Esc] to quit the report
    - Type `en` or `enable` to promote to Privilege Exec Mode (`#`)
        - i.e. 
        ```bash
            Switch>en
            Switch#
        ```


    - Promote again to Global Configuration mode by doing `config t` or `config terminal`
        - i.e. 
        ```bash
            Switch#config t
            Enter Configuration commands...
            Switch(config)#
        ```
        - Now you can configure the switch as a whole!

    - Change hostname of the switch `hostname NewSwitchName`
        - i.e. 
        ```bash
            Switch(config)# hostname Switch100
            Switch100(config)#
        ```

    - To quit
        - `exit`: Go up 1 level (i.e. Global Configuration mode to Privileged Exec Mode)
        - `end`: Goes up 2 levels (i.e. goes up 2 levels Global Config -> User Exec Mode/ Normal Mode)

- Working with a Router
    - Check Mac Address table entries in privileged Exec Mode:
    - i.e. `show mac address-table interface g1/1` = Checking what's connected to g1/1, if no one then MAC address is empty

    - Starting up a router = you need interface configuration mode:
        - i.e. 
        ```bash
            Router>en
            Router#config t
            Router(config) #hostname Router1
            Router1(config) #int g0/0
            Router1(config-if) #no shutdown
            Router(config-if) #end
            Router1#
        ```

    - BTW The `shutdown` command to shutdown interface, vice versa, we use `no shutdown`
        - High level: User -> Privilege -> Global -> Interface mode

    - Check the mac table again `show mac address-table interface g1/1`, table is NOT empty :)


## 3.4 Collision and Broadcast domain

- Collision Domain:
    - Definition: if host in LAN are connected by hubs = same collision domain
    - When 2 host sending data together = collision to occur inside a hub
    - When host in LAN are connected by switches, they have different collision domains. Since connected to logical switching environments, collision cannot occur like that in the same domain

- Broadcast Domain: 
    - definition: if host in LAN are connected by hubs/switches ONLY = same broadcast domain
    - Router doesn't forward broadcast data frame across interfaces, since router provides segregated broadcast domains

# 4. Features in CISCO switches

## 4.1 What is VLAN
- VLAN = group of switch ports that are isolated from other switch ports
- within VLAN group cannot travel to other groups through the switch, since VLAN logically divides the switch into different independent switches at layer 2

- Checking Cisco switch ports and see which VLAN it belongs to... `show vlan brief`

- Benefits of VLAN:
    - 1. Better network performance
        - many broadcast data frames can affect switch & network performance 
        - with Multiple VLANS, they can restrict a host's broadcast to it's own VLAN members hence better performance since the broadcast is limited to its broadcast domain
    - 2. Better Security
        - VLANs can limit data frames to its own VLAN members
        - You cannot share data frames through connection to a port of another VLAN = better security
    - 3. More flexibility
        - Easy to create, reassign multiple VLAN by console commands, no involvement with physical relocation/ re-installation of cables
        - This will come up on the EXAM !!! Usually via VLAN + CDP + ...

