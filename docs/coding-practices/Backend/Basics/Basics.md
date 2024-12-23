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

## Multithreading example

High level to achieve Threads in Java:
(1) Extending Thread Class OR (2) Implement Runnable Interface

### Pros vs Cons and Differences
1. Issue with inheritance 
- Extending Thread Class: Cannot extend more than Thread class since Java doesn't have multi-inheritance
- Runnable Interface: Can still extend other base ckasses

2. Issue with built-in Java methods
- Extending Thread Class: Has the built-in methods
- Runnable Interface: Doesn't have methods like yield() and interrupt() 

3. Sharing Thread objects
- Extending Thread Class:  cannot share
- Runnable Interface:Yes, Thread objects can be shared between different threads


### Extending Thread Class
- create child class that extends from java.lang.Thread class
- Child class will override parent run() method
- All threads live's begins in run()

```java
import java.lang.*;

// Child Thread Class
class ChildMultiThreading extends Thread {
	public void run() {
		try{"Thread"+Thread.currentThread().getId()+"is running"}
		catch (Execption e) { System.out.println ("GG, Exception hit")}
	}
}
// Parent main class
public class ParentMultithreading {
	public static void main(String[] args) {
		int max = 10;
		for (int i = 0; i < max; i++) {
			ChildMultiThreading object = new ChildMultiThreading()
			object.start()
		}
	}
}

```

The output would be...Thread 15 is running, Thread 14 is running, Thread 11 is running ....
Until it prints for 10 times

## Creating Runnable Interface
```java

// Child Thread Class
class ChildMultiThreading extends Runnable {
	public void run() {
		try{"Thread"+Thread.currentThread().getId()+"is running"}
		catch (Execption e) { System.out.println ("GG, Exception hit")}
	}
}
// Parent main class
public class ParentMultithreading {
	public static void main(String[] args) {
		int max = 10;
		for (int i = 0; i < max; i++) {
			Thread object = new Thread(new ChildMultiThreading());
			object.start()
		}
	}
}

```

# 2. Java OOP

## Basic Concepts 
1. Access modifiers for methods/data members/classes/ interfaces
- private = accessible only within the class (not avaliable in non-nested class/interface)
- default/ package-private = when no access modifier is listed 
- protected = accessible only in subclass  (not avaliable in non-nested class/interface)
- public = Accessible from any class

Note: There is no private and protected class/ interface

2. Class, Superclass (Parent), Interfaces
- Interface is a comma-seperated list that is implemented by the class
for exmaple:
```java
interface Animal {
	void animalSound();
	void sleep();
}
```

## 4 major pillars: Abstraction, Encapsulation, Inheritance, Polymorphism
- Abstraction: Hiding inner logic from users via using interfaces + abstract classes
	- Abstract classes in Java = a class that cannot be instantiated by itself, must require sub-classed by another class
	- Example:

	```java
	abstract class Shape { // abstract class
		int color;
		abstract void draw(); // abstract method
	}
	```
{:.warning}
> Some important points: 
> Instance of an abstract class cannot be created. 
> But abstract classes can be inherited as a subclass by a class
> Not all abstract class has abstract methods
> final method and static methods are allowed in abstract classes
> Abstract class are faster than interface since there's no search feature before overriding other method, so abstract classes can be directly used

- Encapsulation
- Inheritance
- Polymorphism


# 3. JDBC (Java Database Connectivity)

## Background
1. JDBC is a Java API to connect and run query on DB
2. JDBC's interface & classes + DB Driver = able to run the DB

## 4 components of JDBC
1. JDBC API
2. JDBC Driver manager: loading drivers for DB connection
3. JDBC Test Suite: Testing JDBC driver CRUD operations
4. JDBC-ODBC Bridge Drivers: Turning JDBC method call -> ODBC Function call (aka connect DB drivers to DB)