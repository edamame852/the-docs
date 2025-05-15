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

1. 

# 1. Networking Model

## 1.1 OSI Reference Model
- OSI model is released by ISO
- Has 7 layers, **Please Do Not Trust Sales Person Advice** (Layer 1 to Layer 7)
    - Layer 7: Application = protocols that directly supports user apps, interface for sending and getting data
        - Common Application layer: HTTPS (default port: 443), HTTP(default port: 80), SNMP, SSH, DHCP, FTP, TFTP
        .
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
    - Layer 2: Data Link [information name: frame]
    - Layer 1: Physical [information name: bit]

## 1.3 TCP/IP Model = Internet Reference Model
- Layer 5 + 6 + 7: Application
- Layer 4: Transportation
- Layer 3: Internet/ Network
- Layer 1 + 2: Link/host-to-network
 