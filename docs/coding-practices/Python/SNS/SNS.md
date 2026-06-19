---
title: SNS
layout: default
parent: Python 
grand_parent: Coding Practices
---

# SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---


# Python methods()

## .sort() vs sorted()
- `sorted(my_list)`: creates new list, can be use on any objects
- `my_list.sort()`: in-place modifying original list, can only be use on list

# Recursion in Python

## Mutiplication (but recursion)

```python
# Conventional
def mul(x,y):
    return x*y

# Recursion
def mul(x,y):
    if y == 0:
        return 0
    return x + mul(x,y-1)
```

## Division (but recursion)
```python
# Conventional
def division(x,y):
    return x/y


# Recursion
def division(x,y):
    if x < y:
        return 0
    else:
        return 1 + division(x-y, y) #  1 + (13,2) = 2 + (11,2) = 3 + (9,2) = 4 + (7,2) = 5 + (5,2) = 6 + (3,2) = 7 + (1,2) 

```

# List
## List Comprehension

# Walrus Operator (:=) ([From Youtube by Indently](https://www.youtube.com/watch?v=MEMDi9mTCiU))
Walrus Operator assign values to variables as part of a larger expression (aka: assign block scope variable)

Example 1: Reducing extra line of code
```python

def analyze_text(text:str) -> dict:
    # The returned dictionary is as follows
    details: dict = {
        # Walrus operator basically reduces the need to write an extra line of 
        #words = text.split()
        'words': (words := text.split()), 
        'amount': len(words)
        'chars': len(''.join(words))
    }
    return details
```

Example 2: Same as Example 1, reduces extra line of code
```python
if (text := len(user_input)) > 5:
    print(text, "thumbs up!")
else:
    print(text, "thumbs down")

```

Example 3: Combining Example 1 and 2, reduces extra line of code
```python
def get_value():
    return 'value'

# So this statement  var = get_value() is no longer needed
if var := get_value():
    print(var)
else:
    print('No value')

```


# Static Methods vs Class Methods vs Instance Methods vs Abstract Method

## Usage of Instance Mehtods

You're already using it lmao <br/>
As long as they are not annotated as `@staticmethod` or `@classmethod`

## Usage of @staticmethod

instance convention: `self` but could be something else :)

```python

class Calculator:
    def __init__(self, version:int, name:str):
        self.version = version
        self.name = name

    def get_calculator_info(self):
        return f'Welcome to calculator {self.name} on version {self.version}'

    @staticmethod 
    def add_all_nums(self, *numbers):
        return sum(*numbers)
```
TLDR: 
- `@staticmethod` is used only in classes!
- `@staticmethod` indicates the method could be called without instanciation (of the class it was in)
    - If we instanciate
    ```python 
    calc:Calculator = Calculator(version=1.0, name='First Calculator')
    calc.get_calculator_info() #This works (An instance method)
    calc.add_all_nums(1,2,3) #This also works (An instance method)
    ```
    - If we DO NOT instanciate -> *** TypeError! ***
    ```python 
    Calculator.get_calculator_info() #Throws TypeError execption, mission instance self, since missing 1 required position argument
    Calculator.add_all_nums(1,2,3) #This STILL works
    ```

## Usage of @classmethod

instance convention: `cls`

```python
from typing import Self

class Calculator:
    member_variable_counter = 0 # class member variable here !

    def __init__(self, version:int, name:str):
        self.version = version
        self.name = name

    def get_calculator_info(self):
        return f'Welcome to calculator {self.name} on version {self.version}'

    @classmethod 
    def add_counter(cls):
        return cls.member_variable_counter += 1

    @classmethod
    def get_counter(cls)
        return f"This class was called {cls.member_variable_counter} time(s)"


```

@Classmethod is good when you have to alter, call class member variables !

TLDR: 
- classmethod bounds to and affects the actual class (cls)
- staticmethod bounds to and affects the instance (self)

## @abstractmethod

```python
from abc import ABC, abstractmethod

class BaseClass(ABC):
    def __init__(self):
        pass
    
    @abstractmethod
    def core_logic():
        pass
    
    def run(self):
        self.core_logic()

```
Here `@abstractmethod` incidates that who even inherits from BaseClass would have to implement the call logic themselves, also it's empty in the BaseClass, in the Child Class this method is to be properly implemented.
