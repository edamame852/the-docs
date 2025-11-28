---
title: vi
layout: default
parent: Terminal 
grand_parent: Coding Practices
---

# SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# VI
- = Text Editor

## Shortcuts!
1. Start of line vervus EOL / End of line : 
    - `$` or `g_`: Jumps to last char of the current line
        - `$`: Jumps to TRUE ENDING of current line
        - `g_`: Jumps to last non-blank of current line
        
    -  `0` or `^`: Jumps to first char of the current line
        - `0`: Jumps to TRUE BEGINNING of current line
        - `^`: Jumps to first non-blank of current line

    - TL;DR --> `0` < `^` < `g_` <`$` 

2. Under insert mode, if you wish to add to the last line:
    - Insert Mode --> `Ctrl + o` --> `$`
    - Note: `Ctrl+o` allows user to temp switch over to normal mode for one single command only

3. Top of the file vs the end of the file

    - First line of file (you have 3 options)
        - `gg` = first line only
        - `gg0` = first line + FOL !!!
        - `:1`
        - `1G` with explicit number 1

    - Last line in file (you have 2 options)
        - `:$` last line only
        - `G` last line only
            - These 2 are equivalent: `:$` = `G`
        - `G$` last line + EOL !! (Best optionGG$)

    - TL:DR --> `gg0` < `gg` < `G` < `G$`