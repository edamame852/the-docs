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
{:.note}
> VERY IMPORTANT: `&var1` means the memory address of var1, since scanf needs to modify the actual variables so the exact location in memory MUST be known before hand
> Reading it doesn't require this operator.
> TLDR: `&` is for modifying/ destructive process, while it's not need for non-destructive ones

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

{:.warning}
> Non-fatal errors: Program still runs to completion with incorrect outputs
> Fatal errors: Divide by zero error, program crashes immediately

1. Common operators
    - `%` reminder operator
    - `*` multiplication operator
    - `=` Assignment Operator
    - Associativity: evaluated from right to left or vice versa = rearranging () while not affecting final result

# 2.6 Relational and Equality Operators

1. If-statements conditions (Only has 2 conditions: true or false)
    - Formed under equality operators and relational operators
    - True value: Non-zero value (in C)
    - false value: Zero value (in C)

2. Syntax error for operators
    - if you right `= =` instead of `==`

3. Types of operators
     - Relational
     - Equality
        - `=`
        - `!=`

4. Example of using if statements

```c++
int num1;
int num2;
scanf("%d %d", &num1, num2); // Modifying num1 and num2

if (num1 == num2) {
    printf("%d is equal to %d", num1, num2); // reading num1 and num2
}
```

5. Reserved Keywords
These words mean something special to the C complier.
These cannot be used as identifiers (aka variable names)

```c++
auto, do, goto, if, short, _Imaginary, _Generic, for, char, default, union, type, while, volatile

// More keywords added in C99 and C11 orz

```
# 2.7 Programming C securely

## Programming practices to prevent external attacks
1. Use `puts` instead of `printf` when printing strings

```c++

printf("Hello World \n") // NAH

printf("%s","Hello World\n") // BETTER, eliminating security vulnerabilities

puts("Hello World") // YAS, default already has \n at the end

```

Explanation: `printf` isn't insecure per se..but why ???? It didn't say wtf
More info later...

2. `printf_s` and `scanf_s` are introduced in C11 and will be used in Ch.3!!
