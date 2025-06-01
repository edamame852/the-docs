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
1. Can these 2 broadcast domains networks work when they are configured under the same network/subnet IP address?
    - ![](../../../../../assets/images/ccna/lesson5/lesson5_subnet_4.jpg)
    - Left port(g0/0): 192.168.1.1/24
    - Right port (g0/1): 192.168.1.2/24
    
    - Explaination: Subnet mask is assumed to be 255.255.255.0 with /24
    - Meaning, 192.168.1.1 and 192.168.1.2 are within the same subnet!
    - If 192.168.1.1 wants to talk to 192.168.1.2, it sends a broadcast message (192.168.1.255)
    - But if 192.168.1.2 is in a different broadcast domain, 192.168.1.1 will never learn the MAC address of 192.168.1.2
    - IP wise, they are subnets of each other BUT, they're NOT connected on a layer 2 level

    - Attempting with code:
        - 
        ```bash
        en
        config t
        int g0/0
        ip address 192.168.1.1 255.255.255.0
        no shutdown

        en
        config t
        int g0/1
        ip address 192.168.1.2 255.255.255.0
        no shutdown
        ```
    - Note: The post masked value 192.168.1.0 (the broadcast domain) overlaps g0/0
    - `incorrect IP address assignment`

2. MC will cover VLSM

3. Exam will cover Router
4. Exam will cover Router Tables 
5. Exam will test in ARP cache/ table and ask which IP address is local, and which is not ? Ans: Check the Age(min) field, whoever has `-` it will be the local one.

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

- ![](../../../../../assets/images/ccna/lesson5/lesson5_subnet_1.jpg)

- Question 4: Determine if these 2 IP are under the same internet? IP1 = 10.0.0.3 & IP2 = 10.10.1.1
    - ![](../../../../../assets/images/ccna/lesson5/lesson_5_subnet_2.jpg)
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
    - ![](../../../../../assets/images/ccna/lesson5/lesson5_subnet_3.jpg)
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
- Note: This is the non-VLSM method
- Idea of subnetting = using more bits as network ID ! (Recall IP address of classful networks are always Network ID + Host ID)

- Not using subnetting (thse following cases)
    - case 1: Class A with subnet mask 255.0.0.0
    - case 2: Any class A that ends with /8 (e.g. 100.0.0.0/8)
    - case 3: Class B with subnet mask 255.255.0.0
    - case 4: Any class B that ends with /16 (e.g. 130.10.0.0/16)
    - case 5: Class C with subnet mask 255.255.255.0
    - case 6: Any class C that ends with /16 (e.g. 192.10.0.0/24)

- Subnetting equations:
    - Equation 1: # of subnets = 2**(# of subnet bits)
    - Equation 2: # of host (per subnet) = 2**(# of host ID bits) - 2


