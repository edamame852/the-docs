---
title: 1_Intro
layout: default
parent: C++ 
grand_parent: Coding Practices
---
# Non-SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# 1.1 Introduction

## Common C Compliers
1. GNU gcc [complier](/docs/medical/medical-index.md)
2. Microsoft Visual C++ complier (Complies C too)

# 1.2 Software vs Hardware
1. Software: Instructions
2. Hardware: Controlling computers
3. Moore's Law (trend): 60s Co-founder of intel said the computer power doubling while costs halved every couple of years
4. Computer terms:
- Input unit: Receving
- Output unit: Shipping
- Memory unit: RAM = primary memory
- byte = 8 bits
- bit = 1 or 0
- ALU = Arithmetic and logic Unit, imlpemented in CPU
- CPU = admin 
- Secondary storage unit = warehousing = external hard drives

# 1.3 Data Hierarchy

## From simpliest to richest
- bits: 0 or 1, short for "binary digit"
- chars: digits + letters + special symbols
    - C supports Unicode, Unicode contains 1/2/4 bytes 
    - unicode = many world languages
- fields = groups of bytes and chars = string of xxx = 1 (row) entry
- records = couple of related fields = column of the same fields (multi-entry)
- files = view = groups of related records
- database = collection of data that is easily accessible 
- big data

# 1.4 Machine language, Assembly and Assemblers, High level

All modern day programing language can be sorted into 3 types: machine code, assembly code, high level

There are 2 translator programs: 
- assembler for assembly code
- compliers for high level programming languages

## Machine Language (-> complies to 0 and 1)
1. Computers can only understand it's own machine language restricted by hardware design (Machine dependent)
2. Example:

```c++
+130042774
+1200274027
```
3. pros and cons
cons: too slow and tedious

## Assembly Code

1. Assembly languages: using eng abbr. for operations
2. Requires translator programs (aka: assemblers) to complie assembly to machine code

```bash
load    basepay
add     overpay
store   grosspay
```
## High level languages (e.g. C)
1. Compliers compile high level code to machine language 

``` python
grossPay = basePay + overTimePay
```

## Interpreters
1. No need to compile high level via complier, interpreter can execute high-level directly (slower in performence)

# 1.5 C Programming Language

0. Terminology
- ANSI = American National Standards Institute (ANSI)
- ISO = International Standards Organization
- portability = more access to other hardware/ OS platforms

1. History of C
- C is evolved from BCPL & B
- BCPL = dev in 1967 for OS and compiler
- B = used to build Bell Lab in 1970 with features from BCPL
- C started in 1972, main language in UNIX OS. C is MOSTLY hardware indepdent, works and portable to most PCs

2. Pros of C
- Build for performence:
    - C is used for building OS (Objective C in Apple OS, Google Android, Windows), embedded sys (Navigations, microprocessors, home security systems (can run as fast as possible to save memories)), real-time systems (air traffic systems), comunication systems (devlivering data without delay and loss)
- Standarizations:
    - Before 1983, there are many hardware platoform implementation of C
    - New committee X3J11 created under X3 (= ANS Committee on computers and information processing)
    - The standard was admitted by ANSI and then ISO in 1999, know as standard C (aka C99)
    - Latest C is C11

# 1.6 C Standard Library
- C has standard lib containing functions 
- Efficency is a core of these standard lib functions
- using standard lib = better portability = better access to other platforms

# 1.7 Other C based languages
- (Visual) C++ was dev by Bell Lab
    - Object-orientated (reusable components) = modular design = more productive, easier to understand, modify
    - C++ to be explained in ch.15-23
- Objective-C: based in C, invented in eraly 1980s by NeXT and accquired by Apple. Used to build OS X, all iOS 
- Java: inveted in 1991 by Sun Microsystems as internal research proj to run on broader comp sys and platforms. Java is used for web servers, consumer devices, large corps platforms and Andriod Apps.
- (Visual) C#: Object-orientated, based on C++ and Java, used for integrating internet and web
- PHP: Object-oriented & open source. Platform independent for all OS e.g.UNIX, Linux, Windows... PHP supports DB e.g. MySQL
- Python: Released publicly in 1991 in Amsterdam, dervied from Modula-3 (programming language)
- JavaScript: For adding dynamic behavior to webpages (i.e. animations, user interactions ...)
- Swift: Introduced in 2014 on WWDC, not as complicated as Objective C. Focus on performenace, security, mac & ios programming abilities.

# 1.8 Object technology (OOP)
- Objects: aka, class objects. Reuable software components. Containing behaviors (functions) and attributions (params)

1. Example of a Car class object:
- Goal: Drive a car, acclerate with pedal.
- Requirements: blueprints, someone to design the car, hides/ hidden features (steering wheels, brakes...)

