---
title: Coding interview (NeetCode)
layout: default
parent: Coding Practices
---
# Coding interview (NeetCode)
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# LeetCode

## Algorithms and Data Structures for Beginners
### Lesson 2 - LeetCode Questions
1. Easy - Remove Duplicates From Sorted Array <a href=https://leetcode.com/problems/remove-duplicates-from-sorted-array/description> (Q.26) </a>
- original input: `[0,0,1,1,1,2,2,3,3,4]`
- excepted output: `[0,1,2,3,4]`

Goal: Return k : int, the idx that will slice the original input up to a certain output
Method of solving: in-place replacing repeated elements

Step-by-step walkthrough:
```python
#Initially my list is : 
[0, 0, 1, 1, 1, 2, 2, 3, 3, 4]

[0, 1, 1, 1, 1, 2, 2, 3, 3, 4]
[0, 1, 2, 1, 1, 2, 2, 3, 3, 4]
[0, 1, 2, 3, 1, 2, 2, 3, 3, 4]
[0, 1, 2, 3, 4, 2, 2, 3, 3, 4]

#My terminating idx is : 5 
#(Since I only need [0,1,2,3,4] : when k = 5, it's our cut-off)
[0, 1, 2, 3, 4, 2, 2, 3, 3, 4]

```

Note: This algo will fail if the list is sorted non-increasingly

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        
        # Initialize two pointers: slow + fast
        ptr1 = 0  # Slow pointer (starts at idx 0)
        for ptr2 in range(1, len(nums)):  # Fast pointer (starts at idx 1)
            if nums[ptr2-1] != nums[ptr2]: # Increment slow pointer only if a NEW UNIQUE ELEMENT is found. (Always checks adjacent elements)
            # else, do nothing but keep looping
                ptr1 += 1 # Increment slow pointer
                # Move the unique element next to the last unique element found.
                nums[ptr1] = nums[ptr2] # replace 

        # Take-away: Slow pointer always points to the latest unique element
        
        # Return the length of the array consisting of unique elements only.
        # Since i is an index, add 1 to represent the count.
        return ptr1 + 1
        

```
2. Easy - Remove elements From Array given val <a href=https://leetcode.com/problems/remove-element> (Q.27) </a>
- original input: `[0,1,2,2,3,0,4,2]`
- val: `2`  
- excepted output: `[0,1,3,0,4]`

Goal: Return k : int, the idx that will slice the original input up to a certain output

```python
[0, 1, 2, 2, 3, 0, 4, 2] # Initally
[0, 1, 2, 2, 3, 0, 4, 2] # 
[0, 1, 2, 2, 3, 0, 4, 2]
[0, 1, 3, 2, 3, 0, 4, 2]
[0, 1, 3, 0, 3, 0, 4, 2]
[0, 1, 3, 0, 4, 0, 4, 2]
Return solution: 5
```

```python
class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        L_idx = 0
        for R_idx in range(len(nums)):
            if nums[R_idx] != val:
                nums[L_idx] = nums[R_idx]
                L_idx += 1
        return L_idx
```

## Question from companies

1. Find Maximum sub-array

Answer: using Kadane's algorithim

```python
def max_sub_array(arr:list, target:int):
    max_sum = float('-inf')
    current_sum, start, end, temp = 0,0,0,0

    for i in range(len(arr)):
        current_sum += arr[i]

        if max_sum < current_sum: # What we want
            max_sum = current_sum
            start = temp
            end = i
        
        if current_sum <= 0: # resets
            current_sum = 0
            temp = i+1 # increment next var
        
    if max_sum > target:
        return arr[start:end+1]
    
    else:
        return []

```

2. Greping from txt file

```bash
cat data.txt | grep 'dir=buy' | awk -F ';' '{split($1,a,"T"); qty[a[1]]+=$4;} END{for (i in qty) print i, qty[i]}'
```