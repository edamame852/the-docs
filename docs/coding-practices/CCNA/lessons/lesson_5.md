---
title: lesson_5
layout: default
parent: CCNA
grand_parent: Coding Practices
---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
5th Lesson - CCNA Fast Track (May 27, 2025). We left off at page 80.

# 0. CCNA Exam Questions



# 5. IP Address
## 5.4 Subnet Masking

### 5.4.1 Subnet Overview
- IPv4 and Subnet mask: both 32 bits (= 4 * otects bits)

- Classful Networks: Network ID + Host ID
    - Class A: Binary (11111111.00000000.00000000.00000000) or Decimal (255.0.0.0) or /8 bit
    - Class B: Binary (11111111.11111111.00000000.00000000) or Decimal (255.255.0.0) or /16 bit
    - Class C: Binary (11111111.11111111.11111111.00000000) or Decimal (255.255.255.0) or /24 bit
- Rules of masked subnet:
    - Network ID bits of the IP must have **consecutive** ones (1) bits on the left.
    - Host ID bits of the IP must have **consecutive** zeros (0) bits on the right.

- Question 1: Is this a valid subnet mask ? IP: 255.255.248.0 ?
- Ans: In binary it's 11111111.11111111.11111000.00000000, use long division on 248 and get the reverse modulus = the answer in 1s and 0s.

- Question 2: Is this a valid subnet mask ? IP: 255.255.200.0 ?
- Ans: In binary it's 11111111.11111111.**11001000**.00000000, use long division on 200 and get the reverse modulus = the answer in 1s and 0s.

- Question 3: What is the subnet mask for this ip address 192.168.0.0.1?
- Ans: It was selected as 255.255.255.0, I assume that because 192 is a Class C IP, hence we use the Class C subnet


### 5.4.2 What is subnet mask used for?
- Main function: Subnet mask can help predict host behavior = to figure out if the 2 hosts are in the same network
    - if yes: No router is needed :D
    - if no: Router is needed to send packet

- Question 4: Determine if these 2 IP are under the same internet? IP1 = 10.0.0.3 & IP2 = 10.10.1.1
    - Step 1: Determine classful. Ans: This is Class A. Hence the subnet mask is 255.0.0.0
    - Step 2: Mask the first IP with subnet mask
        - IP1:          10.0.0.3    (00001010.00000000.00000000.00000011)
        - subnet mask:  255.0.0.0   (11111111.00000000.00000000.00000000)
        - APPLY AND GATE logic
        - Result:                   (00001010.00000000.00000000.00000000) = 10.0.0.0
        

    - Step 3: Mask the second IP with subnet mask 
        - IP2:          10.10.1.1   (00001010.00001010.00000001.00000001)
        - subnet mask:  255.0.0.0   (11111111.00000000.00000000.00000000)
        - APPLY AND GATE logic
        - Result:                   (00001010.00000000.00000000.00000000) = 10.0.0.0
    - Step 4: Compared the masked result
        - In this case they are the same, hence it's the same network, router is not needed


- Question 5: Determine if these 2 IP are under the same internet? IP1 = 10.0.0.3 & IP2 = 159.159.3.3
    - Step 1: Determine classful. Ans: This is Class A. Hence the subnet mask is 255.0.0.0
    - Step 2: Mask the first IP with subnet mask
        - IP1:          10.0.0.3    (00001010.00000000.00000000.00000011)
        - subnet mask:  255.0.0.0   (11111111.00000000.00000000.00000000)
        - APPLY AND GATE logic
        - Result:                   (00001010.00000000.00000000.00000000) = 10.0.0.0
        

    - Step 3: Mask the second IP with subnet mask 
        - IP2:          159.159.3.3 (10011111.10011111.00000011.00000011)
        - subnet mask:  255.0.0.0   (11111111.00000000.00000000.00000000)
        - APPLY AND GATE logic
        - Result:                   (10011111.00000000.00000000.00000000) = 159.0.0.0
    - Step 4: Compared the masked result
        - Theya have different results, hence it's NOT the same network, router is needed D:


## 5.5 Subnetting = breaking down classful network (A,B,C,D) -> A1, A2, A3 ..., B1, B2, ...
- Idea of subnetting = using more bits as network ID ! (Recall IP address of classful networks are always Network ID + Host ID)

- Not using subnetting (thse following cases)
    - case 1: Class A with subnet mask 255.0.0.0
    - case 2: Any class A that ends with /8 (e.g. 100.0.0.0/8)
    - case 3: Class B with subnet mask 255.255.0.0
    - case 4: Any class B that ends with /16 (e.g. 130.10.0.0/16)
    - case 5: Class C with subnet mask 255.255.255.0
    - case 6: Any class C that ends with /16 (e.g. 192.10.0.0/24)