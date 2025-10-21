---
title: Ansible
layout: default
parent: Coding Practices
has_children: true
---

# Ansible

## Key-terms
1. role
2. Jinja2/ template (.j2) = offering dynamic vars and facts
3. Facts = vars that related to remote systems, OS, IP, attached file systems
4. Magic vars = vars about ansible itself (?)
5. Public Cloud (e.g. Amazon, Azure)
6. Private Cloud (e.g. VMAre)

## Udemy - Intro to Ansible

### Objectives
1. Intro to Ansible
2. Ansible Configs
3. Ansible Inventory
4. Ansible Facts and vars
5. Ansible playbook (all .yaml)
6. Ansible Modules and plugins
7. Ansible handlers
8. Ansible Templates
9. Reusing ansible content

### Section 1: Intro to Ansible
1. Ansible takes away repetitive tasks & long boring commands. As it helps with the following
     - Resource Provision (migration, applying patches, sizing, creating new hosts, compliance, security audits)
     - Config management
     - CD
     - App Deployment
     - Security Compliance
     > Note: Ansible works on DB servers, other boxes, cloud web servers, localhost!

2. Ansible = IT automation tool made simple, powerful and agentless (unlike chef, salt & puppet)
3. Ansible real use case examples:
     - e.g. 1: Shutting down web server then shut down DB, turn on DB first, turn on Web server last 
     - e.g. 2: Setting up infra on both public + private clouds (on-prem), hundreds of VMs then set up connections between the apps between public and private (+config, setting up firewall rules, ...)
4. Ansible built in modules support use cases such as e.g. 1 and e.g. 2
5. Ansible can pull live statuses...such as the following:
     - Data from CMDB to get list of target VMs
     - Trigger config when SNOW tickets gets approved

6. Go check ansible documentation

7. Ansible labs will be on KodeKloud

## Section 2: Ansible config files

1. Logics in ansible
     - Ansible will always look for a config file, default look up location is `/etc/ansible/ansible.cfg`
     - Ansible config file governs and controls the default behavior using a set of params
     - For introduction, here are 7 common Ansible section types
          - `[defaults]` = locations to modules (libs), roles, logs, plugins...
               - Example
               ```yaml
                    [defaults]

                    inventory           = /etc/ansible/hosts
                    log_path            = /var/log/ansible.log

                    library             = /usr/share/my_modules/
                    roles_path          = /etc/ansible/roles
                    action_plugins      = /usr/share/ansible/plugins/action
                    
                    gathering           = implicit # Whether Ansible should be gathering facts as default. Implicit is yes, explicit is no

                    timeout             = 10 # How long before giving up an ssh connection
                    forks               = 5  # How many hosts should ansible target when executing playbooks
               ```
          - `[inventory]` = can enable certain inventory plugins, rest will discuss later
               - Example
               ```yaml
                    [inventory]

                    enable_plugins      = host_list, virtualbox, yaml, constructed
               ```
          - `[privilage_esclation]`
          - `[paramiko_connection]`
          - `[ssh_connection]`
          - `[persistent_connection]`
          - `[colors]`

     2. Overriding ansible default vars
     - Overriding config doesn't require one to contain all values/sections, just having the overriding parts is GOOD ENOUGH. Non-overriding parts will be picked up from the next config file in the priority chain (so smart lol)
     - Default location of the ansible config is `/etc/ansible/ansible.cfg`
     - These values inside the default cfg will be considered even when the ansible executed ANYWHERE on the box
     - Example use case 1: Overriding default params with new config under same playbook dir
          - I have default ansible config at /etc/ansible/ansible.cfg
          - 3 different types of playbooks: web, db, network
               - web - just regular default config (/opt/web-playbook/)
               - db - excluding color (path: /opt/db-playbooks/)
               - network - extend default ssh timeout (path: /opt/network-playbooks/)
          - Solution: Making a copy of the original config file into each of the dirs. AKA 3 .cfg files in (/opt/xxxx/ansible.cfg) and customize each of it. Very slow solution.

     - Example use case 2: Override default configs with .cfg outside the playbook dir, maybe on parent level. AKA we're considering taking ansible-web.cfg from `/opt/web-playbooks/ansible-web.cfg` to `/opt/ansible-web.cfg`
          - Set new ansible path using env vars: `$ANSIBLE_CONFIG=/opt/ansible-web.cfg ansible-playbook.yml`
          - Default path is now `/opt/ansible-web.cfg` instead of `/etc/ansible/ansible.cfg`

     - Quick summary: total of 3 methods introduced just now to trigger ansible playbooks
          - Run as default, targeting config file `/etc/ansible/ansible.cfg` (4th priority)
          - Have .cfg file in any sub-dir or nested dirs (2nd priority)
          - Specifying env vars `ANSIBLE_CONFIG` (1st priority)

     3. Ansible config hierarchy logic (There's 4 in total)
          - 1st priority - env var `ANSIBLE_CONFIG`
          - 2nd priority - current dir's ansible.cfg (/current/ansible.cfg)
          - 3rd priority - ansible.cfg on home (/home/user/ansible.cfg)
          - 4th priority - Default `/etc/ansible/ansible.cfg`

     4. New use case, Example use case 3: Got new playbooks but don't want custom configs for all
          - Solution: 
               - set gathering facts from implicit to explicit
               - Have all ansible.cfg gather facts with default config instead of creating anew .cfg in playbook's directory
          - Issue:
               - Default /etc/ansible/ansible.cfg has the following content
               - 
               ```yaml
                    gathering           = implicit
               ```
          - Workaround 
