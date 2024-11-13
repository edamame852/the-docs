---
title: Springboot
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
3. MVC is the model view controller

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
1. Presentation Layer (= Views/ Frontend side)
2. Data Access Layer (= CRUD operations on DB)
3. Service Layer (= Service class + use services from CRUD operations)
4. Integration Layer (= Different web services + XML messaging system)

## Classes
1. View Class (Has view service)
2. Utility Class (Has utility service)
3. Validator Class (Has validator service)

## Springboot flow
![springboot](./springboot_flow_arch.gif)

Points to note
1. Springboot and Spring MVC have 99% the same architecture but Springboot doesn't need DAO/ DAOImpl classes
2. Data Access Layer = Repository Class for designing CRUD

Normal flow
1. Client PUT/GET via https request, turns JSON into object, does Auth
2. Controller takes request and communicates w/ service logic if needed
3. Business logic happens in service layer (performing logic on data)
4. Logic = DB data is mapped through JPA with model or entity classes
5. returns JSP page