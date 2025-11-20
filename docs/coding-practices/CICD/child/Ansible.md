---
title: Ansible
layout: default
parent: CICD
grand_parent: Coding Practices
has_children: true
---

# Non-SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Ansible

## Key-terms
1. role
2. Jinja2/ template (.j2) = offering dynamic vars and facts
3. Facts = vars that related to remote systems, OS, IP, attached file systems
4. Magic vars = vars about ansible itself (?)
5. Public Cloud (e.g. Amazon, Azure)
6. Private Cloud (e.g. VMAre)

### Udemy - Intro to Ansible

## Objectives
1. Intro to Ansible
2. Ansible Configs
3. Ansible Inventory
4. Ansible Facts and vars
5. Ansible playbook (all .yaml)
6. Ansible Modules and plugins
7. Ansible handlers
8. Ansible Templates
9. Reusing ansible content

## Section 1: Intro to Ansible
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
                    - 
                    ```text
                         Fruit: Apple
                         Vegetable: Carrot
                         Liquid: Water
                    ```
               - Array/ Lists
                    - Example
                    - 
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
                    - 
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
               - 
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
               - 
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
                                             webservers_eu:
                                                  hosts:
                                                       server1_eu.com:
                                                            ansible_host: 10.12.0.101
                                                       server2_eu.com:
                                                            ansible_host: 10.12.0.102
                    ```

## Section 4: Ansible Variables

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
                         line: 'nameserver {% raw %}{{ dns_server }}{% endraw %}'
     ```

