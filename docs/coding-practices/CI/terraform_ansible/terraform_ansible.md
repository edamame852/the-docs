---
title: terraform_ansible
layout: default
parent: CI
grand_parent: Coding Practices
has_children: true
---
# Basic Terminologies
1. OCS: VM instance created on private cloud based on Openstack (self-managed)
2. VCS: VM instance created on private cloud based on VMWare (Global Tech Service team managed)
    - IMAGE: OS template
    - FLAVOR: Size of Ram, CPU and Disk storage
    - KEYPAIR: SSH key-pair
    - SECURITY GROUPS: referring to firewall rules
    - NETWORK (zone): the zone the instance is in
3. Cloud Platform XaaS: Anything as a Service (An Unitary infra.) - including OCS and VCS
4. IaC: Infra as Code - referring to ansible and terraform
    - Ansible: Config management, software installation... = deployment automation = managing application and env at scale
        - Pros:
            - Agentless: works via ssh, no need to install agent on target VM
            - Declarative language: using yaml to write structured playbooks to describe auto tasks
            - Config management: via playbook
            - easy to use
            - uniformity: consistent config across uat, dev and prod env
            - centralization: centralizing config management and simplifying node syncs
            - process automation: coordinating complex tasks between servers (i.e. cronjobs)
            - consistent execution: 
    - Terraform: Provisioning infra from data center (i.e. VM) = an open source tool by HashiCorp

# Setting up VCS terraform & ansible


# Setting up OCS w/ terraform & ansible
1. in project, create new .yml workflow under .github.workflows
2. 
