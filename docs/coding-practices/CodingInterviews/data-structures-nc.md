---
title: Data Structures
layout: default
parent: Coding Practices
---
# Data Structures
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Algos and Data Structs for noobs (尼特程式碼.io)

## Arrays
### Static Arrays (15 mins)

Static typed languages: Java, C++, C# (meaning the arrays will need allocated size and type when the array is created)
{:.note }

1. Properties of static arrays
- when array is full = no additional element can be added
- Javascript and Python DO NOT have static arrays

2. Reading from arrays

```python

A = [1,2,3]
A[i] 

```

Each element occupies 4 address 
`1 -> $0` , `1 -> $4` , `1 -> $8`

Accessing single element from array is instant
Due to the fact that the location of the element stored is MAPPED to an address in RAM. Hence O(1) time complexity.

O(1) is when the number of operations doesn't grow even when size of data/ input grows
{:.note }

3. Looping through arrays

```python
[A[element] for element in A]

'''
if A is size 10, then it performs 10 operations
if A is size 69, then it performs 69 operations (during the loop)
'''

```

4. Deleting end of array

soft delete = setting the end of array to 0/null/-1. Not really deleting but overwriting it with the new value. This will also reduce the length by 1
{:.note }

5. Deleting the i-th array

### Dynamics Arrays (16 mins)

1. All arrays in Python are default to be **dynamic**
    - Example: 
        ```python
         
        ```