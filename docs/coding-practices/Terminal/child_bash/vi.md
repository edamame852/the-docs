---
title: vi
layout: default
parent: Terminal (bash, zsh...) 
grand_parent: Coding Practices
---

# SNS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

# Vi 
- = Original Text Editor (Vi stands for Visual Editor)
- Created by Bill Joy in 1976 (late 70s)
- Vim (Vi IMproved aka `vim`), created by Bram Moolean in 1991 (early 90s) with improvements
    - Now has syntax highlighting
    - Allows search and replace with regrex
    - support for customization and plugins
    - avaliable on all platforms (Linux, Windows, MacOS, etc)

## Shortcuts!

### Line
1. Start of line vervus EOL / End of line : 
    - End of line (EOL)
        - `$` or `g_`: Jumps to (second to) last char of the current line
            - `$`: Jumps to TRUE ENDING of current line
            - `g_`: Jumps to last non-blank of current line
            - `A` : Jumps to EOL, End of char and append immediate by starting to insert
    - Start of line (SOL)   
    -  `0` or `^`: Jumps to first char of the current line
        - `0`: Jumps to TRUE BEGINNING of current line
        - `^`: Jumps to first non-blank of current line

    - TL;DR --> `0` < `^` < `g_` <`$` 
    - Or with a diagram 
        ```
            [ ] [ ] [ ] [ ] [d] [e] [f] [ ] [m] [y] [_] [f] [u] [n] [c] [ ] [ ] [ ]
                ↑               ↑                                           ↑     ↑
                0               ^                                           g_    $
                (Col 1)     (First Text)                                (Last Text) (Absolute End)
        ```

2. Under insert mode, if you wish to add to the last line:
    - Insert Mode --> `Ctrl + o` --> `$`
    - Note: `Ctrl+o` allows user to temp switch over to normal mode for one single command only


### File
3. Top of the file vs the end of the file

    - First line of file (you have 4 options, they're all doing the same thing)
        - `gg` = first line only
        - `gg0` = first line + FOL !!!
        - `:1` = first line only
        - `1G` with explicit number 1

    - Last line in file (you have 2 options)
        - `:$` last line only last entry
        - `G` last line only first entry
        - `G$` last line + EOL !! (Best optionGG$)

    - TL:DR --> `gg0` < `gg` < `G` < `G$`