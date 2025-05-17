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
        - Step 1. How to find Root Bridge? 
            - Method: Determined by lower Bridge ID (Bridge ID = Priority Value + MAC address). 
                - Lowest priority value (default priority value = 32768)
                - Lowest MAC address value
            - Please locate Bridge ID with `sh version` or `sh spanning-tree` on previlaged level
            - The other bridge that's not root is regarded as non-root bridge
### Attempt
![](../../../../../assets/images/ccna/test.jpg)



