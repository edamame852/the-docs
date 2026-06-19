---
title: .map(), .filter(), .zip()
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

# Explained in a nutshell
- `map(func, iterable)` — **transform** each element
    - **Input:** a function and an iterable (list, tuple, etc.)
    - **Logic:** applies `func` to every element, one by one
    - **Output:** a `map` object (wrap with `list()` to see results)
    - **Think of it as:** "do this to every item"
- `filter(func, iterable)` — **keep** only matching elements
    - **Input:** a function that returns `True`/`False` + an iterable
    - **Logic:** keeps only elements where `func(element)` returns `True`
    - **Output:** a `filter` object (wrap with `list()` to see results), holding original elements that passed the filter
    - **Think of it as:** "only keep items that pass this test"
- `zip(iter1, iter2, ...)` — **pair up** elements across iterables
    - **Input:** two or more iterables of any type
    - **Logic:** pairs the nth element of each iterable into a tuple; stops at the shortest iterable
    - **Output:** a `zip` object of tuples (wrap with `list()` to see results)
    - **Think of it as:** "stitch these lists together side by side"

## Reference Document/~~video~~:
- [Linkedin Forum](https://www.linkedin.com/pulse/3-python-functions-every-aspiring-data-must-know-map-benjamin-qiw8e/)

## map(): applies transforamtion to each element
```python
    def square(x):
        return x ** 2
    numbers = [1, 2, 3, 4, 5]
    squared_numbers = list(map(square, numbers))
```

## filter(): keeps only valid data after filtering
```python
    def is_even(x):
        return x % 2 == 0
    numbers = [1, 2, 3, 4, 5]

    '''
    Think of : filter(is_even,numbers) --> temp "[False, True, False, True, False]" --> [2,4] 
    IMPORANT: The filter object DOES NOT HOLD the booleans, but holds the original elemnts that passed the filter
    '''

    even_numbers = list(filter(is_even, numbers))
```
## zip(): combining iterables
```python
    names = ['Alice', 'Bob', 'Charlie']
    ages = [25, 30, 35]
    combined = list(zip(names, ages))
```


- Another example with header list + elements nested list:
    - 
        ```python
            headers = ['Name', 'Age', 'City']
            data = [['Alice', 25, 'New York'], ['Bob', 30, 'Los Angeles'], ['Charlie', 35, 'Chicago']]
            combined = list(zip(headers, *data))
        ```
    - 
        ```python
            '''
            Quick reminder of *data
            * is the unpack operator
            * unpacks exactly one layer:
            '''
                                            
            data = [['Alice', 25, 'New York'], ['Bob', 30, 'Los Angeles'], ['Charlie', 35, 'Chicago']]

            *data  =  ['Alice', 25, 'New York'],  ['Bob', 30, 'Los Angeles'],  ['Charlie', 35, 'Chicago']
        ```

- Output would be:
```bash
    [('Name', 'Alice', 'Bob', 'Charlie'), ('Age', 25, 30, 35), ('City', 'New York', 'Los Angeles', 'Chicago')]
```
    