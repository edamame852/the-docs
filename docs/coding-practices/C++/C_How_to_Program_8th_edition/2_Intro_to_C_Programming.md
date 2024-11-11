---
title: 2_Intro_to_C_Programming
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
# 2.1 Introduction
- Introducing important features of C
- Ch.3 and Ch.4 will cover C structured programming
- Programming in C securely is the gist!

# 2.2 Priting text, a simple program 

- comments: for documentation
- Functions: Perform action and makes decision = Action-decision model

Example

```C++
// Comments = readability and documentations, ignored by compiler so no outputting machine-language obj code
// We prefer this single-lined comment since shorter and less error prone

/*
Multi-line comments are like this
*/

// = To include contents of standard input output header (e.g. printf). More about this in Ch.5
#include <stdio.h> // Pre-processor directive, header file is processed pre-compiling

int main (void) { // One function must be "main" // int = return value is int // void = no input params
    printf("welcome to C \n"); // f = formatted ; = statement terminator
}
```
- Escape chars:
    - `\n` = New line
    - `\t` = Horizontal tab
    - `\a` = Alert sound/ visable alert
    - `\\` = Backslash raw string (since just `\` is part of an escape char)
    - `\"` = Double quote raw string

## Linker and Executables
1. Standard lib function (i.e. `printf` & `scanf`), compiler cannot identify spelling error, linker can!
2. Linker locates lib f(x) and insert calls into the object program . That's why Linker = executable

# 2.3 Adding 2 integers, a simple program

1. To re-iterate some useful commands: `scanf` (To read in an integer)

e.g. 
```C++
int main (void){
    int integer1;
    scanf("%d", &integer1)
}
```

2. `printf` is to print the value of the variable

`%d` is know as the **decimal integer**, where the `%` is a **conversion specifier**
`&` is the **address operator** (if you misuse this, it could trigger execution time error/segmentation fault/access violation) = Meaning user has no access right to that variable. Will discussed in Ch.7

e.g. 
```C++
int main (void){
    int sum; // variable definitions. Multiple vars be defined on the same line in 1 statement
    printf("%d", &sum)
}
```
## Good coding syntax tips
1. use `main` instead of `Main` (lowercase for function name)
2. Avoid starting strings w/ underscore `_` so it doesn't conflict with stan lib/compiler generated identifiers!
3. Camel cases are preferred in C (snake_cases can be used too)

# 2.4 Concept of memories
1. Destructive process: Replace old values, old value is completely wiped (e.g. store/ create var)
2. Non-destructive process: read value from memory location (e.g. calling value)

Always (I think):
Store var (destructive)-> call var (non-destructive)

# 2.5 Arithmetics in C
1. Common operators
    - `%` reminder operator
    - `*` multiplication operator
    - `=` Assignment Operator
    - Associativity: evaluated from right to left or vice versa = rearranging () while not affecting final result

# 2.6 Relational and Equality Operators

1. If-statements conditions
