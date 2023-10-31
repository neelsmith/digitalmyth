---
layout: page
title: "Code sprint"
parent: "Schedule"
nav_order: 10
---


## Try one of these!

You've seen examples of the following:

- [comparing sets](../../julia/extending/compare-sets.html)
- using [optional parameters](../../julia/extending/optional-parameters.html) in functions
- measuring difference between two strings [with edit distance](../../julia/extending/fuzzy-matching.html)
- [reading and writing local files](../../julia/extending/fileio.html)

Now apply one or more of those new techniques by trying one of the  following exercise.


### Near matches: find similar names in Apollodorus and Hyginus


- Step 1. from the following two URLs, download a list of names generated from texts of Apollodorus and Hyginus using the algorithm you implemented in your first assignment, and read the contents into a Vector of names: 
    - names from [Apollodorus](https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/apollodorus_names.txt) 
    - names from [Hyginus](https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/hyginus_names.txt). 
- Step 2. Find every name in Apollodorus that scores as >= 85% similar to a name in Hyginus.
- (Optional) step 3. Find the set of names in Apollodorus that do *not* appear in Hyginus.
- (Optional) step 4. Write the results to a local file.
- (Optional) step 5. Write a single function that takes two lists, and writes to a file the entries in the first list that do not appear in the second list.  
- (Optional) step 6.  Modify the function you wrote in step 5 to allow the user to specify a name for the output file in an optional parameter; otherwise, write the results to a file named `output.txt` in the current directory.
- (Optional) step 7. Modify the function you wrote in step 6 to return the full path to the file where results were written.



