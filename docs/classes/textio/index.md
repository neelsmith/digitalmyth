---
layout: page
title: "Reading and writing structured text"
parent: "Schedule"
nav_order: 8
---

# Reading and writing structured text


## Background

Now that we've seen some basics of working with collections of data in Julia, we'll consider how to read and write data sets we create so that we can save and reuse them.

We'll emphasize using *structured, plain-text formats* that a human being can inspect with a text editor and readily interpret.



## Class preparation and written assignment

Before class, read through ["collections of data"](../../julia/julia-collections-of-data.html) in Julia. Focus on the parts we covered in class. 

Try the following excercises in Julia.  You may work on them individually, but it would be even better if you could try them with your project team, since you will be able to reuse some of this work in your first assignments.

You may work in the Julia terminal, in VS Code, or in a Pluto notebook, but *save* the results of these exercises on your computer, and bring them to class.

1. Write a function that reads the contents of a URL and returns a String value.
2. Write a function that accepts a String value as its parameter, and returns a sorted list of unique words in the String.
3. Write a function that *filters* a list of strings, and keeps only strings that start with a capital letter.


## Overview of what we'll do in class

- delimited text formats
- splitting columns on a delimiter
- joining elements of a vector into a string
- writing textfiles
- `read` vs `readln` in Julia