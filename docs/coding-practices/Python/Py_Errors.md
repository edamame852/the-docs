---
title: Error Handling & Exceptions
layout: default
parent: Python 
grand_parent: Coding Practices
---

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
- 
    ```python
    class MyCustomErrors(Exception):
        pass

    raise MyCustomErrors("This is a custom error")
    ```

## How to handle execptions

- Example 1

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
        # Code to execute if no exception occurs !
        print("No exception occurred")
    finally: # Code will ALWAYS execute!!
        # Code to execute regardless of whether an exception occurs or not
        print("This will always execute")

    ```
- Example 2:

    ```python
    try:
        num = int(input("Enter a number: "))
        result = 10 / num
    except ValueError:
        print("❌ Invalid input. Please enter a valid integer.")
    except ZeroDivisionError:
        print("❌ Cannot divide by zero.")
    else:
        print(f"✅ Result is {result}")
    finally:
        print("🔹 Program finished.")

    '''
    How it works:

    If the user enters a non-integer → ValueError is caught.
    If the user enters 0 → ZeroDivisionError is caught.
    If no error → else block runs.
    finally always runs
    '''
    ```

High level idea:
- ending 1: try -> except -> finally
- ending 2: try -> else -> finally