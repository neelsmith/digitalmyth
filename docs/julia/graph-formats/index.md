---
title: "Plain-text formats for graph structures"
parent: "Julia notes and review"
layout: page
nav_order: 5
has_children: true
---


# Plain-text formats for graph structures


## DOT format

**Summary**:

- the *graph* should have a string value for a name
- data are organized with one line per *edge*
- each line is formatted as two *nodes* joined by ` -- `
- edges may optionally be weighted by assigned a weight  value in brackets


**Example**:

```
graph "GRAPHNAME" {
	"name1" -- "name2" [weight = 5]
	"name1" -- "name3" [weight = 1]
}
```

## GML format

**Summary**:

- The *graph* should have an ID string and label
- each *node* is listed with an ID number, label and any other attributes you want
- each *edge* is listed with a *source* node and *target* node identified by their ID numbers, and any other attributes you want


**Example**:


```
graph [
	comment "Hand-crafted example of co-occurrence network"
	directed 0
	id socialnetdemo
	label "Example list of personal names"
	node [
		id 1
		label "Patroclus"
		count 1
	]
	node [
		id 2
		label "Sarpedon"
		count 1
	]
    edge [
		source 1
		target 2
		weight 4
	]
]
```

## Comparison of some key features


| Format | Supports weights on edges |  Supports counts on nodes | Distinguishes node IDs from labels |
| --- | --- | --- | ---|
| DOT | ✅ | ❌  | ❌ |
| GML | ✅ | ✅ | ✅ |