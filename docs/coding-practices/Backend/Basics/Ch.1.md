---
title: Basics
layout: default
parent: Backend 
grand_parent: Coding Practices
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# 1. Multithreading in Java
- allowing concurrent sub-program to run, each sub program is a thread
- sub-program/ sub-process are to be **light weight**

## Mutithreading example

High level to achieve Threads in Java:
Extending Thread Class + Implement Runnable Interface

### Extending Thread Class
- create child class that extends from java.lang.Thread class
- This child class will override the parent run() 
- All thread live's begins in run()