- Question 1A: We have a class C network ID of 200.200.100.0/24, we want to divide into equal pieces of subnets using 3 subnet bits. What is the subnet mask gonna be ?
    - Ans: Well, it's not 255.255.255.0 that's for sure since it's /24, which gives us some clues to it being a Class C.
    - Step 1: Using equation 1 to find the # of subnet division
        - (# of subset) = 2**(# of subnet bits)
        - (# of subnet) = 2 ** 3 = 8, We will have 8 subnets in total
    - Step 2: Determine the subnet mask IP
        - Since we're taking 3 subnet bits = on top of the 255.255.255.x
        - in x's first 3 digits, we're taking one bits in binary. Hence, 3 ones and 5 zeros in this octet
        - so **111**00000 in binary, in decimal it's 2^7 + 2^6 + 2^5 = 224
        - So the answer is 255.255.255.224 is first entry of the last subnet, which is our subnet mask!

- Question 1B: Notice we are dividing into 8 subnets
    - Our original IP in Decimal: 200.200.100.0/24
    - Since we're taking 3 subnet bits, hence it would be 200.200.100.0/24+3 or /27 ??????
    - We're extracting the first 3 bits hence **111**00000 it's only one of the combos:
        - subnet 1: Last Octet Binary digits: **000**00000 = 0
        - subnet 2: Last Octet Binary digits: **001**00000 = 32
        - subnet 3: Last Octet Binary digits: **010**00000 = 64
        - subnet 4: Last Octet Binary digits: **011**00000 = 96
        - subnet 5: Last Octet Binary digits: **100**00000 = 128
        - subnet 6: Last Octet Binary digits: **101**00000 = 160
        - subnet 7: Last Octet Binary digits: **110**00000 = 192
        - subnet 8: Last Octet Binary digits: **111**00000 = 224
    - Hence the subnets should be...
        - [***000***] subnet 1: 0-31                => 200.200.100.0 ~ 200.200.100.31
            - Subnet's network ID / network address = 200.200.100.0     = (***000***00000)
            - This subset's first usable IP         = 200.200.100.1     = (***000***00001)
            - This subset's last usable IP          = 200.200.100.30    = (***000***11110)
            - Subnet's directed broadcast network   = 200.200.100.31    = (***000***11111)
        - [***001***] subnet 2: 32-63       => 200.200.100.0 ~ 200.200.100.30
        - [***010***] subnet 3: 64-95       => 200.200.100.0 ~ 200.200.100.30
        - [***011***] subnet 4: 96-127      => 200.200.100.0 ~ 200.200.100.30
        - [***100***] subnet 5: 128-159     => 200.200.100.0 ~ 200.200.100.30
        - [***101***] subnet 6: 160-191     => 200.200.100.0 ~ 200.200.100.30
        - [***110***] subnet 7: 192-223     => 200.200.100.0 ~ 200.200.100.30
        - [***111***] subnet 8: 224-254     => 200.200.100.0 ~ 200.200.100.30
            - Subnet's network ID / network address = 200.200.100.224   = (***111***00000) 
            - This subset's first usable IP         = 200.200.100.225   = (***111***00001)
            - This subset's last usable IP          = 200.200.100.253   = (***111***11110)
            - Subnet's directed broadcast network   = 200.200.100.254   = (***111***11111)
    - We create our subnet with this: Always the last one is for the router
        - subnet 1: last IP is used for router (200.200.100.30/27), rest is for the switch (200.200.100.1~29/27)
        - subnet 2: last IP is used for router, rest is for the switch
        - subnet 3: last IP is used for router, rest is for the switch
        - subnet 4: last IP is used for router, rest is for the switch
        - subnet 5: last IP is used for router, rest is for the switch
        - subnet 6: last IP is used for router, rest is for the switch
        - subnet 7: last IP is used for router, rest is for the switch
        - subnet 8: last IP is used for router(200.200.100.253/27), rest is for the switch (200.200.100.225~252/27)

    - Sanity check: you can mask results within the same subnet, the masked result will be the same (within the same subnet)
    - Sanity check: if you mask different subnets with subnet mask (i.e. 200.200.100.224) then the result is different

## 5.6 VLSM = Variable length subnet mask
- Background: What we did in 5.5 are all subnetting by equal parts, by equal parts I mean equal bits of subnetting (i.e. 3)
- This is our topology, we have a total of 90+2+29+13 = 105 + 29 = 145 hosts in total
- ![](../../../../../assets/images/ccna/lesson5/lesson5_vlsm_1.jpg)
- 
|  Subnetting Bits   | Post Subnetting mask | # of Subnets | Host bits | # of Valid Hosts that it can support|
|  :---: | :---:  | :---:  | :---:  | :---:  |
| 1  | /24 + **1** = /25 | 2^**1** = 2 | 8 - **1** = 7 | 2^7 - 2 = 126 |
| 2  | /24 + **2** = /26 | 2^**2** = 4 | 8 - **2** = 6 | 2^6 - 2 = 62 |
| 3  | /24 + **3** = /27 | 2^**3** = 8 | 8 - **3** = 5 | 2^5 - 2 = 30 |
| 4  | /24 + **4** = /28 | 2^**4** = 16 | 8 - **4** = 4 | 2^7 - 2 = 14 |
| 5  | /24 + **5** = /29 | 2^**5** = 32 | 8 - **5** = 3 | 2^7 - 2 = 6 |
| 6  | /24 + **6** = /30 | 2^**6** = 64 | 8 - **6** = 2 | 2^7 - 2 = 2 |

> Note: Pre subnetting network bit is 24 bits for Class C
> Note: They are FAIL! We need something to support 145 hosts! Hence, equal partiion of subnets or non-VLSM will not work in this case !!

- Benefits of VLSM
    - More efficient use of IP (since different # of bits for subnetting in different network segments)

- How to resolve this issue?
    - Step 1: resolve first subnet, it has 90 hosts.
        - 2**(# of host bit)-2 = 90
        - 2**(# of host bit) = 92
            - (2^6 = 64 bits, 2^7=128 bits), pick the bigger option, we take 128 bits, so we take 7
        - Number of host bins is 7
        - Number of 8-7 = 1 subnet bit
        - The subnet mask: /24 + ***1*** = /25 ergo (11111111.11111111.11111111.***1***0000000 = 255.255.255.128)
    - Step 2: resolve second subnet, it has 29 hosts.
        - 2**(# of host bit)-2 = 29
        - 2**(# of host bit) = 31
            - (2^4= 16 bits, 2^5 = 32 bits), pick the bigger option, we take 32 bits, so we take 5
        - Number of host bins is 5
        - Number of 8-5 = ***3*** subnet bits
        - The subnet mask: /24 + ***3*** = /26 ergo (11111111.11111111.11111111.***111***00000 = 255.255.255.224)
    - Step 3: resolve third subnet, it has 13 hosts.
        - 2**(# of host bit)-2 = 13
        - 2**(# of host bit) = 15
            - (2^3= 8 bits, 2^4 = 16 bits), pick the bigger option, we take 16 bits, so we take 4
        - Number of host bins is 4
        - Number of 8-4 = 4 subnet bits
        - The subnet mask: /24 + ***4*** = /28 ergo (11111111.11111111.11111111.***1111***0000 = 255.255.255.240)
    - Step 4: resolve fourth subnet, it has 2 hosts.
        - 2**(# of host bit)-2 = 2
        - 2**(# of host bit) = 4
            - (2^2 = 4 bits), pick the bigger option, we take 4 bits, so we take 2
        - Number of host bins is 2
        - Number of 8-2 = 6 subnet bits
        - The subnet mask: /24 + ***6*** = /30 ergo (11111111.11111111.11111111.***111111***00 = 255.255.255.252)

    - Step 5: Conclusion
        - subnet 1: 1 bit       e.g. 192.1.1.0/24+1 = 192.1.1.0/25
        - subnet 2: 3 bits      e.g. 192.1.1.0/24+3 = 192.1.1.0/27
        - subnet 3: 4 bits      e.g. 192.1.1.0/24+4 = 192.1.1.0/28
        - subnet 4: 6 bits      e.g. 192.1.1.0/24+6 = 192.1.1.0/30
        
- Question 1: Assume on floor 1 (= subnet 1) we have these 2 IPs 192.1.1.1 and 192.1.1.126 We want to check whether a router is needed <br/>
AKA, we're asking to verify if these 2 IP are living in the same subnet

Ans:
- 1. Recall in subnet 1, we're using /25. Meaning we have 25 ones, our mask is 111111111.111111111.111111111.10000000 = 255.255.255.128 
- 2. mask the first IP: 192.1.1.1 with /25, which is 255.255.255.128 
    - 192.1.1.1             = (11000000.00000001.00000001.00000001)
    - 255.255.255.128       = (11111111.11111111.11111111.10000000)
    - Masked result         = (11000000.00000001.00000001.00000000) = 192.1.1.0

- 3. mask the second IP: 192.1.1.126 with /25, which is 255.255.255.128 
    - 192.1.1.126           = (11000000.00000001.00000001.01111110)
    - 255.255.255.128       = (11111111.11111111.11111111.10000000)
    - Masked result         = (11000000.00000001.00000001.00000000) = 192.1.1.0

- 4. They have the same masked result, hence the 2 IPs can send packets without the help of a router



# 6. TCP/IP
- Facts: TCP/IP protocols cover across Layer 3 and Layer 4
    - In Layer 4 of the OSI Model, TCP/IP protocol examples include:  TCP, UDP
    - In Layer 3 of the OSI Model, TCP/IP protocol examples include:  IP, ARP, ICMP 

## 6.1 Transmission Control Protocol (TCP) [Syll 1.5]

### 6.1.1 TCP Port Numbers
- Review: port number can be anything from 0 ~ 65535
    - port number: 0 ~ 1023 is reserved for important apps
        - SSH Server uses port 22
        - Telnet Server uses port 23
        - SMTP (Simple mail transmission protocol) uses port 25
        - Web Server/ HTTP uses port 80
        - Secured Web Server/ HTTPS uses port 443
    
- Source Port Number is found in data segments's header to help identify the applicaiton. For client app, it's usually >1024 and OS dependent.
- Host A with IP 10.1.1.1 -> Router -> Server 20.4.4.4
    - From Host A to Server: <br/>
    HTTP Request + Layer 4 Header (TCP, Source Port 50000 -> Destination port 80) + Layer 3 Header (IPv4, Source IP: 10.1.1.1 -> Destination IP: 20.4.4.4) + Layer 2 Header (Ommitted)

    - From Server to Host A: <br/>
    HTTP Response + Layer 4 Header (TCP, Source Port 80 -> Destination port 50000) + Layer 3 Header (IPv4, Source IP: 20.4.4.4 -> Destination IP: 10.1.1.1) + Layer 2 Header (Ommitted)

### 6.1.2 Connection oritented protocol (i.e. TCP)

- Background: TCP's communication is a 3 step process.
    - Step 1: Call Setup = using 3 TCP packets to sync connection params
        - Packet 1: SYN = Sync only (TCP Header SYN Field = 1, TCP Header ACK Field = 0)
        - Packet 2: SYN ACK = Sync and Acknowledge (TCP Header SYN Field = 1, TCP Header ACK Field = 1)
        - Packet 3: ACK = Acknowledge only (TCP Header SYN Field = 0, TCP Header ACK Field = 1)
    - Step 2: Data Transfer: After Call Setup, connection is established, the two connected host will start data transfer
    - Step 3: Call Termination: The communication host agree to terminate the connection by sending FIN = TCP Header FIN Field is 1
    - ![](../../../../../assets/images/ccna/lesson5/lesson5_tcp_1.jpg)
### 6.1.3 Reliable Protocol 
- Background: TCP is a reliable e2e delivery protocol since TCP uses e2e devices to use ACK and windowing to perform error recovery and ensuring data is properly received

- Reliability of TCP:
    - Reliable point 1: Windowing (i.e. Transportation Layer Flow Control)
        - Window = max data segments that can be sent per attempt (up to a certiain # of bytes)
    - Reliable point 2: Acknowledgement/ ACK
        - After sending window of data -> Host waits for ACK -> Before Host sends again
    - Reliable point 3: Error Recovery
        - Host can re-trasmit if any segment is missed
    - Reliable point 4: Checksum
        - Hashed value of the data being sent, similar to CRC logic we learnt before
    - ![](../../../../../assets/images/ccna/lesson5/lesson5_tcp_2.jpg)

### 6.1.4 TCP Header Examples
- 
```bash
TCP: .AP..., len: 247, seq: 3443570798-3443571045...
TCP: Srouce Port = 0x11D9 # Note: 0x means it's a hexadecimal = base-16
```

## 6.2 UDP = User Datagram Protocol
- Background: 
    - Another Transport Layer Protocol used by TCP/IP
    - UDP uses port numbers, same as TCP
    - UDP is a connectionless protocol = doesn't want to establish connection
    - UDP is simple (= not providing sequencing, ack and windowing)
- Benefits of UDP:
    - UDP doesn't have all the features, the overhead (= pressure) is much smaller 
    - UDP can reduce network traffic
    - UDP can transfer more data when compared with TCP under same window size
- Downside of UDP:
    - Data loss is tolerable in UDP (please recover yourself in Layer 7 using ML methods lmao)
    - UDP transmits constantly

- 
```bash
UDP: Src Port: Unknown, (462); Dst Port: DNS (53); Length = 55 (0x37)
UDP: Source Port = 0x1236 #0x1236 = 4462
UDP: Destination Port = DNS
UDP: Total length = 55 (0x37) bytes
```

## 6.3 Internet Protocol = IP

### 6.3.1 - 6.3.3 IP Address, Routers, Routing Tables
- Important Concepts that we've been talking about including these 3

### 6.3.4 Detailed IP Data Packets
- ![](../../../../../assets/images/ccna/lesson5/lesson5_ip_1.jpg)
- Detail flow of data packets: Assume routing entries are already connected in the table
    - ![](../../../../../assets/images/ccna/lesson5/lesson5_ip_2.jpg)
    - Step 1: In Host A Layer 7 data translated down to Layer 3 = Network Layer 
    - Step 2: Host A undergoes routing, host A knows to send to IP 10.2.2.2 (which is the default gateway)
    - Step 3:
        - Data Link Layer converts data packet -> data frame
        - Then adds source MAC address (= MAC address of host A)
        - Then adds destination MAC address (= MAC address of Router on host A side)
    - Step 4: Frame is sent to physical layer, then send to physical medium (aka Ethernet Cable)
    - Step 5: Router can sense the signal in the physical medium, and sends frame to g0/2 port
    - Rinse and repeat


### 6.4 Address Resolution Protocol (= ARP, it's an L3 protocol)
- Uses of ARP: To find default gateway's MAC address by requesting interface IP to return MAC Address
- Background: For ARP to send out this broadcast request, it's usually in the form of a broadcast frame (with MAC Address FF-FF-FF-FF-FF-FF)

- Refering to the previous diagram, the way Host A requests MAC address is through the following steps...
    - Step 1: Host A will check ARP table/ cache for the MAC address based on the corresponding IP address 10.2.2.2
        - Check the table using `sh arp`.
        ```bash
        Protocol        Address     Age(min)        Hardware Addr           Type        Interface
        Internet        10.1.1.1            -       0000.1111.1111          ARPA        GigabitEthernet0/0
        ``` 
        - Note: Since we don't see the record (i.e. no 10.2.2.2) here. So we're using ARP to ask everyone (i.e. interfaces) with IP 10.2.2.2 to return the correct MAC address
    - Step 2A: If the corresponding MAC address is found in the ARP table. Host A will use that MAC address without sending new ARP request. End.

    - Step 2B: If the corresponding MAC address is NOT found in the ARP table. Host A will use ARP to ask all interfaces on the network, and ask "who is 10.2.2.2"
    - Step 3: Router gets the ARP request, and replies as ARP stating : from 00-00-22-22-22-22 to 00-00-11-11-11-11 that the router is 10.2.2.2
    - Step 4: ARP Request is then received by Host A, the ARP table/ cahce is UPDATED with the correct mapping on the right IP and MAC address
        - Check the table using `sh arp`.
        ```bash
        Protocol        Address     Age(min)        Hardware Addr           Type        Interface
        Internet        10.1.1.1            -       0000.1111.1111          ARPA        GigabitEthernet0/0
        Internet        10.2.2.2            2       0000.2222.2222          ARPA        GigabitEthernet0/0
        ```  
        - Note: 10.1.1.1 = Host A
        - Note: Age(min) = `-` it means it never expires, since it's also a local entry
        - Note: The 10.2.2.2 is a dynamic entry that was learned from ARP's reply, 2 mins means it's been learned for 2 mins (NOT THE TIME OF EXPIRE)
        - **IMPORTANT:By Default, Cicso's hold up time expires in 240 mins!! or 4 hours ! (the value can be changed)**

## 6.5 Internet Control Message Protocol (ICMP)
Background
- ICMP is a Network layer protocol/ L3 protocol found in all TCP/IP hosts
- ICMP can carry different message types, common ones include these 3 
    - [1. Destination Unreachable](#651-destination-unreachable) 
    - 2. Echo
    - 3. Time Exceeded

### 6.5.1 Destination unreachable
The topology: Host A (IP: 192.168.11.11) --- (IP: 192.168.11.1) Router (IP: 10.200.200.200) --- Host B (IP: 10.200.222.222)
- Step 1: Host A sends data to Router, assume connection issue with Router and Host B. Data didn't reach Host B
- Step 2: Host A doesn't know the data didn't reach Host B, it knows data reached the Router
- Step 3: ICMP "Desination unreachable" message is sent from Router to Host A to inform data cannot send


### 6.5.2 Echo
Background
- There are 2 types of Echo, Echo Request and Echo Reply
- Use of Echo Request and Echo Reply is to test connection between 2 hosts via command `ping`.
- `ping` is able to use ICMP messages to troubleshoot OSI network issues
- ![](../../../../../assets/images/ccna/lesson5/lesson5_icmp_1.jpg)

Idea of `ping`:
- `ping` is basically an echo from ICMP
- When both echo request and echo reply are received, maens that connection is properly established

Example:

```bash
ping 192.168.11.1

Pinging 192.168.11.1 with 32 bytes of data:

Reply from 192.168.11.1: bytes=32 time<10ms TTL=255
Reply from 192.168.11.1: bytes=32 time<10ms TTL=255
Reply from 192.168.11.1: bytes=32 time<10ms TTL=255
Reply from 192.168.11.1: bytes=32 time<10ms TTL=255
Reply from 192.168.11.1: bytes=32 time<10ms TTL=255
```

### 6.5.3 Time Exceeded
Background of TTL = Time to live
- TTL is the name of a field in the layer 3 header
- TTL set time is also OS dependent

TTL Concepts:
- TTL comes in preset value, OS dependent (e.g. 64,128,255)
- If router routes an IP packet, router minus 1 from the TTL before the packet sends out
- Hence why when packet loops through multiple routers, TTL field will eventually be 0. When TTL becomes 0, router will drop the packet and stop routing it and send ICMP message on "Time Exceeded". = This is a safety mechanism

Other uses of TTL:
- The cisco command `traceroute` or `trace` uses ICMP time exceeded to trace the path of the packets getting routed.
- The command `tracert <dns name>` will tell you where this packet was routed through...
```bash
tracert www.google.com

Tracing route to www.google.com [142.250.197.68]
over a maximum of 30 hops:

  1     1 ms     1 ms     1 ms  oppowifi.com [192.168.0.1]
  2     *        *        *     Request timed out.
  3    29 ms    16 ms    28 ms  192.168.245.33
  4    27 ms    17 ms    24 ms  10.145.137.100
  5    24 ms    19 ms    28 ms  wtsam031233.netvigator.com [203.198.13.233]
  6     *        *        *     Request timed out.
  7    21 ms    18 ms    29 ms  72.14.219.16
  8    36 ms    18 ms    23 ms  142.250.61.129
  9    29 ms    34 ms    29 ms  142.251.244.225
 10    18 ms    26 ms    17 ms  nchkga-ah-in-f4.1e100.net [142.250.197.68]

Trace complete.
```

# 7 Overview of Cisco Routers

## 7.1 Memory
- Non-volatile memory means, no power is needed to store memory. Data is intact in non-volatile memory
- There are 4 memory types that we will talk about.<br/>
    - ### 7.1.1 ROM (non-volatile)
        - Has power-on diagnostic mode, allow router to perform self-test + system bootstrap code and allowing full Cisco IOS image
    - ### 7.1.2 Flash memory (non-volatile)
        - It stores IOS iamges, the default location for router to get IOS image during boot up
    - ### 7.1.3 NVRAM (non-volatile)
        - NVRAM stores startup config file. Will discuss next lesson.
    - ### 7.1.4 RAM (is Volatile)
        - RAM = DRAM = Dynamic RAM in Cisco router
        - Also used in PC for memory storages
        - In Cicso routers, DRAM has 2 usages:
            - Primary RAM = storing running config, routing table, arp mappings (which clears every reboot)
            - Secondary RAM = stoes incoming & outgoing data packets

## 7.2 Starting/ Booting up a Router
- Step 1: Router performs power-on self test (POST) diagnostics to verify CPU,  memeory and interface is ok
- Step 2: System bootstrap code is ran to find Cisco IOS image, default it loads from Flash Memory
    - FYI, if the IOS image is not found in flash, it will try to get it from the **TFTP server**
    - If this fails again, IOS's ROMMON will be loaded from ROM !
    - If ROMMON fails then gg, it's a physical issue
    - Please check the source of the IOS with `sh version`.
    ``bash
        System iamge file is "flash:c2800nm-ad..."
        or
        System iamge file is "tffp://10.0.0.9/c2800nm..."
    ```
- Step 3: If IOS image is loaded okay, then router search for valid startup config in NVRAM
    - if NVRAM cannot find startup config, router runs initial config dialog = Setup Mode
    - In setup mode, you need to enter info (Host name, IP address, ...etc) during the setup = User config createion
- High level understanding (from step 1 ~ step 3): POST -> find IOS image -> find startup conf

## 7.3 Interfaces
- Console Port
    - similar to an ethernet port
- Router port namings:
    - f: 100 Mb
    - G: 1 Gb
    - T: 10 Gb
- WIC-cover
    - WAN Interface card / WIC can be inserted into Cicso 2811 router
    - WAN-2T = one of the WAN interface Card (aka WIC)
- Smart Serial
    - How its done in reality, you don't need internet to connect different countries togethe

- How to distinguish WIC slots: s0/0/0 = meaning bottom right module, bottom right slot, 1st port

