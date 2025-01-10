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
`1 -> $0` , `2 -> $4` , `3 -> $8`

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

### Dynamics Arrays (16 mins) Come back to revisit this

1. All arrays in Python and JS are default to be **dynamic**
    - Example: 
        ```python
        array_example = [] 
        ```
        
        ```javascript
        const array_example = [];
        ```

    - It's not the case in C++ or Java
        ```java
        List<Integer> array_example = new ArrayList <Integer>(); 
        ```

        ```c++
        vector<int> array_example;
        ```
2. Problem in static array: Fixed-size problem
Since static array is crated with specified size

    - Q: what if we have a dynamic array?
    - Ans: assigned to default size (e.g. 10) with length at 0 (nothing added to it)
        - Pushing to the array = appending to the array

#### Pushing and Popping
- Pushing to end pointer of an array: points to the last pushed element location (it's how we get the length too!)

Pushing/ Appending to arrays: O(1) operation
{:.note }

- popping value: O(1) Operation, since we know where exactly the operation happens. pop then shift the end ptr to the left index (maintaining the new ptr)
Popping last ptr: O(1) operation
{:.note }

- Even in dynamic array, it won't go directly to the back of an array. Instead it copies the entries and creates a new array

#### Creating new arrays (the concept of dynamic)
- Originally: [0,4,7] lives in $0, $4, $8
- Now: [0,4,7] lives $40, $44, $48, $52, $56, $60 
    - This solves the problem for not having enough spaces
    - You can append a `9` at the end
    - The original array can be **de-allocated** (To free up memory)

Creating new array: O(n) operation, n is the size of mem allocated. Old elements needs to be pushed to the new one, all of them another O(n)
{:.note }

- High level overview:
    - Append element at the end ptr 
    - Ran out of space
    - Copy everything to a new array (double original size + another ram mem location)
    - Insert the new element
    - New array still has extra spaces :D

- Q: Why don't we just +1 our original array?
- A: For the sake of Amortized time complexity
    - It takes O(n) if original array runs out of space
    - But running out of space is infrequent
    - Ergo, pushing value to dynamic array O(1) = Average time, Amortized time complexity
    - This dates back to math, on Power Series

We don't care about constants in Big-O representation, after the intersection point it's always going to be under the heavier operation. Ergo the expensive operation, which CPU is designed to solve
{:.note }

To Recap: O(1) read/write i-element, pop/ append at the end
O(n): Inserting/ popping the middle
{:.note }

## Stacks

- Actually, dynamic arrays satisfies the condition of a stack
- They commonly has 3 different operations: pop, push, peek (All O(1) operations)

### High level overview:
- push 1, push 2, push 3, pop 3, pop 2, pop 1
- Last element pushed = first one popped
- AKA: Last In First Out (LIFO)
    - Use case: Reverse a sequence

### Coding Question: Valid Parentheses

Given string s, check whether the open bracket is closed accordingly (same type and same order), return true is yes, false if no

O(n) solution

```python

stack = [] # List is a stack
HashMap = { ")" : "(", "]" : "[", "}" : "{" }

for char in s:
    if char in HashMap: # If it's a closing bracket
        if stack and stack[-1] == HashMap[char]: # Make sure stack is NON-empty (cannot add closing bracket to an empty stack) + value at top of stack is matching OPENING bracket
            stack.pop()
        else:
            return False # if stack is empty / not matching set of bracket
    else: # For opening brackets
        stack.append(char) # Append as much as the opening bracket as u want
```

## Linked Lists

### Basics
- Linked lists is made up of 1 thing: List node (or node)
- This node object encapsulates 2 ideas:
    - value (i.e. int, char, another object)
    - next (a pointer) (i.e. the next list node in the linked list)
        - if next = `null` then the node has no next node

- Example : Linked list in action, storing in memory
    - 1. Created 3 nodes, red, blue, green (i.e. ListNode1, ListNode2, ListNode3)
    - 2. Connect them by pointers
    - 3. Set ListNode1.next = ListNode2
    - When we talk about pointers = references to object
    - 4. Note they are stored randomly in memory (the 3 colors)
    - 5. 
