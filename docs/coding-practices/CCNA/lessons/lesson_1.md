---
title: lesson_1
layout: default
parent: CCNA
grand_parent: Coding Practices
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
            - FCS field contains a value that is calculated by CRC algorithim, the output of the algo is sent by the sender and checked again the value calculated by receiver
            - If FCS Check fails = receiver dumps data frame = gives CRC error, franes are lost, input error count increases!! 
        - **MAC Address = physical address = hardware address**
            - MAC Address is 48 bits long = 24 bits Verdor Code/ OUI/ Organizationally Unique Identifier + 24 bits Vendor Assigned Code
            - Find MAC Address in cmd console: `arp -a`
        - Example protocol: Ethernal - Using MAC (Media Access Control) address (12 Dec code/16 Hex code). These MAC address are included in network interface devicies (e.g. network cards)
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

- 

## 2.1 Logical Bus Design = computers connected to hub with cables
- Internal design core logic: if 1 computer sends, others WAIT. (Only 1 computer can send data frame at the same time)