---
title: 3_Structured_Program_Dev_in_C
layout: default
parent: C++ 
grand_parent: Coding Practices
---
# Non-SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---
page 101 - (Maximum 3.13)

# 3.1 Introduction
Ch.3 and Ch.4 will focus solely on Structured Programming

## 3.2 Algos
1. (Procedure = executed **actions**) + (the specific order of actions to be executed = program control) = algo
2. Program control = procedure + algorithm

## 3.3 Pseudo-code
By definition: Means this program is NOT to be executed on computers. Merely to think out.

## 3.4 Control Structures
1. Sequential execution = statements get executed one by one
2. Transfer of control = to run next statement other than the next one in sequence
3. In 60s, structure programming = eliminating goto statements
4. Solution to goto less programming is using 3 control structures
    - sequence structure = executes line after line unless told otherwise
    - selection structure = there are 3 types
        - if-statements (single-selection statement): true then do, false then skips
        - if-else statements (double-selection statement): can select from 2 actions 
        - switch statements (multiple-selection statement): many actions
    - iteration structure
        - for
        - do...while
        - while

5. A flowchart
    - Rectangle = action symbol
    - small circles = connector symbols/ entry point/ exit point
    - Diamond = decision symbols (if statements those things)

## 3.5 if selection statement
```c++
if (grade >= 60) {
    puts("Passed")
}
```

## 3.6 if-else selection statement
1. Conditional Operator (`?:`): It's C's ternary operator, has 3 operands
- 1st operand is condition
for example: 
```c++
puts(grade >= 60 ? "passed" : "failed") // condition ? True : False
```


2. Normal if-else statement
```c++
if (grade >= 60) {
    puts("Passed")
}
else {
    puts("failed")
}
```

3. 


## 3.7 while iteration statement