2. Methods & Classes
- Methods = performing tasks = hides instrutions from users (logic for accelearing, braking...)
- Classes = a program unit to contains set of methods for task performing = the blueprint

3. Instantiation
- Instantiation = building an object from class = building the car from blueprint
- Class Object is referred to as the instance of a class

4. Reusability
- The pros of reusing
    - Saves time and effort (Avoid reinventing the wheel and use existing high quality pieces = pro of OOP)
    - More reliable since classes are tested, debugged for performence and accuracy!

5. Message and method calls
- Message is sent as a method call to tell object's method to perform task
- user -> message (a method call) -> object's method -> object 

6. Attribute and instance variable
- Attribute: Details of the object, object knows its OWN attribute but not other object attributes!
- Attribute are set by setting class's instance (object) variable

7. Information hiding and encapsulation
- Classes encapsulate their attributes and methods 
- Objects communicate with each other but normally their methods and attributes STAY HIDDEN! = Information hiding = good trait

8. Inheritance
- New class (subclass/ child class) can inherit from parent class/ superclass with new unqiue traits

# 1.9 Typical C dev environemnt

0. Terminology:
- Division by zero error: runtime/ execution-time error (This is a fatal error)
- Object code = machine (language) code
- Syntax error = compile error = compile time error
- gcc program = GNU C compiler = will handle phase 3 and 4
- streams = stdin, stdout (output to screen/ another stream), stderr (standard error stream to log error)


1. C system has 3 parts: Dev env, C language, C standard lib (std)
2. We can define the following 6 phases:
- phase 1 (Edit): Progammer creates program in editor (i.e. `vi` and `emac`) and store on disk (for C it's a `.c` file)
- phase 2 (Pre-process): pre-processor auto  pre-proceess code under pre-processing directives (Check Ch.13)
- phase 3 (Compile): compiler creates object code & stores on disk (aka: C program code to machine code, where synyax error can occur)
- phase 4 (Link): Linker links object code w/ libs and geneartes executable, stores on disk
- phase 5 (Load): loader takes executable from disk puts program in mem
- phase 6 (Execute): CPU takes instruction and execute, if new data appears it will be stored

# 1.10 Running on Windows/Linux/MacOSX

1. Windows (Command Prompt) : Execute with `c:\...\Windows>app_name` windows assume file to be .exe by default

2. Linux (Shell + GNU C):
- `gcc -str=c11 app_name.c -o app_name`
- `./app_name` 

3. MacOSX (Terminal)
- `clang app_name.c -o app_name`
- `./app_name` 

# 1.11 OS
- windows: mid 80s, evolved from DOS and inspired by Mac OS. Proprietary = controlled by Microsoft !
- linux: Open source, used in servers & embedded sys
- MacOS: Proprietary, iOS is derived from NeXTSTEP when accquired in 1996.
- Google Android OS (accrquired in 2005): Based on Linux kernel + Java.

# 1.12 Internet and WWW
0. Terminology:
- ARPA = Advanced Research Projects Agency of US DoD
- TCP = Transmission Control Protocol
- Packets = message of sequentically numbered pieces
- Ajax = a technology that helps internet based app performing like desktop apps (e.g. Google Maps)
- Internet of things = more than network of computers but more

1. Late 60s, ARPA funded many networking research and Uni to enhance op speed from 110 bit/s to 50,000 bit/s
2. This created ARPANET, the pre-crusor of internet
3. Network protocol/rules for talking on ARPANET = TCP, to ensure message (packets) quality & re-packagement

4. ARPA wanted different networks to communicate = IP = network of networks. New protocol = TCP/IP
5. CREN (Europe) pls dev a hyperlinked text document called HTML and communication protocol: HTTP

# 1.13 Software terminologies

1. Agile software development : A methodology to implement app faster with fewer resources
2. Refactoring: reworking code for maintainability, to make cleaner & easier to understand code. Used with Agile
3. Design Patterns: Building flexible, maintainable OOP code. Encourages reusing code to save time, money and effort
4. LAMP: Open source technologies (Linux, Apache, MySQL, PHP/Python)
5. SaaS: Software as a service, Software running on internet, update server then update everything. 
6. PaaS: Platform as a servivec, a computing platform for running SaaS on web. (e.g. AWS EC2, Azure ...)
7. Cloud computing: Both SaaS and PaaS are cloud computed, saving cost (updating, security, DR, backups)
8. SDK: Software dev kit containing tools and docs for devs to program apps

## Stages of dev & release
1. Alpha: 1st release, under active dev with bugs & unstable & incomplete. Release to small num of devs to test
2. Beta: Released to more devs, fixed major bugs, new features almost done but still subject to change
3. Release candidates: Feature complete, mostly bug free and ready to ship to different UAT env and sys.
4. Final release: Corrected bugs from release candidates, release to general public
5. Continous beta: no version numbers, hosted on cloud and not installed locally