---
title: Nobby Habits (31 of them)
layout: default
parent: C++
has_children: true
grand_parent: Coding Practices

---
## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---



# Things you should avoid when coding in C++!

## 1. Use global `using namespace std;`

```c++
// DON'T do this :(
#include xxx

void using_namespace_std() {
    using namespace std; //don't use std in scope
    string s = "hello, world";
    cout << s << endl;
}
```

```c++
// Do this :)
#include xxx
using namespace std;

void using_namespace_std() {
    string s = "hello, world";
    cout << s << endl;
}
```
TLDR:
- Please use `using namespace std;` on a GLOBAL level
- Avoid `using namespace std;` in header files, as it will force all your imports to read everything in uncessarily
- Try to import only the stds you need

```c++
// Do this :) EVEN BETTER!
#include xxx
using namespace std::string, std::cout, std::endl;

void using_namespace_std() {
    string s{"hello, world"};
    cout << s << endl;
}
```

## 2. `std::endl`

`std::endl` print a new line + flushes the buffer = taking more time
instead just use `\n` the new line character

```c++
// DON'T do this :(
#include xxx

void print_range(int start, int end) {
   for (auto i = start; i != end; ++i ) {
    std::cout << i << std::endl; // BAD
   }
}
```

```c++
// Do this :)
#include xxx

void print_range(int start, int end) {
   for (auto i = start; i != end; ++i ) {
    std::cout << i << '\n'; // GOOD
   }
}
```

# Basics

## `&` the Reference operator
` &data `: data is passed by reference

`&` gurantees the function to modify the object directly
- pass by reference benefit 1: Performence optimization due to no need to copy

`&data` is a reference to a `std::vector<int>` that cannot be modified inside the function. Passing by reference avoids copying the entire vector when the function is called, which can be more efficient, especially for large vectors

## `const` the const qualifier 
TLDR: ensure the function cannot change the elements inside the vector

## `auto` keyword
TLDR: to automatically deduce the type of variable
- Makes the function more generic
- Any type take model takes up is acceptable
- `auto` type inference benefit 1: Code is more flexible 
- `auto` type inference benefit 2: Code is cleaner 


## 3. use a range based for-loop (avoid for-loop by index)

```c++
// DON'T do this :(
#include xxx

// Additional variable i is used, but not really needed
void range_based_for_loop(const std::vector<int> &data, auto &model) {
   for (std::size_t i = 0; i < data.size(); ++i) {
    model.update(data[i]); // BAD, we don't care about idx here
   }
}
```

```c++
// DO this :)
#include xxx

// Iterates over the element without using index
void range_based_for_loop(const std::vector<int> &data, auto &model) {
   for (const auto &x: data) { // &x helps directly accessing original data or object to speed up manipulation
    model.update(x); // GOOD, no index = less room for error
   }
}
```

## 4. Use std pre-built algorithims!

```c++
// DON'T do this :(
#include xxx

void std_algos() {
   for (std::size_t i = 0; i < data.size(); ++i) {
    model.update(data[i]); // BAD, we don't care about idx here
   }
}