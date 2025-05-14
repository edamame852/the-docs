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

# 0. CCNA Exam stuff

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
    - Layer 4: Transport [inforamtion name: segment] = Segments + re-assemble data for transporting data efficiently. 
        - On layer 4, note ports numbers can differntiate differnet app data
        - Common Transport layer: TCP vs UDP
            - TCP (Transmission Control Protocal): CONNECTION oriented. First establish connect connection, then send data.
            - UDP (User Datagram Protocol): CONNECTION**LESS**
    - Layer 3: Network [inforamtion name: packet]
    - Layer 2: Data Link [inforamtion name: frame]
    - Layer 1: Physical [inforamtion name: bit]

## 1.3 TCP/IP Model = Internet Refernce Model
- Layer 5 + 6 + 7: Application
- Layer 4: Transportation
- Layer 3: Internet/ Network
- Layer 1 + 2: Link/host-to-network
 