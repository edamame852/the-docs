---
title: Ch.1
layout: default
parent: Backend 
grand_parent: Coding Practices
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# 1. Springboot background

## Pre-reqs: 
1. Understand Java (i.e. classes, objects, inheritance, interfaces, and exception handling)
2. Familiarity with build tools i.e. Maven/Gradle

## History
1. Spring is popular due to Spring MVC, letting user to create scalable web apps.
2. Spring (MVC) project config = too time-consuming, hence Springboot is introduced in early 2013.
3. Springboot is build on top of Spring (has all of Spring's feature). It's a micro-service and production ready driven framework

## Pros of Springboot
1. Avoids complicated XML configuration such as in MVC
    - Springboot auto-configures xml   
    - e.g. To use hibernate ORM, just add `@Table` annotation to model/entity class and `@Column` to map it to columns and tables
2. Easy maintenance and upgrades for REST API 
    - e.g. Add `@RequestMapping` for the /endpoint & `@RestController` on controller class
3. Embedded w/ tomcat server (i.e. Web App can be hosted on it)
4. Easy deployment (via .jar/.war under tomcat server, tomcat server instance on cloud also ok...)
5. Micro service based architecture (single type feature focused)
    - Monolithic system (non-micro service based) = 1 code containing all features
    - Micro service based = modularized into sub-systems = easier deployment & debugging

# 2. Springboot Architecture

## Layers
1. Presentation Layer
2. Data Access Layer
3. Service Layer
4. Integration Layer