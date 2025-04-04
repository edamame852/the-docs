---
title: Java-Basics
layout: default
parent: Backend 
grand_parent: Coding Practices
---

## Table of contents
{: .no_toc .text-delta }

---
# Topic 1 : Basics - Get Started with Java

## Java basic syntaxes

### Background
- Java is a statically typed, oop language (i.e. python is dynamically typed)
- Java is platform independent (can be compiled & executed on dif platforms)

### 2 different Java data types
1. Primitive Type = int, long, byte, short, floating-point value (float & double), logical values = booleans, chars
	- There are 8 primitive types!
	- These will be stored directly on the stack
	- 
	| Primitive type | size of bits | Min value | Max value | e.g. |
	|----------|----------|----------|----------|----------|
	| 1. byte   | 8  | -2**-7    | 2**7 - 1     | byte b = 100;     |
	| 2. short  | 16 | -2**-15     | 2*15 - 1     | short s = 30_000;     |
	| 3. int | 32 | -2**-31     | 2**31 - 1     | int i = 100_000_000;     |
	| 4. long   | 64 | -2**-63     | 2**63 - 1     | long l = 100_000_690_699_000;     |
	| 5. float   | 32 | -2**-149     | (2-2**-23)*2**127 =      | float f = 1.4269f;     |
	| 6. double   | 64 | -2**-1024     | (2-2**-52)*(2**1023) =    | double d = 1.3062470030624770;     |
	| 7. char   | 16 | 0     | 2**16-1     | char c = 'c';     |
	| 8. boolean   | 1  | N/A     | N/A     | boolean F = false;     |


2. Reference Type = reference to object/ reference to values (e.g. arrays)
	- Good example of reference type = String

```java
String myString = new String ('Hello World')
// Instance of the class String will create the object called myString and it contains a set of chars called 'Hello World'

```

### Declaring variables 
Must do 2 things: Declare `type` & `name` (aka `name` = `identifier`)

Terminologies:
- Declaration = setting up variable without values
- Assignment/ initialing = assigning values to variables 

```java
int a; // defaults to 0 for int
double b; // defaults to 0.0 for double
```

You can also init variables during declaration.
```java
double c = 100.69; 
/*
identifier here is "c"
with value of "100.69"
of type "double"
*/
```

### Semi-colon Syntax
- To terminate a statement `;`

### Valid identifier in Java
- Could only contain alphanumerical, underscore and dollar-sign and infinitely long !
- Must start with letter, underscore, dollar sign
- Cannot be reserved keywords nor `true`, `false`, `null` values
- Java keywords = reserved words in Java (These cannot be used as identifiers)
	- `public`
	- `static`
	- `class`
	- `main`
	- `new`
	- `instanceof`


### chars vs string
- chars is single-quote ``IamAChar`` or `c`
- strings are double quotes `"IamAString"`

### Arrays in Java
To instantiate an array in java `type[] identifier = new type[length]`. type here can be both reference/ primitive

```java

int[] myArray = new int[69];
myArray[0] = "a"
myArray[1] = "b"

int lengthOfMyArray = myArray.length; // Calling .length method
```

### Java Operators
- Assignment Operator `=`
- Arithmetic Operators `+` `-` `*` `/` `%`
- Logical operators `||` `&&` `!` (e.g. `if ( a%2 != 0 || a&2 == 0)`)
- Comparison Operators `<`,`<=`,`>`,`>=`,`!=`,`==`
	- Quick method used with a comparison operator
	- 
	```java
	public boolean canVotePresident (int age) {
		if (age < 18) {
			return false;
		}
		return true;
	}
	```

## Java Program Structure

1. Basic unit in Java = Class
2. Class can have one or multiple fields/ properties, methods, other classes (i.e. inner classes or class members)
3. main method MUST be included to make the Class executable, since main method means the entry point of the program

```java
public class SimpleAddition {
	public static void main (String[] args) {
		int a = 10;
		int b = 20;
		double c = a + b;
		System.out.println(a+"+"+b+"+"+"="+c);
	}
}
```
4. The whole code inside the curly bracket is called a `code block`

## Running Java = Compiling + Executing
1. Install JRE on your machine
2. compile the code: `javac SimpleAddition.java`
3. Execute the code: `java SimpleAddition.java` and return the result


# Topic 2 : Java OOP
-------------------------------------------------------------------------------------------------------------------------------------------------
# 0. Java 8 to Java 17 Migration (reference [link](https://www.baeldung.com/java-migrate-8-to-17))
- 1. Springboot version upgrade 2.x.x into 3.x.x
- 2. String Objects decommission use of char[] and use byte[] for better memory performance
- 3. 


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

