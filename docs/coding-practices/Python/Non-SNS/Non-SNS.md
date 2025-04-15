---
title: Non-SNS
layout: default
parent: Python 
grand_parent: Coding Practices
---
# Non-SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Dunner variables

>FYI, there are a few dunner methods/ variables <br/>
> You can find them via `print(dir())` <br/>
> These are the listed ones: <br/>
> `__annotations__, __builtins__, __cached__, __doc__, __file__, __loader__, __name__, __package__, __spec__`
{:.note}

## Without using `if __name__ == "__main__"`

- Running python file directly 
```python
print(__name__) # returns __main__

# Explained: When running python file directly, __name__ is set to main
```

- Running python file via import <br/>

fileA
```python
print(__name__) # returns __main__

# Explained: When running python file directly, __name__ is set to main
```

fileB
```python
import fileA # returns fileA

#Explained: Since fileB imported fileA, meaning fileA was ran once through fileB
```

- Running python file via import methods without `if __name__ == "__main__"` <br/>

fileA
```python
def do_something():
    print('doing something')

do_something() # Prints doing something

# Explained: When running python file directly with do_something(), it prints doing something
```

fileB
```python
from fileA import do_something # returns 1st print statement

do_something() # This returns the 2nd print statments

#Explained: Since fileB imported fileA, meaning fileA was ran once through fileB, then ran again
```

## Using `if __name__ = "__main__"`

fileA
```python
def do_something():
    print('doing something')

if __name__ == '__main__':
    do_something() # Prints doing something

# Explained: When running python file directly with do_something(), it prints doing something
```

fileB
```python
from fileA import do_something # returns nothing!
# This is because do_something is invokes and it's not equal to __main__, it's equal to fileA, ergo, no print statements! 

do_something() # This returns the 1st print statment!

#Explained: 
```

# Decorators `@` in Python

## `@timing` 

You can implement your own decorator and put this module in your utils/timing.py

```python
import time

def timing(f):
    def wrap(*args, **kwargs):
        time1=time.time()

        ret=f(*args, **kwargs)

        time2=time.time()
        time_took = time2-time1
        args[0]._logger.info(f"The {f.__name__} method took {time_took} seconds to generate ")
        return ret
    return wrap
```

## The use of `__iter__` and `__next__`

- Both methods are to create iterable objects inside for/while loops
- `__iter__` : Dunder method that is called when an object is initialized as an iterator, returns iterator object itself since it makes an object iterable
- `__next__`: Dunder method to retrive the next item from the iterator, when no more items will return, it raises a `StopIteration` exception 

```python
class MyIterator:
    def __init__(self, limit):
        self.limit = limit
        self.counter = 0

    def __iter__(self):
        return self  # The iterator object itself

    def __next__(self):
        if self.counter < self.limit:
            self.counter += 1
            return self.counter
        else:
            raise StopIteration  # No more items to iterate over

# Usage
my_iter = MyIterator(5)
for num in my_iter:
    print(num)
```

## What is a context manager in python

## The difference between