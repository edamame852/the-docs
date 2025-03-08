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
# Errors

## Syntax Errors
- Occurs during compiling time (before program is executed)
- Example: `if True print("Hello")`
- Output: SyntaxError: invalid syntax

## Exceptions Errors
- Occurs during program executions, all default execptions are built-in 
- Different built in errors (i.e. there are 11 of them)

1. TypeError
- Occurs when operation/function is applied to an object of a wrong type
- Example: `len(4)`
- Output: TypeError: object of type 'int' has no len()

2. ValueError
- Occurs when functions inputs got the right type but wrong value
- Example: `int("abc")`
- Output: ValueError: invalid literal for int() with base 10: 'abc'

3. IndexError
- Occurs when index is out of range
- Example: 
```python
lst = [1, 2, 3]
print(lst[5])
```
- Output: IndexError: list index out of range

4. KeyError
- Occurs when dict key is not found
- Example: 
```python
d = {"a": 1}
print(d["b"])
```
- Output: KeyError: 'b'

5. AttributeError
- Occurs when method/attribute is not found
- Example: 
```python
obj = None
obj.method()
```
- Output: AttributeError: 'NoneType' object has no attribute 'method'

6. NameError
- Occurs when local/global var of the object is not found
- Example: 
```python
print(x)
```
- Output: NameError: name 'x' is not defined

7. ZeroDivisionError
- Occurs when you divide by 0
- Example: 
```python
1 / 0 
```
- Output: ZeroDivisionError: division by zero

8. FileNotFoundError
- Occurs when the input file/dir doesn't exist
- Example: 
```python
open("non_existent_file.txt")
```
- Output: FileNotFoundError: [Errno 2] No such file or directory: 'non_existent_file.txt'

9. ImportError
- Occurs when the module doesn't exist
- Example: 
```python
import non_existent_package.non_existent_module as nem
```
- Output: ImportError: No module named 'non_existent_module'

10. IndentationError
- Occurs during incorrect identation
- Example: 
```python
def func():
print("Hello")
```
- Output: IndentationError: expected an indented block

11. RuntimeError
- Occurs when error doesn't belong in any of the 10 exceptions + 1 Syntax Error 
- Example: 
```python
raise RuntimeError("This is a runtime error")  
```
- Output: RuntimeError: This is a runtime error


## User Customized Errors:

```python

class MyCustomErrors(Exception):
    pass

raise MyCustomErrors("This is a custom error")

```

## How to handle execptions

Example

```python
try:
    # Code that may raise an exception
    result = 1 / 0

# Could be executed
except ZeroDivisionError as e:
    # Handle the exception
    print(f"Caught an exception: {e}")
# Could be executed
else: 
    # Code to execute if no exception occurs
    print("No exception occurred")
finally: # Code will ALWAYS execute!!
    # Code to execute regardless of whether an exception occurs or not
    print("This will always execute")

```

High level idea:
- ending 1: try -> except -> finally
- ending 2: try -> else -> finally

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

# Dunder Methods (from Youtube by Indently)
## 5 useful dunder methods (aka magic methods) ```__eq__``` ```__format__``` ```__or__``` ```__repr__``` ```__getitem__``` 
{: .fs-6 .fw-300 }

We will use the follow Fruit class as basis for all the following examples
{:.warning}

