---
title: lesson_9
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
Lesson 9 - CCNA Fast Track (June, 2025). We left off at page 163.

# 0. CCNA Exam Questions
1.

# 10. Dynamic Roututing 
## 10.9 EIGRP = Enhanced Interior Gateway Routing Protocol (Dynamic)
- Intro:
    - EIGRP = Cicso proprietry dynamic routing protocol 
    - Default AD for EIGRP is 90, refer to this [AD-List](../lesson_7/#1021-administrative-distance-ad)

### 10.9.1 EIGRP AD and Metric (= Distance)
- EIGRP uses composite metric (Erog, EIGRP Metric = Bandwith + Delay)
- Let's revist some important conecepts between EIGRP vs OSPF, also refer to this [AD-list](../lesson_7/#1021-administrative-distance-ad)

| Feature                    | EIGRP                                              | OSPF                         |
|:--------------------------:|:--------------------------------------------------:|:----------------------------:|
| **Metric**                 | Composite metric (bandwidth + delay)                | Math formula: (100M/x) + (100M/y) |
| **Cisco only / Proprietary** | YES                                               | NO                           |
| **Default AD Value**       | 90                                                 | 110                          |

### 10.9.2 Configuring EIGRP in Cisco IOS
- Topology: ![](../../../../../assets/images/ccna/lesson9/lesson9_eigrp_1.jpg)
- Step 1: Setup R1
    - 
    ```text
        en
        conf t

        int g0/1
        ip address 10.0.0.1 255.0.0.0
        no shut

        int g0/0
        ip address 192.168.1.1 255.255.255.0
        no shut

        end
    ```

- Step 2: Setup R2
    - 
    ```text
        en
        conf t
        
        int g0/1
        ip address 172.16.0.2 255.255.0.0
        no shut

        int g0/0
        ip address 192.168.1.2 255.255.255.0
        no shut
        
        end
    ```

- Step 3: 
