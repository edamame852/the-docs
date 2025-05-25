---
title: Interview
layout: default
parent: Backend 
grand_parent: Coding Practices
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# 1. Morgan Stanley - Full Stack Java Interview

## Questions on Java
1. Name the difference between a class & an interface
Ans: 
- class: a blueprint for creating objects.
     - methods can hold actions
     - member variables can hold properties
- interfaces: a contract that binds the class to obey
     - Interface defines actions (methods) that a class must follow (similar to `@abstractmethod` in python!)
     - contains only method signatures with NO IMPLEMENTATION (you can add implementation tho since Java 8)
     - Example Code:

     ```java
     interface Animal {
          void makeSound(); // Kinda an Abstract method
     }

     class Dog implements Animal {
          @Override
          public void makeSound() {
               System.out.println("Woof!");
          }
     }
     ```

2. Java Multi-threading, what is it and how to use it?
Ans: 
- Multi-threading = doing multiple-tasks at the same time
- In Java, you can use `interface Runnable` or `class Thread` to let tasks run in parallel

3. What different testing skills are used in Java ? Regression, Unit, Smoke...
Ans: 
- Regression testing: Ensuring new changes (i.e. bug fix/ new features) don't break production, focusing on BAU performance
- Unit testing: Testing single function/ parts of code
- Smoke testing: Quick test to see basic features still working (pre-lim testing)
- integration testing: Ensuring different modules and components work well together, focusing on interactions (e.g. frontend and backend)

4. Benefits of OOP (in Java or in coding in general)
Ans: 
- There are mainly 3
     - reusability: reusing instead of copying code
     - organized: Easier to understand and manage
     - flexibility: changing scope of a code

5. How does a Java service component connect to its client/ server side ?
Ans: 
- Client <-> HTTP Requests <-> Server
- Using REST APIs 

6. How are maps used in Java?
Ans: 
- map = dictionary, storing key-value pairs

7. How are maps different from each other (Difference of Ordered Map vs Hash Map)
Ans: 
- HashMap: Order of items NOT IN order
- Ordered Map: Keeping order of items in specific order

8. What are the design patterns used in Java projects? E.g. Singleton...
Ans: 
- Design patterns: templates for solving coding problems
     - Examples:
          - Singletons: 1 class instance only

## Question on Business knowledge

1. What is an ELN (Equity Linked Note)
Ans: 
- Mix of loan & investment
- Money grows on company stock performance

2. What is an option?
Ans: 
- Guaranteeing you buy/sell a stock at fixed price in the future
- Like a supermarket coupon, you can choice to exercise/ not exercise
- Strike price : to buy/sell at fixed price

3. What is a swap?
Ans: 
- Trade between 2 counter-parties
- 1 takes variable interest  vs 1 takes fixed interest

4. How does an iBank make money (as a sell side)
Ans: 
- Sell side helps companies and charges fees in services

5. Difference between Equity and Equity Derivative
Ans: 
- Equity: Owning parts of company (owning company stocks)
- Equity Derivatives: Financial product with underlying as equity.
     - Not directly owning company stocks
     - Trading on contract based on stock's performance
     - Example: an option, future, swaps
     - Allows user to leverage investments
          - Controlling large amounts of stocks for small investments (Price of option < price of stock)
     - Allows users to enter speculative bets
          - Not owning the stock
          - But high risk high return