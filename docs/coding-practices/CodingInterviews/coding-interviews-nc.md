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

# LeetCode [here](https://neetcode.io/)


## Algorithms and Data Structures for Beginners
Note: Please log in with non-incsw Gmail account
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

3. ? - Remove Duplicates From unsorted Array
- original input: `[2,0,1,6,3,1,2,11,3,3,4]`
- excepted output: `[0,1,2,3,4]`


## Question from Citadel

1. Find Maximum sub-array

Aka: maximum segment sum problem

Answer: using Kadane's algorithim = Greedy Algorithm

Reference document: https://www.geeksforgeeks.org/dsa/largest-sum-contiguous-subarray/ 

```python
# Step 1 : Define 2 input params
def max_sub_array(arr:list, target:int):
    # Step 1: Initialize 5 base cases 
    max_sum = float('-inf') # Negative inifinity so all future sums will be larger! 
    current_sum, start, end, pointer = 0,0,0,0

    # Step 2: Setup for-loop, iterate through arr
    for i in range(len(arr)):
        current_sum += arr[i]

        if max_sum < current_sum: # What we want
            max_sum = current_sum
            start = pointer
            end = i
        
        if current_sum <= 0: # resets when sub-array is less than or equal to 0
            current_sum = 0
            pointer = i+1 # increment next var
        
    if max_sum > target:
        return arr[start:end+1]
    
    else:
        return []

```

another way of solving this

O(n^2) Time and O(1) Space. Not the best way but straightforward
```python
def maxSubarraySum(arr):
    res = arr[0] # Initialize result, value of the first element in list/input array. Aka the current max.
  
    # Outer loop for starting point of subarray
    for i in range(len(arr)):
        currSumFromOuterLoop = 0
      
        # Inner loop for ending point of subarray
        for j in range(i, len(arr)):
            currSumFromOuterLoop = currSumFromOuterLoop + arr[j]
            # Update res if currSum is greater than res
            res = max(res, currSumFromOuterLoop)
          
    return res

if __name__ == "__main__":
    arr = [2, 3, -8, 7, -1, 2, 3]
    print(maxSubarraySum(arr))
```

2. Greping from txt file with lines of input (e.g. ... )

Question: Given a 

```bash
cat data.txt | grep 'dir=buy' | awk -F ';' '{split($1,a,"T"); qty[a[1]]+=$4;} END{for (i in qty) print i, qty[i]}'
```


3. Anagram of strings
Question: Write a function that takes in 2 strings (s1 and s2). Returns true if they are anagrams, else false.
Hint: Anagrams are words/phrase that are rearranged from original letters exactly ONCE (i.e. tame vs mate)

Solution 1: Simplest Approach

```python
def is_anagram(s1:str, s2:str) -> bool:
    return sorted(s1) == sorted(s2)

#Test Cases:
print(is_anagram("listen","silent") == True)
print(is_anagram("triangle","integral") == True) 
print(is_anagram("apple","pale") == False) 
```

Solution 2: Solve with Hash Map (first add then deduct)

```python
def is_anagram(s1:str, s2:str) -> bool:
    if len(s1) != len(s2):
        return False

    # Count characters in s1
    for char in s1:
        if char in char_count:
            char_count[char] += 1
        else:
            char_count[char] = 1

    # Subtract the count for each character in s2
    for char in s2:
        if char in char_count:
            char_count[char] -= 1
            if char_count[char] == 0:
                del char_count[char]
        else:
            return False

    # If the dictionary is empty, the strings are anagrams
    return len(char_count) == 0


#Test Cases:
print(is_anagram("listen","silent") == True)
print(is_anagram("triangle","integral") == True) 
print(is_anagram("apple","pale") == False) 
```

3. Anagram min swap
Question: Write a function with 2 input strings, return the min number of char position swap required from s2 to become s1

```python

def anagram_min_swap(s1:str, s2:str) -> bool:
    if len(s1) != len(s2):
        raise SyntaxError

    s1 = list(s1)
    s2 = list(s2)
    swaps = 0

    for i in range(len(s1)):
        if s1[i] != s2[i]:
            # Find the index in s2 where s1[i] is located
            j = i
            while j < len(s2) and s2[j] != s1[i]:
                j += 1

            # Swap characters in s2 to match s1[i]
            while j > i:
                s2[j], s2[j - 1] = s2[j - 1], s2[j]
                swaps += 1
                j -= 1

    return swaps

print(anagram_min_swap("listen","silent")==3)
print(anagram_min_swap("triangle","integral")==5)

```