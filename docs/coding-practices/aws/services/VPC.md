---
title: VPC
layout: default
parent: AWS 
grand_parent: Coding Practices
---


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

<img src="../../logos/VPC_1.jpg" alt="VPC A Logo" width="400"> <img 
  src="../../logos/VPC_2.png" alt="VPC B Logo" width="200">

# VPC = Virtual Private Cloud
- What does it do? 
    > **Network Isolation**: VPC allows you to create a logically isolated network within the AWS cloud, providing control over your network environment.
    {:.note}

    - Subnetting: You can divide your VPC into subnets, which are smaller segments of the network. This allows you to organize your resources and control traffic flow.
    - Security: VPC provides security features such as security groups and network access control lists (ACLs) to control inbound and outbound traffic to your resources.
    
## Gateway VPC
- A type of VPC to allow direct communication between VPCs or S3 (or any services) with VPCs