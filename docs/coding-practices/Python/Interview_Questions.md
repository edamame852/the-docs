---
title: Interview Questions
layout: default
parent: Python 
grand_parent: Coding Practices
---

# Python 3 Programming Questions

53. A Python dev must verify if key `x` is stored in a dictionary `my_dict`. If `x` is in `dict`, set value `found` to `True`; otherwise, set `found` to `False`. Which of the following code snippets will achieve this?

- Options:
    - `found = my_dict.has_key(x)`
    - :heavy_check_mark: `found = x in my_dict`
    - `found = my_dict.contains(x)`
    - `found = x.is_elem(my_dict)`
    - :heavy_check_mark:
    ```python
        found = True
        try:
            y = my_dict[x]
        except KeyError as e:
            found = False
    ```

54. Which of the following lines python of code generate the same "result" value as the following Python code snippnet

Code Snippet:

```python
    data = [1,2,3,4,5,6]

    def f1(x):
        return 3*x

    def f2(x):
        try:
            return x > 3
        except:
            return 0
    
    result = list(map(f1, filter(f2, data)))
```
> Note: `filter()` takes 2 arguments, a function and an iterable (e.g. list) <br/>
> The function passed to `filter()` should return a boolean value (True/False) <br/>
>`filter(func, iter) --> keep items if bool is True` <br/>

- Options:
    - :heavy_check_mark: `result = [3*i for i in data if i > 3]`
    - `result = [3*i for i in data(i) if i > 3]`
    - :heavy_check_mark: `result = list(map(lambda r: 3*r, filter(f2,data)))`
    - `result = list(map(lambda r: 3*r, filter(lambda f: f>3 or 0, data)))`
    - `result = [3*i for i in data(i) if i > 3 else 0]`