Please refer to [this](https://www.youtube.com/watch?v=y1ZWQQEe5PM) youtube video

```python 
class Fruit:
    # * forces name & grams to be manditory keyword arguments
    def __init__(self, *, name:str, grams:float) -> None: 
        self.name = name 
        self.grams = grams

def main() -> None:

if __name__ == '__main__':
    main()
```
Have fun and try to understand these 5 dunner methods and use it alongside `__init__` ~
{:.warning}

### Let's start with  ```__eq__``` (TLDR: using `__eq__` changes how `==` performs)

``` python
class Fruit:
    # * forces name & grams to be manditory keyword arguments
    def __init__(self, *, name:str, grams:float) -> None: 
        self.name = name #Assign both input value to the instance
        self.grams = grams

    ########################################## Showcasing __eq__ ##########################################
    # Comparing instances from instances (it's clear now that Self has to be another class of Fruit)
    def __eq__(self, other:Self) -> bool:
        #This compares both name and grams as a dictionary!
        return  self.__dict__ == other.__dict__ 
    ########################################## End of showcasing __eq__ ###################################

# Let's instantiate a 2 instances from this object 
def main() -> None:
    f1: Fruit = Fruit(name='Apple', grams=100) #f1 and f2 are alias, that has type Fruit
    f2: Fruit = Fruit(name='Orange', grams=150)
    f3: Fruit = Fruit(name='Apple', grams=100)

    #Let's check to see if f1 and f2 are equal
    print(f1 == f2) # Returns false due to different memory addresses (not their values) 
    print(f1 == f3) # Before implementing __eq__, returns false (since diff mem address)
                    # After __eq__, returns true (since name and grams are compared in a dict)

if __name__ == '__main__':
    main()

```
### Format speicifier: ```__format__``` (TLDR: variable:kg -> triggers `__format__`)

```python 
class Fruit:
    # * forces name & grams to be manditory keyword arguments
    def __init__(self, *, name:str, grams:float) -> None: 
        self.name = name 
        self.grams = grams
    ########################################## Showcasing __format__ ##########################################
    # Comparing instances from instances (it's clear now that Self has to be another class of Fruit)
    def __format__(self, format_spec:str) -> str:
        match format_spec:
            case 'kg':
                return f'{self.grams / 1000:.2f} kg' #formatted to 2 d.p
            case 'desc': # Description
                return f'{self.grams} of {self.name} !!'
            case _: #Raise value error to signal user 
                raise ValueError('Unknown format specifier...') 
    ########################################## End of showcasing __format__ ###################################
    

def main() -> None:
    apple: Fruit = Fruit(name='Apple', grams=2500)
    print(f'{apple:kg}') # This will trigger the format specifier, returns 2.50 kg

if __name__ == '__main__':
    main()
```

### Or dunner method ```__or__``` (TLDR: )

Quick demo of the union opertor in action, the vertical bar symbol <a href="https://wumbo.net/symbols/vertical-bar/"> click me </a> <br/>
The demo can also be shown in the following example
```python 
class Fruit:
    # * forces name & grams to be manditory keyword arguments
    def __init__(self, *, name:str, grams:float) -> None: 
        self.name = name 
        self.grams = grams

def main() -> None:
    d1: dict = {1:'a', 2:'b'}
    d2: dict = {3:'c', 4:'d'}

    s1:set = {1,2}
    s2:set = {3,4}
    print(d1 | d2) # | is the union operator (works w/ sets and dictionary) #get back all the key and value pairs

    print(s1 | s2) # get back all the values

if __name__ == '__main__':
    main()
```

Back to our example for ``` __or__``` use:

```python
class Fruit:
    # * forces name & grams to be manditory keyword arguments
    def __init__(self, *, name:str, grams:float) -> None: 
        self.name = name 
        self.grams = grams
    ########################################## Showcasing __or__ ##########################################
    # Comparing instances from instances (it's clear now that Self has to be another class of Fruit)
    def __or__(self, other:Self) -> str:
        new_name:str = f'{self.name} & {other.name}'
        new_grams:float = self.grams + other.grams
        return Fruit(name=new_name, grams=new_grams) #setting new name and new grams
    ########################################## End of showcasing __or__ ###################################
    

def main() -> None:
    apple: Fruit = Fruit(name='Apple', grams=2500)
    orange: Fruit = Fruit(name='Orange', grams=2500)
    banana: Fruit = Fruit(name='Banana', grams=2500)

    combined:Fruit = apple|orange # without __or__ this will throw an error since this logic was not implemented
                                

if __name__ == '__main__':
    main()
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
