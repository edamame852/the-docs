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
          - Workaround:
               - env vars plus commands `ANSIBLE_GATHERING=explicit ansible-playbook playbook.yml`. Single playbook execution, single command
               - Persist it throughout the session `export ANSIBLE_GATHERING=explicit` then `ansible-playbook playbook.yml`
               - Best way, works in all shells, all sessions for all users. Just change this line in `/opt/web-playbooks/ansible.cfg`
               
               ```yaml
                    gathering           = implicit
               ```
     5. 3 ways of viewing config
          - `ansible-config list` - list all diff configs, their default values, and values you set
          - `ansible-config view` - view the currently active ansible.cfg
          - `ansible-config dump` - post specifying different env vars, mix of config files, then view all that stuff that's already picked up by ansible (favorite command). Returns comprehensive list that contain the current settings Ansible has picked up, and where it picked up from
               - Example use case 4:
                    - Set env var to let facts gathering become explicit
                    - Then use the `dump` command to look for keyword `GATHERING`
                    - 
                    ```yaml
                         export ANSIBLE_GATHERING=explicit

                         ansible-config dump | grep GATHERING
                    ```
                    - It returns: `DEFAULT_GATHERING(env:ANSIBLE_GATHERING)=explicit`. Nice
                    - VERY VERY useful when debugging config isuses
     
     6. Intro to YAML for ansible
          - All playbooks are written in yaml and yamls are representation of configuration data
          - Playbooks are also config files
          - Data example:
               - Data at simplest form = key-value pair
                    - Example
                    ```text
                         Fruit: Apple
                         Vegetable: Carrot
                         Liquid: Water
                    ```
               - Array/ Lists
                    - Example
                    ```text
                         Fruits:
                         - orange
                         - apple

                         Vegetables:
                         - carrot
                         - tomato
                    ```
               - Dict/ Map
                    - Example
                    ```text
                         Banana:
                              Calories: 105
                              Fat: 0.4g
                         Grapes:
                              Calories: 62
                              Fat: 0.3 g
                    ```
                    - Indentation can dictate whether values will become new properties, but this is not allowed in dict since mapping values are not allowed here, throw syntax error. Workaround is to set direct value or hashmap
          - In YAML, spaces are KEY. Must be in the right form.

          - Let's take a up a notch, where we have list containing dicts containing lists
               - Example
               - Elements of list are Banana and Grape. Individual fruits has contains it's own nutritional descriptions 
               ```text
                    Fruits:
                         - Banana:
                              Calories: 105
                              Fat: 0.4g
                         - Grape:
                              Calories: 62
                              Fat: 0.3g
               ```

          - When to use dict, list & list of dicts ?
               - Ans: 
                    - Storing different info/ properties of a single object = dict
                    - if splitting the params further up in a dict = dict in dict
                    - Multiple items of the same type of object (multi object) = list/array of strings
                    - Each objects contains its own property = list of dict

          - Dict vs List
               - Dictionary - unordered collection (= properties can be defined in any order)
               - List - ordered collection (= order of items matter!)

          - (#) Hashes are comments !

          - Lab exercise:
               - Converting a dict to list

               ```yaml
                    #Before
                    employee:
                         name: john
                         gender: male
                         age: 24

                    #After
                    employees:
                         -    name: john
                              gender: male
                              age: 24

                    # Note under (-) is one object
                    # An array of object should be 
                    -    key1: value1
                         key2: value2
                    -    key3: value3
                         key4: value4

               ```


## Section 3: Ansible Inventories Configuring
1. Ansible can work with 1 or multi systems in your infra via ssh connection (in Linux) and powershell remoting (in Windows) (i.e. winrm) = Agentless = no extra software needed
- Pros: Agentless, unlike other orchestration tools that require agents before any automation workflow can be triggered

2. Ansible's target systems information are stored in an **inventory file** (written in .ini)
     - If no inventory file is under the playbook dir, it uses the default inventory.ini which is in `/etc/ansible/hosts`
     - Example of inventory.ini containing all the servers (FYI we're adding group logics to it)
     - 
     ```ini
          server1.company.com
          server2.company.com

          # You can do a group
          [mail]
          server3.company.com
          server4.company.com

          # Multiple group works as well
          [db.APAC]
          server5.company.com

          [db.EMEA]
          server6.company.com

          # Parent group with child groups, syntax is always [parent_group:children]
          [all_regions:children]
          db.APAC
          db.EMEA
     ``` 

     - Example use case 1: Adding alias for servers, achievable with keyword `ansbile_host` (which is a param in inventory.ini that specifies in FQDN or IP address of a server)

          - 
          ```ini
               web  ansible_host=server1.company.com
               db   ansible_host=server2.company.com
               mail ansible_host=server3.company.com
               web2 ansible_host=server4.company.com
          ```

3. Other common inventory params:
     - `ansible_connection` = i.e. ssh(for linux host) / winrm (for windows host) / lost
     - `ansible_port` = i.e. 22 or 5986
     - `ansible_user` = Server root/admin/other users
     - `ansible_ssh_pass` = server password

     - What's the difference between `ansible_ssh_pass` and `ansible_password`
          - `ansible_ssh_pass` = for linux/unix ssh
          - `ansible_password` = for windows WinRM
     
     - Example of different inventory params:
     - 
     ```ini
          #Defaults to port 22 for ssh
          # ansible_user defaults to root for linux machines

          web1  ansible_host=server1.company.com ansible_connection=ssh ansible_user=admin
          db   ansible_host=server2.company.com ansible_connection=ssh ansible_ssh_pass=adminpass_in_linux
          web2  ansible_host=server3.company.com ansible_connection=winrm ansible_password=adminpass_in_windows

          #If you don't have multiple boxes and want to work locally
          localhost ansible_connection=localhost
     ```

     - Saving ssh passwords in text format is extremely not ideal. Better practice would be passwords auth between servers

     - Lab will focus on setting up basic username and password without spending time configuring and debugging security issues
     
     - More advance topics in the future: Security related and Ansible vaults

4. Ansible Inventory format:
     - Q: Why do we need different inventory formats?
     - A: Think of a use case of 2 companies: start up vs hedge fund
          - start up: simple server setup for web hosting and DB management --> Simple inventory.ini is good enough (since not a lot of people and departments)
          - hedge fund: 100+ servers on the planet, lots of server functionaries: e-commerce, customer support, data analysis... (lots of structuring for different hierarchy, different inventory formats offering flexibility) --> using YAML is better
          - Inventory Formats (.ini & .yaml)
               - pros (2 things):
                    - Flexibility: grouping server based on roles (e.g. web servers, strictly DB, app servers)
                    - Geo-location: e.g. APAC, EU, AMEA
          - 2 types of inventory formats that ansible supports:
               - INI: Good for smaller projects (simple and straight forward)
                    - Example INI file:
                    - 
                    ```ini
                         [webservers]
                         web1.example.com
                         web2.example.com

                         [dbservers]
                         db1.example.com
                         db2.example.com
                    ```
               - YAML: Treat it as a file for complex org chart with diff departments and inventory formats that offers flexibility:
                    - Example YAML file:
                    - 
                    ```yaml
                         all:
                              children:
                                   webservers:
                                        hosts:
                                             web1.example.com
                                             web2.example.com
                                   dbservers:
                                        hosts:
                                             db1.example.com
                                             db2.example.com
                    ```
5. Grouping and child-parent relationship
- Real life example:
     - As an IT admin in a multi-national org, we house 100+ servers spread across diff regions serving different purposes (some web servers, some db, some app servers). Handling all servers 1 by 1 is TEDIOUS, lots of manual labor (e.g. manual select and pick servers is time consuming and human  error prone) --> Considerations for a Solution:
          - I. Categorize servers based on labels (e.g. roles, locations, environments)
          - II. Targeting one tag and so one change = applying across all other servers = **ansible grouping features**
     - Quick real life challenge: If web servers are spread across diff regions and each servers needs to have some locale specific configs?
          - Ans: Creating different groups for web servers in each region
               - Parent Group: web servers on global level
               - Child group: web servers in EACH location
                    - WebServer_US
                    - WebServer_EU
                    - WebServer_APAC
               - Define common config at parent level and child level can be only responsible for location specifics configs = much more efficient 
               - Example INI:
                    - Using the `parent:child` suffix system!
                    ```ini
                         [webservers:children]
                         webservers_us
                         webservers_eu

                         [webservers_us]
                         server1_us.com ansible_host=192.168.8.101
                         server2_us.com ansible_host=192.168.8.102

                         [webservers_eu]
                         server1_eu.com ansible_host=10.12.0.101
                         server2_eu.com ansible_host=10.12.0.102
                    ```
               
               - Example YAML:
                    - `webservers_us` & `webservers_eu` are child groups of a parent group which is parent is webserver
                    ```yaml
                         all:
                              children:
                                   webservers:
                                        children:
                                             webservers_us:
                                                  hosts:
                                                       server1_us.com:
                                                            ansible_host: 192.168.8.101
                                                       server2_us.com:
                                                            ansible_host: 192.168.8.102
                                             webserers_eu:
                                                  hosts:
                                                       server1_eu.com:
                                                            ansible_host: 10.12.0.101
                                                       server2_eu.com:
                                                            ansible_host: 10.12.0.102
                    ```

### Section 4: Ansible Variables

1. Defining ansible variables

- What are ansible variables ???
     - Ans: Same like other programming languages, variables are used to store values (e.g. single playbook for multiple servers)
          - We've worked with variables inside inventory files before
          - We can define as many vars as we like in the inventory.ini
          ```ini
               web1  ansible_host=server1.company.com ansible_connection=ssh ansible_user=admin
          db   ansible_host=server2.company.com ansible_connection=ssh ansible_ssh_pass=adminpass_in_linux
          web2  ansible_host=server3.company.com ansible_connection=winrm ansible_password=adminpass_in_windows
          ```
          - We can define the variables in ansible in 2 ways : playbook yaml or separate var file
          - Method 1: with playbook yaml
          
          ```yaml
               - 
                    name: Add DNS Server to resolv.conf
                    hosts: localhost
                    #To define vars, add this

                    vars:
                         dns_server: 10.1.250.10
                    tasks:
                         - lineinfile:
                              path: /etc/resolv.conf
                              line: 'nameserver 10.1.250.10'
          ```

          - Method 2: with separate var file

          ```yaml
               variable1: value1
               variable2: value2
          ```

2. Using ansible variables

- Example 1: Using hard coded values within playbook with a var name, enclosed in curly brackets.
     - Ansible directly applies that variable and replaces it with the stored variable value
     - The updated example playbook with curly brackets are like this:
     - 
     ```yaml
          - 
               name: Add DNS server to resolv.conf
               hosts: localhost
               # To define a variable, simply add this

               vars:
                    dns_server: 10.1.250.10
               tasks:
                    - lineinfile:
                         path: /etc/resolv.conf
                         line: 'nameserver {{ dns_server }}'
     ```

- Example 2: Setting up multiple firewall using a longer playbook
     - original playbook:
     ```yaml
          name: Set firewall configs
          hosts: web
          tasks:
          - firewalld:
               service: https
               permanent: true
               state: enabled
          - firewalld:
               port: 8081/tcp
               permanent: true
          - firewalld:
               port: 161-162/udp
               permanent: true
               state: disabled
          - firewalld:
               source: 192.0.2.0/24
               Zone: internal
               state: enabled 
     ```
     

     - Updated playbook
     ```yaml
          name: Set firewall configs
          hosts: web
          tasks:
          - firewalld:
               service: https
               permanent: true
               state: enabled
          - firewalld:
               port: '{{ http_port }}'/tcp
               permanent: true
          - firewalld:
               port: '{{ snmp_port }}'/udp
               permanent: true
               state: disabled
          - firewalld:
               source: '{{ inter_ip_range }}'/24
               Zone: internal
               state: enabled 
     ```

     You can pass the variables using a inventory file
     ```ini
     Web http_port=8081 snmp_port=161-162 inter_ip_range=192.0.2.0
     ```
     <br/>

     or better yet, create a new variable file called `web.yaml` <br/>
     This is now a host variable file, all values in this web.yaml file is available for the playbook when the playbook is ran

     ```yaml
          http_port: 8081
          snmp_port: 161-162
          inter_ip_range: 192.0.2.0
     ```

     - Jinja2 templating is exactly referring to this `single Quote curly brackets, curly brackets, single quotes` ideology 
     - Remember when using Jinja 2 templating to not forget about your quotes !! `single Quote curly brackets, curly brackets, single quotes`
     - This rule is however nullified is the Jinja 2 templating is set in between lines

     - Example yaml code for explaining Jinja2 templates
     ```yaml
          # Correct
          source: '{{ inter_ip_range }}'
          # Incorrect - missing quotes
          source: {{ inter_ip_range }}

          # Correct - nullified rule due to in between quotes
          source: hello {{ inter_ip_range }} world
     ```

3. Ansible Variable types
- Recall: Variables are used to associate information to hosts!
- String variables = sequences of chars
     - Can be used in 3 ways: defined in playbook, defined in inventory, passed as arguments from command line
     - Example
     ```yaml
          user: 'admin' # admin is the string
     ```
- Number variables = holds int or floating point values
     - Can be used with math operations
     ```yaml
          max_connections: 100
     ```
- Boolean variables = holds `true` or `false` values
     - Often used in conditional statements
     ```yaml
          debug_mode: true 

          # True - these all work btw 

          True 
          'true'
          't'
          'yes'
          'y'
          'on'
          '1'
          1
          1.0

          # False - these all work btw
          False
          'false'
          'f'
          'no'
          'n'
          'off'
          '0'
          0
          0.0
     ```

- List variables = hold collection of values (of any type)
     - Example, `packages` act as a list variable that holds 3 string values
          ```yaml
               packages:
                    - nginx
                    - postgresql
                    - git 
          ```
     - You can later refer these values individually or as a collection through something like
     ```yaml

     # Individually - using index
     msg: "This is the name of the first package {{ packages[0] }}"
     .
     .
     .
     # Collection
     loop: "{{ packages }}"
     ```

- dictionary variables = holds collection of key pair values (keys and values can be of any type)
     ```yaml
          # user is a dictionary variable hold 2 value pairs
          user:
               name: "admin" # Use double curly brackets please
               password: "secret"
     ```
     - You can later access these values by invoking the key accordingly like this
     ```yaml
          - name: Access specific value in the dictionary
               debug:
               msg: "Username: {{ user.name }}, Password: {{ user.password }}"
     ```

4. Registering variables + Variables Precedence

- What is variable precedence??
     - Ans: Think when you have 2 variables defined in 2 places.
          - File1: `/etc/ansible/hosts`
               - 
               ```ini
                    # ansible_host is a host variable
                    web1 ansible_host=172.20.1.100
                    web2 ansible_host=172.20.1.101
                    web3 ansible_host=172.20.1.102
                    
                    # I have a host group called web servers
                    # I know all hosts in my group are configured under the same DNS server
                    [web_servers]
                    web1
                    web2
                    web3
                    
                    # So this common dns server IP was set
                    [web_servers:vars]
                    dns_server=10.5.5.3
               ```
               - When Ansible playbook is ran
                    - Ansible create these host objects in memeory
                    - Ansible then define which group of hosts it belongs to (e.g. web1, web2, web3)
                         - Each host gets his own set of variables
                         - Then this will be the outcome:
                              - Group 1 = web1:
                              ```ini
                                   dns_server=10.5.5.3
                              ```
                              - Group 2 = web2
                              ```ini
                                   dns_server=10.5.5.3
                              ```
                              - Group 3 = web3
                              ```ini
                                   dns_server=10.5.5.3
                              ```
                    - Scenario 1: Say I added dns_server in the inventory for web2!
                    - 
                         ```ini
                              # ansible_host is a host variable
                              web1 ansible_host=172.20.1.100
                              web2 ansible_host=172.20.1.101     dns_server=10.5.5.4
                              web3 ansible_host=172.20.1.102
                              
                              # I have a host group called web servers
                              # I know all hosts in my group are configured under the same DNS server
                              [web_servers]
                              web1
                              web2
                              web3
                              
                              # So this common dns server IP was set
                              [web_servers:vars]
                              dns_server=10.5.5.3
                         ```
                    - Then the outcome of the ansible groups would be:
                         - 
                         ```ini


                         ```