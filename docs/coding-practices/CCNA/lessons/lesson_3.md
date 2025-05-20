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

# 4. Features in CISCO switches
## 4.3 Default VLAN

- Showing default vlan with `sh vlan`...
    - 
    ```bash
    VLAN    Name                Status      Ports
    -----------------------------------
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
    - The 8 ports are all under VLAN 1

- VLAN has 2 different ranges:
    - VLAN 1-1005 = Normal Range
    - VLAN 1006-4094 = Extended Range
