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
- `map()` applies a function to all items in an iterable and returns a map object (which is an iterator). Takes 2 arguments: a function and an iterable.
- `filter()` constructs an iterator from elements of an iterable for which a function returns true. Takes 2 arguments: a function and an iterable.
- `zip()` takes iterables (can be zero or more), aggregates them in a tuple, and returns an iterator of tuples. Takes 2+ iterables as arguments.

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
        even_numbers = list(filter(is_even, numbers))
    ```
## zip(): combining iterables
    ```python
        names = ['Alice', 'Bob', 'Charlie']
        ages = [25, 30, 35]
        combined = list(zip(names, ages))
    ```
- Another example with header list + elements nested list:
    ```python
        headers = ['Name', 'Age', 'City']
        data = [['Alice', 25, 'New York'], ['Bob', 30, 'Los Angeles'], ['Charlie', 35, 'Chicago']]
        combined = list(zip(headers, *data))
    ```

- Output would be:
    ```bash
        [('Name', 'Alice', 'Bob', 'Charlie'), ('Age', 25, 30, 35), ('City', 'New York', 'Los Angeles', 'Chicago')]
    ```
    