- Example 2: Setting up multiple firewall using a longer playbook
     - original playbook:
     - 
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
     - 
     ```yaml
          name: Set firewall configs
          hosts: web
          tasks:
          - firewalld:
               service: https
               permanent: true
               state: enabled
          - firewalld:
               port: {% raw %}'{{ http_port }}'{% endraw %}/tcp
               permanent: true
          - firewalld:
               port: {% raw %}'{{ snmp_port }}'{% endraw %}/udp
               permanent: true
               state: disabled
          - firewalld:
               source: {% raw %}'{{ inter_ip_range }}'{% endraw %}/24
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
          source: {% raw %}'{{ inter_ip_range }}'{% endraw %}
          # Incorrect - missing quotes
          source: {% raw %}{{ inter_ip_range }}{% endraw %}

          # Correct - nullified rule due to in between quotes
          source: hello {% raw %}{{ inter_ip_range }}{% endraw %} world
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

- Registering variables will be addressed in point 5
- Variable precedence: Extra Variables > Play variables > Host Variables > Group Variables

- What is variable precedence??
     - Ans: Think when you have 2 variables defined in 2 places.
          - File1: `/etc/ansible/hosts`
               - This is our base case
               - 
               ```text
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
                    - Ansible create these host objects in memory
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
                    - Scenario 1: Say I added dns_server in the inventory for web2! Then which one will be considered by Ansible ???
                    - 
                    ```ini
                         # ansible_host is a host variable
                         web1 ansible_host=172.20.1.100
                         # Note, even when you do this, ansible considers the host variables before associating with group variables!
                         
                         # dns_server=10.5.5.4 is a host variable! So it's prioritized
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
                         - web1
                         ```ini
                              dns_server=10.5.5.3
                         ```
                         - web2
                         ```ini
                              # Prioritizing host variable first!
                              dns_server=10.5.5.4
                         ```
                         - web3
                         ```ini
                              dns_server=10.5.5.3
                         ```
               - Scenario 2: Variables defined within a playbook
                    - Playbook defining a different value for dns servers. AKA defining variables at play level
                         ```yaml
                              ---
                              - name: Configure DNS Server
                                hosts: all
                                vars:
                                  dns_server: 10.5.5.5
                                tasks:
                                - nsupdate:
                                   server: '{{ dns_server }}'
                         ```
                    - Then the outcome of the ansible groups would be:
                         - web1
                         ```ini
                              # Prioritizing play variable!!!
                              dns_server=10.5.5.5
                         ```
                         - web2
                         ```ini
                              # Prioritizing play variable!!!
                              dns_server=10.5.5.5
                         ```
                         - web3
                         ```ini
                              # Prioritizing play variable!!!
                              dns_server=10.5.5.5
                         ```
               - Scenario 3: Using `--extra-vars` to pass variables via command line
                    - Example:
                    ```bash
                         ansible-playbook playbook.yml --extra-vars "dns_server=10.5.5.6"
                    ```
- These are just a few scenario to pass in vars
     - The full list is [here](https://docs.ansible.com/ansible/2.5/user_guide/playbooks_variables.html)
     - But roughly the hierarchy is as follows
     - Role Defaults < Group Vars < Host Vars < Host Facts < Play Vars < Role Vars < Include Vars < Set Facts < Extra Vars


5. REGISTERD variables - Passing variables for later use (= concepts of registering variables)
- Little workflow playbook example to print the file etc/hosts on a server
     - Example output
     ```bash
          PLAY [Check /etc/host file] ***************************************

          TASK [shell] ***********************************************
          changed: [web1]
          changed: [web2]

          PLAY RECAP ************************************************
          web1      : ok=1 changed=1 unreachable=- failed=0 skipped=0 rescued=0 ignored=0
          web2      : ok=1 changed=1 unreachable=- failed=0 skipped=0 rescued=0 ignored=0
     ```
- Now: We would like to add an extra command to capture the output of the first command and then pass it to the second command = solution: using the debug module

     - This is what playbook.yml would look like
     - Note: Different module returns results in different format
          - 
          ```yaml
               ---
               - name: Check /etc/hosts file
               hosts: all
               tasks:
               - shell: cat /etc/hosts 
                    register: result

               - debug: 
                    var: {% raw %}{{ result }}{% endraw %}
          ```
          - `cat /etc/hosts` = 1st command, using the shell module. Using the register directive to store the output value, don't forget to specify the variable name
          - `var: result` = # Specifies the var in the 2nd command as var

     - The shell module returns the output as the following
          - the `rc` paramter is 0 if the command runs successfully
          - the `delta` param indicates the time it takes to run the command into completion
          - the `stdout` param to indicate the standard out of the commands
          - 
          ```text
               ok:[web2] => {
                    "output" : {
                         "ansible_facts": {
                              "discovered_interpreter_python":"/usr/bin/python"
                         },
                         "changed": true,
                         "cmd":"cat /etc/hosts",
                         "failed": false,
                         "rc":0,
                         "start": "xxxxxxxxxxxx",
                         "xxx":"xxxxxx so on and so forth", 
                    }
               }
          ```
          - Thing to consider...
               - We're only interested in the contents of the `/etc/hosts` file, we're only interested in the contents of `stdout` and `stdout_lines`
               - We can update our playbook's second part !!
                    - UPDATED playbook.yml
                    - 
                    ```yaml
                         # Note: Different module returns results in different format
                         ---
                         - name: Check /etc/hosts file
                         hosts: all
                         tasks:
                              - shell: cat /etc/hosts # 1st command, using the shell module
                         # Using the register directive to store the output value, don't forget to specify the variable name
                              register: result

                              - debug: 
                              var: result.stdout # Specify the var in the 2nd command as var
                    ```

               - Scope of the registered variable `result` for web1 and web2
                    - web1
                         - 
                         ```yaml
                              result
                         ```
                    - web2
                         - 
                         ```yaml
                              result
                         ```
                    - Since it's under the host scope, they can still be used in the next play if required

                    - So this playbook.yaml is valid
                    - 
                    ```yaml
                         # Note: Different module returns results in different format
                         ---
                         - name: Check /etc/hosts file
                         hosts: all
                         tasks:

                         - shell: cat /etc/hosts 
                           register: result

                         - debug: 
                           var: result.rc

                         - name: Play2
                           hosts: all
                           tasks:
                           - debug:
                              var: result.rc # Can only be used within the scope of the host
                    ```

- Side quest: Another way to visualize the contents of /etc/hosts without using the module
     - Solution: passing the `-v` option while triggering the playbook
     - playbook.yaml
     - 
     ```yaml
          ---
          - name: Check /etc/hosts file
            hosts: all
            tasks:
            - shell: cat /etc/hosts
     ```
     - `ansible-playbook -i inventory playbook.yaml -v`

     - This will be your output:
     ```bash
          PLAY [localhost] ***************************************

          TASK [Gathering Facts] ***********************************************
          ok: [localhost]

          TASK [shell] ***********************************************
          changed: [localhost] => {"changed": true , "cmd" : "cat /etc/hosts", "delta": "0:00:00.282432", "end" : "2019-09-24 07:37:26.440478", "rc" : 0, "start" : "xxxxxxxx"}


          PLAY RECAP ************************************************
          localhost      : ok=2 changed=1 unreachable=0 failed=0
     ```

6. Variable Scoping
- What's a scope of a variable in Ansible ?
     - Long story short... a scope defines the accessibility/visibility of a variable
     - Say in this inventory file under `/etc/ansible/hosts`
     ```ini
          web1 ansible_host=172.20.1.100
          web2 ansible_host=172.20.1.101 dns_server=10.5.5.4
          web3 ansible_host=172.20.1.102
     ```

     - And we also have this playbook
          - 
          ```yaml
               ---
               - name: printing dns server
               hosts: all
               tasks:
               - debug:
                    msg: {% raw %}"{{ dns_server }}"{% endraw %}
          ```
     - Question... Does the dns_server (defined within web2 in the inventory) variable work for the other hosts, aka web1 and web3 ? Since they don't have any pre-defined dns_server params in in the inventory ?
     - Ans:  NO, and if you return these, they will return `VARIABLE IS NOT DEFINED!`. Since the variable is defined under the host scope only

     - Different scope levels...
          - Whether it be on the parent group, on the host, on the play...
          - We will only focus on these scopes
               - 1 - Host scope (defined on host level under the inventory lines or group variable, or group of group of variables, ultimately when play is triggered, it just lives in the host scopes)
                    
               - 2 - Play scope (defined on playbook.yaml)
                    - Example playbook
                    - 
                    ```yaml
                         ---
                         - name: Play1
                           hosts: web1
                           vars:
                              ntp_server: 10.1.1.1
                           tasks:
                           - debug:
                              var: ntp_server
                         
                         - name: Play2
                           hosts: web1
                           tasks:
                           - debug:
                              var: ntp_server # variable not avaliable in 2nd play, since scope of variable ntp_server is only within the 2st play
                    ```
                    - Output
                    - 
                    ```bash
                         PLAY [Play1] ***************************************

                         TASK [debug] ************************************
                         ok: [web1] => {
                              "ntp_server": "10.1.1.1"
                         }

                         PLAY [Play2] ***************************************

                         TASK [debug] ************************************
                         ok: [web1] => {
                              "ntp_server": "VARIABLE IS NOT DEFINED!"
                         }
                    ```
               - 3 - Global scope (as extra variables)
                - Example: 
                ```bash
                    ansible-playbook playbook.yaml --extra-vars "ntp_server=10.1.1.1"
                ```
     - Scope is import for understanding the concept of **Magic Variables**

7. Magic Variables in Ansible
     - Revist: Variable Scopes = 
          - host variables associated with each host
          - For example, when this inventory file is ran
               - 
               ```ini
                    web1 ansible_host=172.20.1.100
                    web2 ansible_host=172.20.1.101 dns_server=10.5.5.4
                    web3 ansible_host=172.20.1.102
               ```
          - And we also have this playbook
          - 
          ```yaml
               ---
               - name: printing dns server
               hosts: all
               tasks:
               - debug:
                    msg: {% raw %}"{{ dns_server }}"{% endraw %}
          ```
          - It creates 3 streams of sub-processes when playbook starts sourcing from the inventory file
               - web1
               - web2
               - web3
          - Before the tasks are ran on each host, ansible goes through **variable interpoliation** stage, where ansible attmepts to pick up variables from different places and associate thems with different host.

          - Each variable is only associated with it's defined host, so it's unavaliblable to others (as we talked about in variable scope)

          - You can't get it for other hosts lolol, end of story...or is that it? How can one Ansible subprocess running task for one host gaet variables that is only defined on another host
          - In our example, the example would be: "How can web1 and web3 pick up the dns_server variable that is only defined in web2" ==> Solution: Using magic variables!!

     - One of the great magic variables: `hostvars`, can get variables defined on a different host
          - And we can update this playbook with `hostvars` by sourcing the var directly from web2 to be used in other hosts!
          - 
          ```yaml
               ---
               - name: printing dns server
               hosts: all
               tasks:
               - debug:
                    msg: {% raw %}"{{ hostvars['web2'].dns_server }}"{% endraw %}
          ```
          - Other common (default) magic variables:
               - `hostvars['web2'].ansible_host` = to get hostname or IP of the other host
               - If facts are gathered... you can access additional facts about other hosts: Any facts can be retrived like this 
                    - `hostvars['web2'].ansible_facts.architecture`
                    - `hostvars['web2'].ansible_facts.devices`
                    - `hostvars['web2'].ansible_facts.mounts`
                    - `hostvars['web2'].ansible_facts.processor`
          - Note: Magic variables can be accessed using brackets or single quotes!
               - `hostvars['web2']['ansible_facts']['architecture']`
               - `hostvars['web2']['ansible_facts']['devices']`


     - Another useful magic variable: `groups`, which returns all hosts under a given group
          - in `/etc/ansible/hosts`
          ```ini
               web1 ansible_host=172.20.1.100
               web2 ansible_host=172.20.1.101
               web3 ansible_host=172.20.1.102

               [web_servers]
               web1
               web2
               web4

               [americas]
               web1
               web2

               [apac]
               web3
          ```

          - If we use `groups`
          - 
          ```yaml
               msg: {% raw %}'{{ groups['americas'] }}'{% endraw %}
          ```

          - The output would be 
          - 
          ```bash
               web1
               web2
          ```

     - Magic variable `group_names` is the other way around, it returns all the groups that the current host is a part of 
          - in `/etc/ansible/hosts`
          - 
          ```ini
               web1 ansible_host=172.20.1.100
               web2 ansible_host=172.20.1.101
               web3 ansible_host=172.20.1.102

               [web_servers]
               web1
               web2
               web4

               [americas]
               web1
               web2

               [apac]
               web3
          ```

          - If we use `groups_names`
          - 
          ```yaml
               msg: {% raw %}'{{ groups_names }}'{% endraw %} # On host web1
          ```

          - The output would be the following when you trigger a play
          - 
          ```bash
               web_servers
               americas
          ```
          - Returning the groups that this host is a part of

     - Magic variable `inventory_hostname` gives you the name configured for the host in the inventory file and not the host name or FQDN
          - in `/etc/ansible/hosts`
          - 
          ```ini
               web1 ansible_host=172.20.1.100
               web2 ansible_host=172.20.1.101
               web3 ansible_host=172.20.1.102

               [web_servers]
               web1
               web2
               web4

               [americas]
               web1
               web2

               [apac]
               web3
          ```

          - If we use `inventory_hostname`
          - 
          ```yaml
               msg: {% raw %}'{{ inventory_hostname }}'{% endraw %} # On host web1
          ```

          - The output would be the following

          ```bash
               web1 # Not the hostname nor FQDN
          ```

8. Ansible Facts

- Logic flow of how Ansible works
     - Ansible connects to a target machine
     - Step 1: Collects information of the target machine (i.e. host's network connectivity)
          - e.g. basic system info
          - e.g. system architecture
          - e.g. version of os
          - e.g. processor details
          - e.g. memory details
          - e.g. serial numbers
          - Particular information (i.e. ***Ansible Facts**)
               - e.g. host's network connectivity
               - e.g. Different interfaces
               - e.g. IP Addresses, FQDN
               - e.g. MAC Address
               - e.g. device information (e.g. different disk, volume, mounts, amount of space avaliable)
               - e.g. date & time on the system
     - Step 2: Ansible facts gather facts using the setup module while using a playbook, fyi the setup module runs automatically

- Example 1: using ansible to print a message

     - playbook.yaml
     - 
     ```yaml
          ---
          - name: Print Hello Message
            hosts: all
            tasks:
            - debug:
              msg: Hello from Ansible!
     ```

     - In the ouput, you can see it's running 2 tasks...
     ```bash
          PLAY [Print Hello Message] ******************************

          TASK [Gathering Facts] ******************************
          ok: [web2]
          ok: [web1]

          TASK [debug] ******************************
          ok: [web1] => {
               "msg": "Hello from Ansible!"
          }
          ok: [web2] => {
               "msg": "Hello from Ansible!"
          }
     ```

- But how do you see the FACTS? Ans: They're stored under a variable called `ansible_facts`
     - You can adjust the playbook this way to print all the facts!

     - updated playbook.yaml
     - 
     ```yaml
          ---
          - name: Print Hello Message
            hosts: all
            tasks:
            - debug:
              var: ansible_facts
     ```

     - This is the output that should entail about the host's IP, system bit (64/32), flavor, DNS server configs, CPU process chip type,  
     - 
     ```bash
          PLAY [Reset nodes to previous state] *********************************

          TASK [Gathering Facts] ********************************
          ok: [web2]
          ok: [web1]

          TASK [debug] ********************************
          ok: [web1] => {
               "ansible_facts": {
               "all_ipv4_address": [
                    "172.20.1.100"
               ],
               "architecture": "x86_64",
               "date_time": {
                    "date": "2019-09-07",
               },
               "distribution":"Ubuntu",
               "distribution_file_variety":"Debian",
               "distribution_major_version":"16",
               "distribution_release":"xenial",
               "distribution_version":"16.04",
               "dns":[
                    "nameservers":[
                         "127.0.0.11"
                    ],
               ],
               "fqdn":"web1",
               "interfaces":[
                    "lo",
                    "eth0"
               ],
               "machine":"x86_64",
               "memfree_mb":72,
               "memory_mb": {
                    "real":(
                         "free": 72,
                         "total": 985,
                         "used":913
                    ),
               },
               "memtotal_mb":985,
               "module_setup":true,
               "mounts":[
                    {
                         "block_available": 45040,
                         "block_size": 409G,
                         "block_total":2524608,
                         "block_used":2479668
                    },
               ],
               "nodename":"web1",
               "os_family":"Debian",
               "processor":[
                    "O",
                    "GenuineIntel",
                    "Intel(R)Core(TM)i9 9980HK CPU 2.40GHz",
               ],
               "processor_cores":2,
               "processor_count":1,
               "processor_threads_per_core":1,
               "processor_vcpus":2,
               "product_name": "VirtualBox",
               "product_serial":"U",
               "product_uuid":"18A111 222 DAC9 1321 54643155",
               "product_version":"1.2"
          }
     ```

     - These details are super useful as you're configuring devices and logical volume on your nodes, you can make certain decisions based on the information about the target disk/host that all information are gathered as facts.

- Example 2: Assume you don't want any gathered facts, so you wish to disable athering facts
     - You can do so via `gather_facts: no`
     - playbook example:
     - 
     ```yaml
          ---
          - name: Print Hello Message
            hosts: all
            gather_facts: no
            tasks:
            - debug:
              var: ansible_facts
     ```

     - output would be only but a single task
     - 
     ```bash
          PLAY [Print Hello Message] ******************************


          TASK [debug] ******************************
          ok: [web1] => {
               "ansible_facts":{}
          }
          ok: [web2] => {
               "ansible_facts":{}
          }
     ```

- Note: Ansible gather facts is also dictated by a default setting in the ansible confg
     - If you reacll...in our `/etc/ansible/ansible.cfg`
     - 
     ```ini
          # plays will gather facts by default, which contain information about
          # smart - gather by default, by don't regather if already gathered
          # implicit - gather by default, turn off with gather_facts: False
          # explicit - do not gather by default, must say gather_facts: True

          gathering      = implicit # Meaning ansible defaults to gathering facts 

          # if set to "explicit", it's default to not gather facts but can be regather via the playbook (i.e. gather_facts: yes)
     ```

     - Scenario: What happens if you have CONFLICTING setup for the playbook as well as the .cfg file ?
     - Ans: As you recall, the playbook settings ALWAYS take pirority (so the playbook.yaml takes no matter what)

     > Really important note: Ansible only gather facts against the hosts that are part of the playbook!

     - Example to explain what it means...
          - playbook example:
          - 
          ```yaml
               ---
               - name: Print Hello Message
               hosts: all
               tasks:
               - debug:
               var: ansible_facts
          ```
          - in `/etc/ansible/hosts` inventory file
          ```ini
               web1
               web2
          ```

          - Outcome: In this case, facts will only be gathered for web1. 
          - If at anytimes, when facts are unavailable for some hosts...very likely could be that you haven't targeted those hosts in your playbooks and inventory files!


### Lab 3: Ansible variables and facts

1. Question... just know the following setups lol
```text
     In this lab exercise you will use below hosts. Please note down some details about these hosts as given below :


     student-node :- This host will act as an Ansible master node where you will create playbooks, inventory, roles etc and you will be running your playbooks from this host itself.


     node01 :- This host will act as an Ansible client/remote host where you will setup/install some stuff using Ansible playbooks. Below are the SSH credentials for this host:


     User: bob
     Password: caleston123


     node02 :- This host will also act as an Ansible client/remote host where you will setup/install some stuff using Ansible playbooks. Below are the SSH credentials for this host:


     User: bob
     Password: caleston123


     Note: Please type exit or logout on the terminal or press CTRL + d to log out from a specific node.
```

- I see there are 3 files under `~/playbooks/`:
     - ansible.cfg
     ```bash
          -bash-5.1$ cat ansible.cfg 
          [defaults]
          host_key_checking = False
     ```

     - inventory
     ```bash
          -bash-5.1$ cat inventory 
          localhost ansible_connection=local nameserver_ip=8.8.8.8 snmp_port=160-161
          node01 ansible_host=node01 ansible_ssh_pass=caleston123
          node02 ansible_host=node02 ansible_ssh_pass=caleston123
          [web_nodes]
          node01
          node02

          [all:vars]
          app_list=['vim', 'sqlite', 'jq']
     ```


     - playbook.yaml
     ```bash

          -bash-5.1$ cat playbook.yaml 
          ---
          - name: 'Add nameserver in resolv.conf file on localhost'
          hosts: localhost
          become: yes
          tasks:
          - name: 'Add nameserver in resolv.conf file'
               lineinfile:
               path: /tmp/resolv.conf
               line: 'nameserver 8.8.8.8'
     ```

2. Can we define variables in an Ansible inventory file?
     - Ans: Yes
3. Can we define variables in an Ansible inventory file?
    - Ans: Yes

4. Which of the following formats is used to call a variable in an Ansible playbook?
     - Ans: 
     ```text
          This is my answer is this ---> {% raw %}'{{ my_answer }}'{% endraw %}
     ```

5. Question + Setup; The playbook located at /home/bob/playbooks/playbook.yaml is designed to add a name server entry in the sample file /tmp/resolv.conf on localhost. The name server information is already defined as a variable named nameserver_ip within the /home/bob/playbooks/inventory file.

Your task is to replace the hardcoded IP address of the name server in the playbook with the value from the nameserver_ip variable specified in the inventory file.


Note: You need not to execute this playbook as of now.
- Ans: Modified playbook.yaml. Swipping out the hard coded `nameserver 8.8.8.8`
     ```bash
          -bash-5.1$ cat playbook.yaml 
          ---
          - name: 'Add nameserver in resolv.conf file on localhost'
          hosts: localhost
          become: yes
          tasks:
          - name: 'Add nameserver in resolv.conf file'
               lineinfile:
               path: /tmp/resolv.conf
               line: 'nameserver {% raw %}{{  nameserver_ip  }}{% endraw %}'
          - name: 'Disable SNMP Port'
               firewalld:
               port: '160-161'
               permanent: true
               state: disabled 

     ```


6. We have updated the /home/bob/playbooks/playbook.yaml playbook to include a new task for disabling the SNMP port on localhost. However, the port number is currently hardcoded. Please update the playbook to replace the hardcoded value of the SNMP port with the value from the variable named snmp_port, which is defined in the inventory file.

- Ans: Modified playbook.yaml. Swipping out the hard coded `nameserver 8.8.8.8`
     ```bash
          -bash-5.1$ cat playbook.yaml 
          ---
          - name: 'Add nameserver in resolv.conf file on localhost'
          hosts: localhost
          become: yes
          tasks:
          - name: 'Add nameserver in resolv.conf file'
               lineinfile:
               path: /tmp/resolv.conf
               line: 'nameserver {% raw %}{{  nameserver_ip  }}{% endraw %}'
          - name: 'Disable SNMP Port'
               firewalld:
               port: {% raw %}'{{ snmp_port }}'{% endraw %}
               permanent: true
               state: disabled 

     ```

Note: You need not to execute this playbook as of now.



7. We have reset the /home/bob/playbooks/playbook.yaml playbook. It is currently printing some personal information of an employee.
Move the car_model, country_name, and title values to variables defined at the play level.
Add three new variables named car_model, country_name, and title under the play and use these variables within the tasks to remove the hardcoded values.

- This is my current 
     - playbook.yaml

     ```bash
          -bash-5.1$ cat playbook.yaml 
          ---
          - hosts: localhost
          tasks:
          - command: 'echo "My car is BMW M3"'
          - command: 'echo "I live in the USA"'
          - command: 'echo "I work as a Systems Engineer"'
     ```

     - inventory file

     ```bash
          -bash-5.1$ cat inventory 
          localhost ansible_connection=local nameserver_ip=8.8.8.8 snmp_port=160-161
          node01 ansible_host=node01 ansible_ssh_pass=caleston123
          node02 ansible_host=node02 ansible_ssh_pass=caleston123
          [web_nodes]
          node01
          node02

          [all:vars]
          app_list=['vim', 'sqlite', 'jq']
          user_details={'username': 'admin', 'password': 'secret_pass', 'email': 'admin@example.com'}
               
     ```


- This is my updated 

     - playbook.yaml (Double Quotes doesn't work !???) (use single quotes I guess)

     ```bash
          -bash-5.1$ cat playbook.yaml 
          ---
          - hosts: localhost
          vars:
               car_model: 'BMW M3'
               country_name: USA
               title: 'System Engineer'
          tasks:
               - command: 'echo "My car is {% raw %}{{ car_model }}{% endraw %}"'
               - command: 'echo "I live in the {% raw %}{{ country_name }}{% endraw %}"'
               - command: 'echo "I work as a {% raw %}{{ title }}{% endraw %}"'
     ```
     - inventory file = NO CHANGE
     - Then run the playbook:
          - 
          ```bash
               -bash-5.1$ ansible-playbook -i inventory playbook.yaml 

               PLAY [localhost] ****************************************************************************************************************************************************

               TASK [Gathering Facts] **********************************************************************************************************************************************
               ok: [localhost]

               TASK [command] ******************************************************************************************************************************************************
               changed: [localhost]

               TASK [command] ******************************************************************************************************************************************************
               changed: [localhost]

               TASK [command] ******************************************************************************************************************************************************
               changed: [localhost]

               PLAY RECAP **********************************************************************************************************************************************************
               localhost                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
          ```

8. The /home/bob/playbooks/app_install.yaml playbook is responsible for installing a list of packages on remote server(s). The list of packages to be installed is already added to the /home/bob/playbooks/inventory file as a list variable called app_list.



Right now the list of packages to be installed is hardcoded in the playbook. Update the /home/bob/playbooks/app_install.yaml playbook to replace the hardcoded list of packages to use the values from the app_list variable defined in the inventory file. Once updated, please run the playbook once to make sure it works fine.

- Current setup:
     - 
     ```bash
          [bob@student-node playbooks]$ ls
          ansible.cfg  app_install.yaml  inventory  playbook.yaml
          [bob@student-node playbooks]$ cat inventory 
          localhost ansible_connection=local nameserver_ip=8.8.8.8 snmp_port=160-161
          node01 ansible_host=node01 ansible_ssh_pass=caleston123
          node02 ansible_host=node02 ansible_ssh_pass=caleston123
          [web_nodes]
          node01
          node02

          [all:vars]
          app_list=['vim', 'sqlite', 'jq']
          user_details={'username': 'admin', 'password': 'secret_pass', 'email': 'admin@example.com'}
          [bob@student-node playbooks]$ cat app_install.yaml 
          ---
          - hosts: web_nodes
          become: yes
          tasks:
          - name: Install applications
               yum:
               name: {% raw %}"{{ item }}"{% endraw %}
               state: present
               with_items:
               - vim
               - sqlite
               - jq
     ```

- Updated version:
     - This is not the right answer btw
     ```bash
          -bash-5.1$ ansible-playbook -i inventory app_install.yaml 

          PLAY [web_nodes] ****************************************************************************************************************************************************

          TASK [Gathering Facts] **********************************************************************************************************************************************
          ok: [node02]
          ok: [node01]

          TASK [Install applications] *****************************************************************************************************************************************
          changed: [node02] => (item=vim)
          changed: [node01] => (item=vim)
          changed: [node02] => (item=sqlite)
          changed: [node01] => (item=sqlite)
          changed: [node02] => (item=jq)
          changed: [node01] => (item=jq)

          PLAY RECAP **********************************************************************************************************************************************************
          node01                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
          node02                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

          -bash-5.1$ cat app_install.yaml 
          ---
          - hosts: web_nodes
          become: yes
          tasks:
          - name: Install applications
               yum:
               name: {% raw %}"{{ item }}"{% endraw %}
               state: present
               with_items:
               - {% raw %}"{{ app_list[0] }}"{% endraw %}
               - {% raw %}"{{ app_list[1] }}"{% endraw %}
               - {% raw %}"{{ app_list[2] }}"{% endraw %}
     ```
     - This is the right answer
     - 
     ```bash
          -bash-5.1$ cat app_install.yaml 
          ---
          - hosts: web_nodes
          become: yes
          tasks:
          - name: Install applications
               yum:
               name: {% raw %}"{{ item }}"{% endraw %}
               state: present
               with_items:
               - {% raw %}"{{ app_list }}"{% endraw %}
     ```


9. The /home/bob/playbooks/user_setup.yaml playbook is responsible for setting up a new user on a remote server(s). The user details like username, password, and email are already added to the /home/bob/playbooks/inventory file as a dictionary variable called user_details.



Right now the user details is hardcoded in the playbook. Update the /home/bob/playbooks/user_setup.yaml playbook to replace the hardcoded values to use the values from the user_details variable defined in the inventory file. Once updated, please run the playbook once to make sure it works fine.

- Current setup:
- 
```bash
     -bash-5.1$ cat inventory 
     localhost ansible_connection=local nameserver_ip=8.8.8.8 snmp_port=160-161
     node01 ansible_host=node01 ansible_ssh_pass=caleston123
     node02 ansible_host=node02 ansible_ssh_pass=caleston123
     [web_nodes]
     node01
     node02

     [all:vars]
     app_list=['vim', 'sqlite', 'jq']
     user_details={'username': 'admin', 'password': 'secret_pass', 'email': 'admin@example.com'}
     -bash-5.1$ cat user_setup.yaml 
     ---
     - hosts: all
     become: yes
     tasks:
     - name: Set up user
          user:
          name: "admin"
          password: "secret_pass"
          comment: "admin@example.com"
          state: present
```

- Updated setup:
     - 
     ```bash
          -bash-5.1$ cat user_setup.yaml 
          ---
          - hosts: all
          become: yes
          tasks:
          - name: Set up user
               user:
               name: {% raw %}"{{ user_details['username'] }}"{% endraw %}
               password: {% raw %}"{{ user_details['password'] }}"{% endraw %}
               comment: {% raw %}"{{ user_details['email'] }}"{% endraw %}
               state: present
          -bash-5.1$ ansible-playbook -i inventory user_setup.yaml 

          PLAY [all] **********************************************************************************************************************************************************

          TASK [Gathering Facts] **********************************************************************************************************************************************
          ok: [localhost]
          ok: [node02]
          ok: [node01]

          TASK [Set up user] **************************************************************************************************************************************************
          [WARNING]: The input password appears not to have been hashed. The 'password' argument must be encrypted for this module to work properly.
          changed: [localhost]
          changed: [node02]
          changed: [node01]

          PLAY RECAP **********************************************************************************************************************************************************
          localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
          node01                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
          node02                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
     ```

- Answer with dot notation... Actually works better in ansible-playbook
     - 
     ```bash
          -bash-5.1$ cat user_setup.yaml 
          ---
          - hosts: all
          become: yes
          tasks:
          - name: Set up user
               user:
               name: {% raw %}"{{ user_details.username }}"{% endraw %}
               password: {% raw %}"{{ user_details.password }}"{% endraw %}
               comment: {% raw %}"{{ user_details.email }}"{% endraw %}
               state: present
          -bash-5.1$ ansible-playbook -i inventory user_setup.yaml 

          PLAY [all] **********************************************************************************************************************************************************

          TASK [Gathering Facts] **********************************************************************************************************************************************
          ok: [localhost]
          ok: [node02]
          ok: [node01]

          TASK [Set up user] **************************************************************************************************************************************************
          [WARNING]: The input password appears not to have been hashed. The 'password' argument must be encrypted for this module to work properly.
          changed: [localhost]
          changed: [node02]
          changed: [node01]

          PLAY RECAP **********************************************************************************************************************************************************
          localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
          node01                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
          node02                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
     ```

## Section 5: Ansible Playbook

### Section 5.1 - Ansible Playbooks
1. Idea of Ansible playbook = set of instruction you provide ansible to work its magic
     - Playbook extensiveness
          - A single playbook could be running a set/ series of command on multiple servers (i.e. restarting servers in a particualr order)
          - A complex one could be to deploy hundreds of VMs across public and private cloud infras, provision storage to said VMs and adding in cluster configs and configuring apps on them (i.e. db server, web server), then setup load balaning, monitoring, installing backup clients, and updating configs with infos about the new VMs...

2. Playbooks are written as a single YAML file (in YAML format)
     - Playbook = a yaml containing a set of plays 
     - Play = set of activities to be run on a single/group of hosts
     - Task = single action to be performed on a host
          - Examples of tasks:
               - Execute a command
               - Running a script
               - Installing a package
               - Shutting down or restarts

     - Simple Playbook example: (FYI, goal of this play is to run a set of task on a local host, one after the other)
     ```yaml
          - 
               name: Play1
               hosts: localhost # the host is defined at play level
               # This could be anything from the inventory file

               tasks:
                    - name: Task 1 - Execute command 'date'
                      command: date
                    - name: Task 2 - Execute script on server
                      script: test_script.sh
                    - name: Task 3 - Install httpd service/ pacakge
                      yum:
                         name: httpd
                         state: present
                    - name: Task 4 - Start web server # using the service module
                      service:
                         name: httpd
                         state: started
     ```

     - Let's slightly modify this playbook and split it up into 2 sections = Now 2 plays
          - 
          ```yaml
               - 
                    name: Play1
                    hosts: localhost # the host is defined at play level
                    # This could be anything from the inventory file

                    tasks:
                         - name: Task 1 - Execute command 'date'
                         command: date
                         - name: Task 2 - Execute script on server
                         script: test_script.sh

               -
                    name: Play2
                    hosts: localhost
                    tasks:
                         - name: Task 3 - Install httpd service/ pacakge
                         yum:
                              name: httpd
                              state: present
                         - name: Task 4 - Start web server # using the service module
                         service:
                              name: httpd
                              state: started
          ```
          - Note: Playbooks are list of dictionaries in YAML terms. Also, each play is a dictionary that has a set of properties called name, hosts, and tasks. Hence the order doesn't matter (i.e. if you swap order of `name` and `hosts` the play is still valid )

          - Tasks however, is a list/ array, where order of entries matters ! List oare ordered collections.

          - YAML syntax must be obeyed and extra attention is needed to the indentaion and strcture of the file


     - `host` param = indicates which host to run it with, is always set against a play level

          - For the example playbook.yaml. It's set to run on host = localhost
               - 
               ```yaml
                    - 
                         name: Play1
                         hosts: localhost # the host is defined at play level
                         # This could be anything from the inventory file

                         tasks:
                              - name: Task 1 - Execute command 'date'
                              command: date
                              - name: Task 2 - Execute script on server
                              script: test_script.sh
                              - name: Task 3 - Install httpd service/ pacakge
                              yum:
                                   name: httpd
                                   state: present
                              - name: Task 4 - Start web server # using the service module
                              service:
                                   name: httpd
                                   state: started
               ```
          - inventory. Be sure to customize this first before you trigger any runbooks
               - 
               ```ini
                    localhost
                    
                    server1.company.com
                    server2.company.com

                    [mail]
                    server3.company.com
                    server4.comapny.com

                    [db]
                    server5.company.com
                    server6.company.com

                    [web]
                    server7.comapny.com
                    server8.company.com
               ```

     - Modules in ansible playbook
          - Different actions run by tasks are known as **Ansible modules** (e.g. command, script, yum, service)
          - There are hundreds more with it come to ansible modules
          - Check out the official doc for more or... run this on the cli `ansible-doc -l`

3. Running / Executing the playbook
     - Syntax to run it would be: `ansible-playbook playbook.yml` aka `ansible-playbook <playbook file name>`
     - To know more, run `ansible-playbook --help`

### Section 5.2 - Verifying Playbooks
1. Verifying a playbook
     - Real life example: Writing an platbook and using it directly on production, but there was a bug in the code. Instead of updating software, it auto shuts down all services on the server = significant down time 
     - Hence, please for the love of god, verify your playbook. Espically for prod envs, it's a cruical practice = rehersal to help rectify any errors or unexpected behaviors in a controlled place
     - Without verification = harder and more time consuming to resolve and risk seeing unforeseen issues, such as 
          - System down time
          - Data loss
     - Verification is good for:
          - ensuring reliability of your systems
          - maintain the stability of systems

     - Ansible has different modes for playbook verification!!
          - 1 - Check Mode (i.e. `--check`)
               - = dry-run mode = Ansible executing the playbook without making any changes on the host
               - Allows to see the upcoming changes WITHOUT actually applying it
               - Example: installing nginx on web server called `install_nginx.yaml`
                    - 
                    ```yaml
                         ---

                         - hosts: webservers
                         tasks:
                         - name: Ensure nginx is installed
                              apt: 
                                   name: nginx
                                   state: present
                              become: yes
                    ```

               - If you run `ansible-playbook install_nginx.yaml --check`, the output would be the following
                    - 
                    ```bash
                         - PLAY [webservers] **********************

                         TASK [Gathering Facts] *************************
                         ok:[webserver1]

                         TASK [Ensure nginx is installed] *************************
                         changed:[webserver1]

                         PLAY RECAP
                         **************************************
                         webserver1: ok=2 changed=1 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
                    ```
               - The output shows that ansible COULD change the state of the webserver
               > Note: not all Ansible modules support check mode, unsupported check mode in tasks could be SKIPPED when you run the playbook

          - 2 - Diff Mode (i.e. `--diff`)
               - Often used alongside with check mode !!
               - Providing a before and after comparision of playbook changes = helps to understand and verify the impact of playbook before and after applying them
               - example yaml to check if a speicifc line would be present in a config file, called `configure_nginx.yml`

               ```yaml
                    ---

                    - hosts: webservers
                      tasks:
                        - name: Ensure the configuration line is present
                          lineinfile:
                            path: /etc/nginx/nginx.conf
                            line: 'client_max_body_size 100M;'
                           become: yes
               ```
               - If you run `ansible-playbook configure_nginx.yaml --check --diff`
               - This would be the output

               ```bash
                    - PLAY [webservers] ***********************
                      TASK [Gathering Facts] *************************
                      ok:[webserver1]
                      TASK[Ensure the configuration line is present]**********
                      --- before: /etc/nginx/nginx.conf (content)
                      +++ after: /etc/nginx/nginx.conf (content)
                      @@ -20,3 +20,4 @@
                      # some existing config lines
                      # more config lines
                      #
                      +client_max_body_size 100M;
                      changed: [webserver1]
                      PLAY RECAP
                      *********************************************

                      webserver1: ok-2 changed=1 unreachable=0 failed=0 skipped=0 rescured=0 ignored=0
               ```
               - Explaination:
                    - the `+` symbol shows that `client_max_body_size 100M` would be added to the file

          - 3 - Syntax check mode: (i.e. `--syntax-check`)
               - It checks syntax of playbook for any errors, quick way to catch syntax error that could cause playbook to fail during execution
               - Quick way for you to catch errors before running the playbook on your hosts!
               - For example, I have configure_nginx.yml
               - 
               ```yaml
                    ---

                    - hosts: webservers
                      tasks:
                        -  name: Ensure the configuration line is present
                           lineinfile:
                              path: /etc/nginx/nginx.conf
                              line: 'client_max_body_size 100M;'
                           become: yes
               ```
               - Run syntax check with the command
               ```bash
                    ansible-playbook configure_nginx.yaml --syntax-check
               ```
               - Output would be 
               - 
               ```bash
                    - PLAY [webservers] **********************

                    TASK [Ensure the configuration line is present] ***************
                    ok: [webserver1]

                    PLAY RECAP
                    **************************************

                    webserver1: ok=1 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
               ```

               - Let's introde a syntax error in the playbook = removing the `:` before `lineinfile` in the task section
               - 
               ```yaml
                    ---

                    - hosts: webservers
                      tasks:
                        -  name: Ensure the configuration line is present
                           lineinfile 
                              path: /etc/nginx/nginx.conf
                              line: 'client_max_body_size 100M;'
                           become: yes
               ```
               - Running the syntax check again
               - 
               ```bash
                    ansible-playbook configure_nginx.yaml --syntax-check
               ```
               - Output would be
               - 
               ```bash
                    ERROR! Syntax Error while loading YAML.
                         did not find expected key
                    The error appears to be in '/path/to/configure_nginx.yaml': line 5, column 9, but may
                    be elsewhere in the file depending on the exact syntax problem.
                    The offending line appears to be:
                         lineinfile
                              path: /etc/nginx/nginx.conf
                              ^ here
               ```

### Section 5.3 - Ansible Init
- Previous, we talked about the following...
     - Importance of playbook verification in Ansible via `--check`, `--diff`, and `--syntax-check` modes to ensure ansible playbooks behave as expected before actual execution.
- Let's take it up a notch: `ansible` was already embedded into the company's infra, multiple playbooks are already written. As infra complextiy grows, playbook complexity grows
     - Need a way to ensure consistency and quality across all playbooks
     - Enter `ansible-lint` = a tool to analyze ansible playbooks, roles, collections for potential errors, bugs, style errors and suspicious constructs. Kinda like having a seasoned Ansible metor helping you out

- Example of using `ansible-lint`, say I have this file `style_example.yaml`
     - Some tasks to install and config nginx. WITH STYLING issues
     - 
     ```yaml
          - name: Style example Playbook
            hosts: localhost
            tasks:
              - name: Ensure nginx is installed & started
                apt:
                  name: nginx
                  state: latest
                  update_cache: yes
              - name: Enable nginx service at boot
          service:
               name: nginx
               enabled: yes
               state: started
          - name: Copy nginx config file
            copy:
               src: /path/to/nginx.conf
               dest: /etc/nginx/nginx.conf
            notify:
              - Restart nginx service
          
          handlers:
               - name: Restart nginx service
                 service:
                   name: nginx
                   state: restarted
     ```
     - Issues!
          - some tasks has 2 spaces of identation, some have 4
          - taskd name are also inconsistenet (some consise, some took sentence like approach)
     - Running `ansible-lint style_example.yaml` would give the following output
     - 
     ```bash
          [WARNING]: incorrect identation: expcted 2 but found 4 (syntax/identification)
          style_example.yaml:6

          [WARNING]: command should not contain whitespace (blacklisted:['apt']) (commands)
          style_example.yaml:6

          [WARNING]: Use shell only when shell functionality is required (deprecated in favor of 'cmd') (commands)
          style_example.yaml:6

          [WARNING]: command should not contain whitespace (blacklisted:['service']) (commands)
          style_example.yaml:12

          [WARNING]: 'name' should be present for all tasks (task-name-missing) (tasks)
          style_example.yaml:14
     ```
     - Conclusion: ansible catches all style related issues and provides us with warnings (e.g. incorrect identation, missing name attribute, use of blacklisted commands (deprecated apt and service modules)). Please use `ansible-lint` to refine your playbook 

### Section 5.4 - Lab: Coding exercises, Ansible Playbook

1. Setting the ground
- 
```text
     In this lab exercise you will use below hosts. Please note down some details about these hosts as given below:

     `student-node` - This host will act as an Ansible master node where you will create `playbooks`, `inventory`, `role` file etc and you'll be running your playbooks from this host itself.

     `node01` - This host will act as an Ansible client/ remote host where you will setup or install some stuff using Ansible playbooks. Below are the SSH credentials for this host:

     User: `bob`
     Password: `caleston123`

     `node02` - This host will also act as an Ansible client/ remote host where you will setup or install some stuff using Ansible playbooks. Below are the SSH credentials for this host:

     User: `bob`
     Password: `caleston123`

     Note: Please type `exit` or `logout` on the terminal or press `CTRL+d` to log out from a specific node.
```

2. Which of the following formats is the Ansible Playbook written in ? Ans: YAML

3. How many Ansible plays are present in the following playbook
- This is an example of how you can configure apache and tomcat servers using Ansible playbook
     - 
     ```yaml
          ---
          - name: Setup apache
          hosts: webserver
          tasks:
          - name: Install httpd
               yum:
               name: httpd
               state: installed
          - name: Start httpd service
               service:
               name: httpd
               state: started
          - name: Setup tomcat
          hosts: appserver
          tasks:
          - name: Install tomcat not httpd
               yum:
               name: tomcat
               state: installed
          - name: Start service
               service:
               name: tomcat
               state: started
     ```
- Ans: 2 plays

4. How many tasks under the Setup apache play ? Ans: 2

5. If we use the following inventory, on which hosts will Ansible install the `httpd` paackage using the given playbook ?
- inventory.ini
- 
```ini
[webserver]
web1
web2

[appserver]
app1
app2
app3
```

- playbook.yaml
- 
```yaml
     ---
     - name: Setup apache
       hosts: webserver
       tasks:
         - name: Install httpd
           yum:
             name: httpd
             state: installed
     - name: Setup tomcat
       hosts: appserver
       tasks:
         - name: Install tomcat not httpd
           yum:
             name: tomcat
             state: installed
```

- Ans: web1 and web2 only


6. Which of the following commands can you run to run an Ansible playbook named `install.yaml` ?
     - option A: `ansible-playbook install.yaml`
     - option B: `ansible-play run install.yaml`
     - option C: `ansible-playbook -p install.yaml`
     - option D: `ansible-playbook -i install.yaml`

     - Ans: Option A

7. A sample playbook named `update_service.yml` is show below and it's suppose to update a service on your servers

- Here's the content of the playbook
     - 
     ```yaml
          - hosts: all
          tasks:
               - name: Install a new package
               apt:
                    name: new_package
                    state: present
               - name: Update the service
               service:
                    name: my_service
                    state: restarted 
               - name: Check service status
               service:
                    name: my_service
                    state: started
     ```

- Which command would you use to run `update_service.yml` playbook in check mode ?
     - option A: `ansible update_service.yml`
     - option B: `ansible-play update_service.yml --check`
     - option C: `ansible-playbook update_service.yml`
     - option D: `ansible-playbook --check update_service.yml`

     - Ans: Option B

8. Consider again the same sample playbook named `update_service.yml` shown below
- Here:'s the content of the playbook:
- 
```yaml
     - hosts: all
       tasks:
           - name: Install a new package
             apt:
                name: new_package
                state: present
           - name: Update the service
             service:
               name: my_service
               state: restarted 
           - name: Check service status
             service:
               name: my_service
               state: started
```  

- Let's suppose you have already ran this playbook on your server. Now, once your run this playbook in check mode against the same server, which tasks would result in a changed status?

- option A: Installing a new packge
- option B: Updating the service
- option C: Checking the service status
- option D: All of the above tasks

- Ans: option B
     - Explanation: `Update the service` would be marked as changed because restarting a service is a change in state. The rest of the tasks are already ran on the server, since package is present and already installed and the service was already started.


9. Let's look at a new playbook named `configure_database.yml` that modifies a config file on all database servers, the yaml is the file shown below:

- Trying this...
- 
```yaml
     - hosts: all
       tasks:
         - name: Set max_connections in db config
           lineinfile:
               path: /etc/postgresql/12/main/postgresql.conf
               line: 'max_connections = 500'

        - name: Set listen address
          lineinfile:
               path: /etc/postgresql/12/main/postgresql.conf
               line: 'listen_addresses = "*"'
```

- Which command would you use to run `configure_database.yml` playbook in diff and check mode ?

- option A: `ansible-playbook configure_database.yml --diff`
- option B: `ansible-playbook configure_database.yml --check`
- option C: `ansible-playbook configure_database.yml --check --diff`
- option D: `ansible-playbook --diff --check configure_database.yml`

- Ans: option C

10. Consider again the same exact playbook `configure_database.yml` shown above:

- To check the `configure_database.yml` for syntax errors, which command would you use?

- option A: `ansible-playbook configure_database.yml`
- option B: `ansible-playbook configure_database.yml --syntax`
- option C: `ansible-playbook --syntax-check configure_database.yml`
- option D: `ansible configure_database.yml --syntax-check`

- Ans: option C

11. You have the following Ansible playbook named `database_setup.yml`, you're suppose to setup a PostgreSQL db on your server, but before deploying it, you want to ensure that it adheres to the best practices and doesn't have any style-related issues:

- This is the initial content of the playbook:
- 
```yaml
     - name: Database setup playbook
       hosts: db_servers
       tasks:
         - name: Ensure PostgreSQL is installed
           apt:
             name: postgresql
             state: latest
             update_cache: yes

         - name: Start PostgreSQL service
           service:
             name: postgresql
             state: started

         - copy:
             src: /path/to/ph_hba.conf
             dest: /etc/postgresql/12/main/postgresql.conf
           notify:
             - Restart PostgreSQL
```

- Which command would you use to run `ansible-lint` on the `database_setup.yml` playbook?

- option A: `ansible database_setup.yml --lint`
- option B: `ansible-lint database_setup.yml`    
- option C: `ansible-playbook database_setup.yml --lint`
- option D: `lint-ansible database_setup.yml`

- Ans: option B 

12. After running the same `database_setup.yml` playbook through `ansible-lint`, what might you expect to see in the output?

- option A: Incorrect identition
- option B: Depreciated module usage (i.e. apt)
- option C: Missing name attribute in tasks
- option D: Use of blacklisted command

- Ans: A & C (since `copy` is indented incorrectly and missing name attribute in the last task)

13. After you've been given feedback from your `ansible-lint` about potential issues in your hypotetical `webserver_setup.yml` playbook. The feedback mentions issues with indentation, deprecated modules and missing `name` attributes.

Which of the following is NOT a recommended action based on the feedback ?

- Option A: Correcting the indentiation in the playbook
- Option B: Replacing deprecated modules with their recommended alternatives (i.e. new counterparts)
- Option C: Ignoring feedback and proceeding with playbook executions
- Option D: Adding 'name' attributes to tasks that are missing them

- Ans: Option C, ignoring is not an option!

14. If `ansible-lint` provides no output after checking a playbook, what does it indicate ?
- Option A: The playbook has syntax errors
- Option B: Playbook is empty
- Option C: playbook adheres to best practices and has no styled issues
- Option D: ansible-lint failed to check the playbook

- Ans: Option C, best practice has been reached!

15. Update the name of the play in `/home/bob/playbooks/playbook.yaml` playbook to excute a date command on localhost

- Solution:
- 
```bash
     [bob@student-node playbooks]$ ls
     ansible.cfg  inventory  playbook.yaml
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - hosts: localhost
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date       

     [bob@student-node playbooks]$ vi playbook.yaml 
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - hosts: localhost
     become: yes
     tasks:
     - name: 'Execute a date command on localhost'
          command: date       

     [bob@student-node playbooks]$ ansible-playbook -i inventory playbook.yaml

     PLAY [localhost] ***************************************************************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [localhost]

     TASK [Execute a date command on localhost] *************************************************************************************************************************
     changed: [localhost]

     PLAY RECAP *********************************************************************************************************************************************************
     localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

16. Update the playbook /home/bob/playbooks/playbook.yaml to add a task name Task to display hosts file for the existing task.

- 
```bash
     [bob@student-node playbooks]$ ls
     ansible.cfg  inventory  playbook.yaml
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute a command to display hosts file on localhost'
     hosts: localhost
     become: yes
     tasks:
     - command: 'cat /etc/hosts'       
     [bob@student-node playbooks]$ vi playbook.yaml
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute a command to display hosts file on localhost'
     hosts: localhost
     become: yes
     tasks:
     - name: Task to display hosts file
          command: 'cat /etc/hosts'      
     [bob@student-node playbooks]$ ansible-playbook -i inventory playbook.yaml 

     PLAY [Execute a command to display hosts file on localhost] ********************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [localhost]

     TASK [Task to display hosts file] **********************************************************************************************************************************
     changed: [localhost]

     PLAY RECAP *********************************************************************************************************************************************************
     localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

17. We have reset the playbook /home/bob/playbooks/playbook.yaml, now update it to add another task. The new task must execute the command cat /etc/resolv.conf and set its name to Task to display nameservers.

- Solution:
- 
```bash
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on localhost'
     hosts: localhost
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date       
     [bob@student-node playbooks]$ vi playbook.yaml 
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on localhost'
     hosts: localhost
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date       
     - name: 'Task to display nameservers'
          command: cat /etc/resolv.conf
     [bob@student-node playbooks]$ ansible-playbook -i inventory playbook.yaml 

     PLAY [Execute two commands on localhost] ***************************************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [localhost]

     TASK [Execute a date command] **************************************************************************************************************************************
     changed: [localhost]

     TASK [Task to display nameservers] *********************************************************************************************************************************
     changed: [localhost]

     PLAY RECAP *********************************************************************************************************************************************************
     localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

18. So far, we have been running all tasks on localhost. We would now like to run these tasks on node01, this host is already defined in /home/bob/playbooks/inventory file. Update the playbook /home/bob/playbooks/playbook.yaml to run the tasks on the node01 host.

- Solution:

- 
```bash
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on node01'
     hosts: localhost
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ vi playbook.yaml 
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on node01'
     hosts: node01
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ ansible-playbook -i inventory playbook.yaml 

     PLAY [Execute two commands on node01] ******************************************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [node01]

     TASK [Execute a date command] **************************************************************************************************************************************
     changed: [node01]

     TASK [Task to display hosts file] **********************************************************************************************************************************
     changed: [node01]

     PLAY RECAP *********************************************************************************************************************************************************
     node01                     : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

19. Refer to the /home/bob/playbooks/inventory file. We would like to run the /home/bob/playbooks/playbook.yaml on all servers defined under web_nodes group.


Note: Use the group name in playbook as defined in the inventory file.

- Solution:

- 
```bash
     [bob@student-node playbooks]$ cat inventory 
     node01 ansible_host=node01 ansible_ssh_pass=caleston123
     node02 ansible_host=node02 ansible_ssh_pass=caleston123
     [web_nodes]
     node01
     node02

     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on web_nodes'
     hosts: node01
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ vi playbook.yaml 
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on web_nodes'
     hosts: web_nodes
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ ansible-playbook -i inventory playbook.yaml 

     PLAY [Execute two commands on web_nodes] ***************************************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [node01]
     ok: [node02]

     TASK [Execute a date command] **************************************************************************************************************************************
     changed: [node01]
     changed: [node02]

     TASK [Task to display hosts file] **********************************************************************************************************************************
     changed: [node01]
     changed: [node02]

     PLAY RECAP *********************************************************************************************************************************************************
     node01                     : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
     node02                     : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

20. Update the /home/bob/playbooks/playbook.yaml to add a new play named Execute a command on node02, and a task under it to execute cat /etc/hosts command on node02 host, name the task Task to display hosts file on node02.

- Solution:

- 
```bash
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on node01'
     hosts: node01
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file on node01'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ vi playbook.yaml 
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on node01'
     hosts: node01
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file on node01'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ vi playbook.yaml 
     [bob@student-node playbooks]$ cat playbook.yaml 
     ---
     - name: 'Execute two commands on node01'
     hosts: node01
     become: yes
     tasks:
     - name: 'Execute a date command'
          command: date
     - name: 'Task to display hosts file on node01'
          command: 'cat /etc/hosts'

     - name: 'Execute two commands on node02'
     hosts: node02
     become: yes
     tasks:
     - name: 'Task to display hosts file on node02'
          command: 'cat /etc/hosts'
     [bob@student-node playbooks]$ ansible-playbook -i inventory playbook.yaml 

     PLAY [Execute two commands on node01] ******************************************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [node01]

     TASK [Execute a date command] **************************************************************************************************************************************
     changed: [node01]

     TASK [Task to display hosts file on node01] ************************************************************************************************************************
     changed: [node01]

     PLAY [Execute two commands on node02] ******************************************************************************************************************************

     TASK [Gathering Facts] *********************************************************************************************************************************************
     ok: [node02]

     TASK [Task to display hosts file on node02] ************************************************************************************************************************
     changed: [node02]

     PLAY RECAP *********************************************************************************************************************************************************
     node01                     : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
     node02                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

### Section 5.5 - Conditionals

1. Start with an example: I have 2 playbooks that does the same thing (i.e. to install nginx on the host)

- playbook1.yaml
- 
```yaml
     ---
     - name: Install NGINX
       hosts: debian_hosts
       tasks:
       - name: Install NGINX on Debian
         apt:
           name: nginx
           state: present
```

- playbook2.yaml
- 
```yaml
     ---
     - name: Install NGINX
       hosts: redhat_hosts
       tasks:
       - name: Install NGINX on Redhat
         yum:
           name: nginx
```

- As we know, different OS flavors (i.e distros) use different package managers (i.e. apt for debian based, yum for redhat based).
- We want to create a single playbook that can handle both types of distros, or better yet, any distro

- Solution: use conditionals in ansible playbook but using the `when` conditional statement with syntax `when: << condition >>`, only when the condition is true the task is run. You can also use `or`, `and` to combine multiple conditions

- unified_playbook.yaml
- with `ansible_os_family` as the built-in variable to determine the OS family of the host
- 
```yaml
     ---
     - name: Install NGINX
       hosts: all
       tasks:
       - name: Install NGINX on Debian
         apt:
           name: nginx
           state: present
         when: ansible_os_family == "Debian" and ansible_distribution_version == "16.04"
       - name: Install NGINX on Redhat
           yum:
             name: nginx
             state: present
         when: ansible_os_family == "RedHat" or ansible_os_family == "SUSE"
```

2. Using Conditions in a loop
- Say we have a list of packages to install
- using it in a loop involves creating an array, in this example, we'll have an array called `packages` with property `required` to indicate if the package is required to be installed. Combined with the loop directive under the `{% raw %}"{{ packages }}"{% endraw %}` syntax

- 
```yaml
     ---
     - name: Insatll softwares
       hosts: all
       vars:
         packages:
           - name: nginx
             requireed: True
           - name: mysql
             required: True
           - name: apache
             required: False
       tasks:
       - name: Install {% raw %}"{{ item.name }}"{% endraw %} on Debian 
         apt:
           name: {% raw %}"{{ item.name }}"{% endraw %}
           state: present
         loop: {% raw %}"{{ packages }}"{% endraw %}
         when: item.required == True
```

- To help you visualize better, the loop is actually just 3 seperate tasks!
     - Task 1
     - 
     ```yaml
          - name: Install {% raw %}"{{ item.name }}"{% endraw %} on Debian
            vars:
              item:
                name: nginx
                required: True
            apt:
              name: {% raw %}"{{ item.name }}"{% endraw %}
              state: present 
            when: item.required == True
     ```
     - Task 2
     - 
     ```yaml
          - name: Install {% raw %}"{{ item.name }}"{% endraw %} on Debian
            vars:
              item:
                name: mysql
                required: True
            apt:
              name: {% raw %}"{{ item.name }}"{% endraw %}
              state: present 
            when: item.required == True
     ```
     - Task 3
     - 
     ```yaml   
          - name: Install {% raw %}"{{ item.name }}"{% endraw %} on Debian
            vars:
              item:
                name: apache
                required: False
            apt:
              name: {% raw %}"{{ item.name }}"{% endraw %}
              state: present 
            when: item.required == True
     ```

3. Using conditions and registers
- Using conditionals based on the output of a previous task

- Example playbook
- 
```yaml
     ---
     - name: Check status of a service and email if its down
       hosts: localhost
       tasks:
         - command: service httpd status # 1st task - check service status
           register: service_status
         - mail: # 2nd task - sends the email
             to: admin@comapny.com
             subject: Service Alert
             body: Httpd Service is down
```
- We've learned before that the `register` directive captures the output of a task and stores it in a variable (i.e. `service_status` here)

- updated playbook
- 
```yaml
     ---
     - name: Check status of a service and email if its down
       hosts: localhost
       tasks:
         - command: service httpd status # 1st task - check service status
           register: result # Logs and saves the result
           register: service_status
         - mail: # 2nd task - sends the email
             to: admin@comapny.com
             subject: Service Alert
             body: Httpd Service is down
             when: result.stdout.find('down') != -1 # sends emails if stdout has the keyword down in it. If stdout doesn't have down, it reutrns minus one !!
```

- `result.stdout.find('down') != -1` checks if the string 'down' is present in the standard output of the previous command. If found, it returns the index (0 or greater), if not found, it returns -1. So the condition ensures that the email task only runs when the service is down.

### Section 5.6 (ch.27) - Ansible Conditionals based on facts, variables, re-use

1. Real life example in a company (Secnario 1)
- Company has a fleet of servers with different OS distros (i.e. ubuntu 18.04, centos7, redhat, suse and some on windows server 2019)
- Task: Automate web app deployment across all servers
- Playbook needs to perform different actions for different servers

- For ubuntu:
     - 
     ```yaml
          - name: Installing nginx on ubuntu 18.04
              apt:
                name: nginx=1.18.0
                state: present
              when: ansible_facts['os_family'] == 'Debian' and ansible_facts['distribution_major_version'] == '18'
     ```
     - Note: our inventory only has basic info about the hosts (i.e. IP, hostname), no OS info
     - Hence why we're sourcing these info from ansible facts!

2. Recall ansible facts 
     - = System-specific variables
     - Containing info about the servers during playbook execution

3. Deploying config files (Secnario 2)
- 
```yaml
     - name: Deploy configuration files
       template: 
         src: {% raw %}"{{ app_env }}_config.j2"{% endraw %}
         dest: "/etc/myapp/config.conf"
       vars:
         app_env: production # You can use this var to deploy the appropriate config file based on the environment. Ideas of using conditionals here!
```

4. Installing required packages (Secnario 3)
- 
```yaml
     - name: Install required packages
         apt:
           name:
             - package1
             - package2
           state: present
     - name: Create necessary directories and set permissions
     .
     .
     .
     # We only want to start the web app in the prod env
     - name: Start web app service
         service:
           name: myapp
           state: started
         when: enviornment == 'production' # idea of reuse
```
- These are great examples that shows ansible facts, variables and reuse could help simplify tasks and complex requirements mkaing playbooks more efficient and managable

### Section 5.7 (ch.28) - Coding lab for Ansible Conditionals


          