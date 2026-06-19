---
title: Decorators
layout: default
parent: Python 
grand_parent: Coding Practices
---


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

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