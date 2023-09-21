### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8bf9dbda-52ea-11ee-06b6-ab78a41a5a32
begin
	using PlutoUI, PlutoTeachingTools
	using GraphIO
	using GraphIO.DOT
	using ParserCombinator
	using Graphs
end

# ╔═╡ 6e878c17-29cc-45b3-9377-fc3abe4b2fe8
using Downloads

# ╔═╡ 0bbb8fc0-2f0e-487b-923d-fbe8b83f21cb
TableOfContents()

# ╔═╡ a3e27d8e-a70e-4b68-8442-a3e1888f4724
md"""# Pluto notebook 2: building a social network"""

# ╔═╡ 1dfb4eef-218b-4c42-a680-7a9c72f27a8d
md""" ## Before you start: authors
"""

# ╔═╡ 9f9bb13a-8863-434d-be1c-784e32ddaf08
team = ""

# ╔═╡ ec87021d-aa88-4df4-99c6-ec2b4e341638
if isempty(team)
	still_nothing(md"Assign to the variable `team` a single string with a list of all members of your group.")
end

# ╔═╡ 59518a6c-a2ac-42d0-999f-db2e50d049db
md"""> ## Overview of assignment
>
>This Pluto notebook will guide you through finding co-occurrences of named entities in English translations of Apollodorus and Hyginus.  We'll read a text that is segmented into canonically citable sections, and for each section, we'll pair up all the named entities we find in that section.
>
> You will:
>
> 1. select a text to analyze, and read the contents of the text from a URL
> 2. find *named entities* (proper nouns and adjectives) in the text
> 3. use nested for loops to find *pairings* of names
> 4. represent these pairings as a text string in the DOT format, a simple text format  used to represent graph structures 
> 5. write the results to a file, which you can use in the separate assignment to visualize these results with Gephi
"""

# ╔═╡ dc7dbc66-383f-4619-8fcf-277a3fb0708e
md"""## Reading a text source"""

# ╔═╡ 2960e7a8-8130-4b2f-bcb1-06eb0c21de74
md"""> **Note**: The following cell lets you select from a menu a URL for either a text of Hyginus or a text of Apollodorus, and assigns your choice to a variable named `text_url`.
"""

# ╔═╡ c2d98226-4efd-4e2c-8f58-e2debdf0afaf
md""">**Instructions**: You previously wrote a function that downloads a URL, and reads its contents into a single string.  For this notebook, you will need a similar function that downloads a file and reads its contents into a Vector of String values, one for each line in the source file.  The source files are organized with one paragraph-like section per line, so you'll have a Vector where each element is a paragraph-like unit of text.
>
> In the `readlines_url` function in the following cell, replace `nothing` with 
> Julia code to complete this task.
"""

# ╔═╡ 1c8ad350-fece-4237-bb14-2d4b58f64b8e
"""Download a URL, and use the Julia `readlines` function
to read its contents into a Vector of String values.
"""
function readlines_url(url)
	nothing
end

# ╔═╡ 41b6775e-0da2-4837-8a4f-4a1aa3b47ffd
tip(md"Notice how, as we did in our first assignment, the following cell checks for the possibility that the user hasn't selected a text yet. We don't want to try to using an empty string with our `readlines_url` function.")

# ╔═╡ 4197b0c4-4070-4afa-a68c-2734d5eec382
md"""## Finding named entities"""

# ╔═╡ 4ae5b5e3-15cb-4adf-9a82-43c00b1062d2
md""">**Instructions**: review your work on assignment 1. In that assignment, you found *unique* lists of words, then identified possible named entities in that list.
>
> Here, we want to consider *all* words in a single sectoin of text, then filter the word list to keep only those we think are named entities.
>

"""

# ╔═╡ 6ebbb8ea-7044-457d-94c2-e1efbe9d6360
md""" Start by mapping each passage of text in the Vector named `lines` to a list of the words in it. The result should be a Vector that has transformed each line of text into a list of words -- a Vector of Vectors!"""

# ╔═╡ af4bacdc-63b4-401d-8229-7f83417e36ee
wordlists = [] 

# ╔═╡ b0108f76-ae1b-4552-9f6b-09b2be3d3afe
md"""Next, we'll filter each wordlist to keep *only* those that are named entities.  Write a function named `uc_words` that takes a list of strings and filters it to keep only those that start with an uppercase character.

Recall from assignment 1 that we'll want to:

1. filter out punctuation
2. keep only uppercase words that do *not* also appear as lower case words

Let's set up an easy test.  We'll hand-type a short list, and pass it to our function.  If it's working correctly, it should filter the list to show only the words "Zeus" and "Hera".
"""

# ╔═╡ 6c203b8e-c022-4113-8974-eb2a885b10be
test_list = ["Zeus", "Hera", "husband", "wife"]

# ╔═╡ 91591eb7-a9d3-47a6-bd22-e1eec8af1509
md"""
In the function `uc_words`, replace `nothing` with Julia code to keep only words starting with an uppercase character.
"""

# ╔═╡ af943162-f0d3-4a45-977e-32661d7ba500
"""Filter a list of words to keep only those that begin with an upper-case character."""
function uc_words(list)
	nothing
end

# ╔═╡ 731e0924-793a-445b-9988-b97149e14548
uc_words(test_list)

# ╔═╡ a729576b-8048-4a45-bcc2-a76bb566b6ff
begin
	filteredwords = uc_words(test_list)
	if isnothing(filteredwords)
		still_missing(md"Replace `nothing` in the `uc_words` function with Julia code to filter a word list.")
	elseif ! (filteredwords isa Vector)
		keep_working(md"Your `uc_words` function  should produce a new Vector of String values, not $(typeof(wordlists)).")
			
	elseif length(filteredwords) != 2
		keep_working(md"Something's not right. Your function kept $(length(filteredwords)) words in our test but we expected 2.")
		
	else
		correct(md"Great! Your function read the test document correctly!")
	end
end

# ╔═╡ 7d02f9a4-0af7-42fb-9558-de2fc2238e75
md"""Now we're ready to put together the data we need: a list of all the upper-case words in each section.  The `uc_words` function is doing the work for us:  we're just mapping the filtered results for each section's list of words!"""

# ╔═╡ 23290f4c-5289-4bc8-8b38-6bce6a54007b
uc_wordlists = map(wordlist -> uc_words(wordlist),  wordlists)

# ╔═╡ 56b44689-7c55-4801-aa0f-dfebf3652370
TODO(md"Blow out these temp tests")

# ╔═╡ 2ea5061b-317a-41fd-af75-e628720f9343
function ucx(v)
	filter(s -> isuppercase(s[1]), v)
end

# ╔═╡ f69a3328-279f-47cb-8850-7a0a525dfe10
function cooccursx(v)
	results = []
	for wd in v
		for wd2 in v
			if wd != wd2
				push!(results, sort([wd, wd2]))
			end
		end
	end
	unique(results)
end

# ╔═╡ e8b1ce1d-2dc9-4413-8ef9-451470168bfb
"""Given a list of pair of linked nodes, compose a graph structure in DOT format."""
function dotformatx(pairlist)
	textlines = []
	push!(textlines, "graph SOCIALNETWORK {")
	for onepair in pairlist
		s = onepair[1] * " -- " * onepair[2]
		
		push!(textlines, s)
	end
	push!(textlines, "}")
	push!(textlines, "Type of ")
	join(textlines,"\n")
end

# ╔═╡ 8b6d7601-ffa5-4776-afdc-0ee592641196


# ╔═╡ 866ee948-290d-463b-a8bf-48079fcf6f4c
md""" ## Using `for` loops to find unique pairs"""

# ╔═╡ 05c3a217-beb6-4d70-b739-5ec8814dbf9a
md"""> **Instructions** 
> 
> For our social network analysis, we don't just want  a list of the names in each passage: we want to find every *pair* of names in that passage. 
>
> First we'll write a function we can use to get the cooccurrences in each section or chapter of the selected text.
"""

# ╔═╡ ed834e33-b811-43df-afdf-d11dba6ce05e
md"""### Find cooccurrences in each chapter"""

# ╔═╡ f02fe051-76c2-46b9-a603-c52c155557c6
md"""
In the following cell, replace `nothing` with Julia code to find co-occuring items in a list.  You can use *nested `for` loops* to cycle through every item in a list (the outer loop), and for each item, cycle again through each item in the list (the inner loop) to find all possible pairs.

Consult [these review notes](https://neelsmith.github.io/digitalmyth/julia/julia-loops-dictionaries.html) for a more detailed introduction to how to solve this problem.

Remember that once you `cooccurs` function has collected pairs of names, you'll want to use Julia's `unique` function to remove any duplicates.
"""

# ╔═╡ 95d7a55c-58f0-414e-ac53-aecb23183efc
function cooccurs(v)
	nothing
end

# ╔═╡ 1a107f4e-e064-415b-b084-ff29d370d26c
md"""We'll create a tiny test:"""

# ╔═╡ d13ad822-f846-45a6-b31d-eed8cf82282b
gods = ["Apollo", "Athena", "Hera", "Zeus"]

# ╔═╡ 2ca34534-c537-478e-9d1b-b27267b68552
md"""A list of three items should generate six possible pairings.  """

# ╔═╡ a6bd5e8a-76fe-4e61-96ae-00ac5dc945c6
cooccurs(gods)

# ╔═╡ d73a840c-8dc0-4c5e-bfc6-c9bf14c48ced
if isnothing(cooccurs(gods))
	still_missing(md"Replace `nothing` in the `cooccurs` function body with Julia code to find cooccuring pairs.")
elseif length(cooccurs(gods)) != 6
	keep_working(md"Your `cooccurs` function should have found 6 pairs. Did you remember to `unique` your results?")
else
	correct(md"Awesome -- looks like you've got a working `cooccurs` function!")
end

# ╔═╡ 1e3509a5-cb14-4061-b121-17008abfdfd0
md"""Now we can find cooccurrences of names in every chapter of the text we've selected with a single use of `map`:"""

# ╔═╡ d4e3d419-ff16-453b-98b0-a641c3cf45ca
pairsbychapter = map(wdlist -> cooccurs(wdlist), uc_wordlists)

# ╔═╡ e640f5f7-4e9b-470a-af6b-0c7e6142ef55
md"""### Finding a list of unique pairs"""

# ╔═╡ 1afd3db0-6b65-4a33-8309-b768df2dc8a1
md"""Currently, we have every pairing listed in separate lists by chapter: we'd like to *flatten* all those sublists out to get a single, big list of pairs we can count.

Julia has a function to do just that.  `Iterators.flatten` creates a structure you can use with, for example, `for` loops to visit every element in the nested lists. You can collect all the elements at once with the Julia `collect` function. The following cell gathers together all the elements in the nested lists and assigns them to a variable named `allpairs`.


"""

# ╔═╡ 6400635c-19a6-4afe-8e0d-8a8a8d29429e
allpairs = pairsbychapter |> Iterators.flatten |> collect

# ╔═╡ 3b319b02-33a5-4beb-a965-b4a24ff2e00d
md"""This is a unique list of cooccurring names: that's a social network!"""

# ╔═╡ 6b029590-c622-4475-8d7b-b51fd6a03987
md"""## Formatting a DOT graph """

# ╔═╡ 375ad838-117f-40b2-a06e-e51f556c2e63
md"""
> **Instructions** Our final step is to write our social network to a plain-text file you can save on your computer. For this exercise, we'll use the DOT format.  
"""

# ╔═╡ 572346fc-8ff7-4f4f-9d4b-554a7856a1db
tip(md"""Review [these notes on the DOT format](https://neelsmith.github.io/digitalmyth/julia/graph-formats/).""")

# ╔═╡ d5a42b8e-4517-435d-9bbc-40a24ef50fd5
md"""We'll write a function that takes accepts a list of associated pairs as its only parameter.  The outline here starts you off: it defines an empty Vector named `textlines`, and pushes onto it the DOT syntax for beginning and ending a graph structure.  *In between* those two lines, you should write a `for` loop that formats every element in DOT syntax.

"""

# ╔═╡ a48432d2-67c6-4ef0-882d-0c1c20e356fb
md"""Here's a miniature version of what you want to do. You'll be working with lists that have a pair of names, like this."""

# ╔═╡ b6265311-e2f1-4e8d-bb09-29edad4690fd
onepair = ["A", "B"]

# ╔═╡ ca9db6a6-4fee-4544-b175-38ffb7cc6426
md"""You can use Julia's `*` operator to join multiple values together into one string.  The result is one line in DOT syntax for a pair or nodes joined by an edge."""

# ╔═╡ eef41d25-fa0d-46a5-a4cb-8c397bcaf9ab
onepair[1] * " -- " * onepair[2]

# ╔═╡ c6424d9c-46e7-4f0a-a247-6a0bb6dc9ec9
"""Given a list of pair of linked nodes, compose a graph structure in DOT format."""
function dotformat(pairlist)
	textlines = []
	push!(textlines, "graph SOCIALNETWORK {")
	# add a for loop here that pushes a data line for each entry in `pairlist` onto the `textlines` Vector
	
	push!(textlines, "}")
	join(textlines,"\n")
end

# ╔═╡ 9a456be8-8e77-4672-b60b-72d725ef367c
dot_output = dotformat(allpairs)

# ╔═╡ 21bd7eac-207e-44b0-9f23-7bf5b22b149a
md"""### Saving the results to a file"""

# ╔═╡ 38bd3746-76dd-4fb1-b772-575d6d957bb3
md"""When you have completed the rest of your assignment, uncomment the three lines in the following cell. This will write `dot_output` to a file named **assignment2.dot** in the directory where you're running Pluto: **$(pwd())**.

"""

# ╔═╡ bc49e1a9-1575-4934-a570-cb2e724e8299
#open(dotfile, "w") do io
#	write(io, dot_output)
# end

# ╔═╡ f46c4a94-2721-4650-bf74-43c7cff9d00c
tip(md"""Your file will be named **assignment2.dot**, and will be saved in this folder on your computer:  **$(pwd())**
""")

# ╔═╡ 027345af-2a40-41ff-976e-7e87190a775d
html"""
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ a464db01-1cf8-4934-83a3-f6d946abb79b
md"""> #### *Stuff you don't need to look at to complete this assignment*"""

# ╔═╡ 6f41d79f-9ee4-42cb-b76c-4e0ec73a0db3
hyginus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/grant-hyginus.txt"

# ╔═╡ 4701b072-b304-4c70-8daa-6c12c7ed3097
apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/apollodorus-topos.txt"

# ╔═╡ 0497ded3-5790-4de0-b715-6e7999242379
begin
	teststringreading = readlines_url(apollodorus_url)

	if isnothing(teststringreading)
		still_missing(md"Make the `readlines_url` function return some value.")
	elseif ! (teststringreading isa Vector{String})
		keep_working(md"The value you return from `readlines_url` should be a Vector of String values, not $(typeof(teststringreading)).")
			
	elseif length(teststringreading) != 210
		keep_working(md"Something's not right. Instead of reading 210 sections from the test document, your function read $(length(teststringreading)).")
		
	else
		correct(md"Great! Your function read the test document correctly!")
	end
end

# ╔═╡ 9edef571-122b-4f10-88db-3e09261a7001
linesx = Downloads.download(apollodorus_url) |> readlines


# ╔═╡ 65b82ca6-ff9a-4695-9d31-74b1e56be8cc
wordsx = map(l -> ucx(split(l)), linesx)

# ╔═╡ 634bec64-eea0-49a6-ad5f-96fdfe55e371
pairsbychapterx = map(wdlist -> cooccursx(wdlist), wordsx)

# ╔═╡ d2afdda0-9b15-46b8-b086-9ab2b0b0f171
allpairsx = pairsbychapterx |> Iterators.flatten |> collect

# ╔═╡ 0b0072b1-2aca-4665-9ef4-b67a59f24cb1
dot_outputx = dotformatx(allpairsx)

# ╔═╡ aa541586-f323-430d-9730-6009e7ab8e5e
menu = ["" => "Choose a text", hyginus_url => "Hyginus", apollodorus_url => "Apollodorus"]

# ╔═╡ 8f53048d-36fd-4fdb-bc56-2f9d6d3072b6
@bind text_url Select(menu)

# ╔═╡ 1121c7bb-f5aa-44a7-92b0-c4b74c114d39
if isempty(text_url)
	nothing
else
	md"*Using URL for text source:* [$(text_url)]($(text_url))"
end

# ╔═╡ 5fa8ca5f-b112-4557-8cfb-3410da57ae6c
lines = if isempty(text_url)
	[]
else
	readlines_url(text_url)
end

# ╔═╡ 1293ed8c-4d0a-45bc-842f-a9647ffa47fb
begin
	#teststringreading = readlines_url(apollodorus_url)

	if isempty(wordlists)
		still_missing(md"Assign a value to `wordlists` by applying the `map` function to `lines`.")
	elseif ! (wordlists isa Vector)
		keep_working(md"Your `map` expression should produce a new Vector of String values, not $(typeof(wordlists)).")
			
	elseif length(wordlists) != 210 && length(wordlists) != 789
		keep_working(md"Something's not right. Your function read $(length(wordlists)) text sections but that's the wrong size for $(text_url).")
		
	else
		correct(md"Great! Your function read the test document correctly!")
	end
end

# ╔═╡ 2d36247d-494d-4f48-8937-bc0c5525890f
dotfile = joinpath(pwd(), "assignment2.dot")

# ╔═╡ a78e1109-e568-4772-b3e6-d1095853c0c7
if isfile(dotfile)
	try
		g = loadgraph(dotfile, "SOCIALNETWORK", DOTFormat()) 
		correct(md"Terrific -- looks like your output file is a valid DOT file!")
	catch e
		keep_working(md"Something's wrong with your file: I couldn't parse it as a valid DOT file.")
	end
else
	still_missing(md"If you have completed the rest of the assignment, go ahead and uncomment the three lines in the cell above!")

end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
GraphIO = "aa1b3936-2fda-51b9-ab35-c553d3a640a2"
Graphs = "86223c79-3864-5bf0-83f7-82e725a168b6"
ParserCombinator = "fae87a5f-d1ad-5cf0-8f61-c941e1580b46"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
GraphIO = "~0.7.0"
Graphs = "~1.8.0"
ParserCombinator = "~2.1.1"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "22d025553860255aeabe37a47acddf10900cc139"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AutoHashEquals]]
git-tree-sha1 = "45bb6705d93be619b81451bb2006b7ee5d4e4453"
uuid = "15f4f7f2-30c1-5605-9d31-71845cf9641f"
version = "0.2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "e460f044ca8b99be31d35fe54fc33a5c33dd8ed7"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.9.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.GraphIO]]
deps = ["DelimitedFiles", "Graphs", "Requires", "SimpleTraits"]
git-tree-sha1 = "bc5b7609e9f4583f303a0ab2a7016ea318464da0"
uuid = "aa1b3936-2fda-51b9-ab35-c553d3a640a2"
version = "0.7.0"

    [deps.GraphIO.extensions]
    GraphIODOTExt = "ParserCombinator"
    GraphIOGEXFExt = "EzXML"
    GraphIOGMLExt = "ParserCombinator"
    GraphIOGraphMLExt = "EzXML"
    GraphIOLGCompressedExt = "CodecZlib"

    [deps.GraphIO.weakdeps]
    CodecZlib = "944b1d66-785c-5afd-91f1-9de20f533193"
    EzXML = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
    ParserCombinator = "fae87a5f-d1ad-5cf0-8f61-c941e1580b46"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "60168780555f3e663c536500aa790b6368adc02a"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.3.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.ParserCombinator]]
deps = ["AutoHashEquals", "Printf"]
git-tree-sha1 = "3a0e65d9a73e3bb6ed28017760a1664423d7e37c"
uuid = "fae87a5f-d1ad-5cf0-8f61-c941e1580b46"
version = "2.1.1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoHooks]]
deps = ["InteractiveUtils", "Markdown", "UUIDs"]
git-tree-sha1 = "072cdf20c9b0507fdd977d7d246d90030609674b"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0774"
version = "0.0.5"

[[deps.PlutoLinks]]
deps = ["FileWatching", "InteractiveUtils", "Markdown", "PlutoHooks", "Revise", "UUIDs"]
git-tree-sha1 = "8f5fa7056e6dcfb23ac5211de38e6c03f6367794"
uuid = "0ff47ea0-7a50-410d-8455-4348d5de0420"
version = "0.1.6"

[[deps.PlutoTeachingTools]]
deps = ["Downloads", "HypertextLiteral", "LaTeXStrings", "Latexify", "Markdown", "PlutoLinks", "PlutoUI", "Random"]
git-tree-sha1 = "542de5acb35585afcf202a6d3361b430bc1c3fbd"
uuid = "661c6b06-c737-4d37-b85c-46df65de6f69"
version = "0.2.13"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "7364d5f608f3492a4352ab1d40b3916955dc6aec"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.5"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "51621cca8651d9e334a659443a74ce50a3b6dfab"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.3"
weakdeps = ["Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "b7a5e99f24892b6824a954199a45e9ffcc1c70f0"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─8bf9dbda-52ea-11ee-06b6-ab78a41a5a32
# ╟─0bbb8fc0-2f0e-487b-923d-fbe8b83f21cb
# ╟─a3e27d8e-a70e-4b68-8442-a3e1888f4724
# ╟─1dfb4eef-218b-4c42-a680-7a9c72f27a8d
# ╠═9f9bb13a-8863-434d-be1c-784e32ddaf08
# ╟─ec87021d-aa88-4df4-99c6-ec2b4e341638
# ╟─59518a6c-a2ac-42d0-999f-db2e50d049db
# ╟─dc7dbc66-383f-4619-8fcf-277a3fb0708e
# ╟─2960e7a8-8130-4b2f-bcb1-06eb0c21de74
# ╟─8f53048d-36fd-4fdb-bc56-2f9d6d3072b6
# ╟─1121c7bb-f5aa-44a7-92b0-c4b74c114d39
# ╟─c2d98226-4efd-4e2c-8f58-e2debdf0afaf
# ╠═1c8ad350-fece-4237-bb14-2d4b58f64b8e
# ╠═6e878c17-29cc-45b3-9377-fc3abe4b2fe8
# ╟─0497ded3-5790-4de0-b715-6e7999242379
# ╟─41b6775e-0da2-4837-8a4f-4a1aa3b47ffd
# ╠═5fa8ca5f-b112-4557-8cfb-3410da57ae6c
# ╟─4197b0c4-4070-4afa-a68c-2734d5eec382
# ╟─4ae5b5e3-15cb-4adf-9a82-43c00b1062d2
# ╟─6ebbb8ea-7044-457d-94c2-e1efbe9d6360
# ╠═af4bacdc-63b4-401d-8229-7f83417e36ee
# ╟─1293ed8c-4d0a-45bc-842f-a9647ffa47fb
# ╟─b0108f76-ae1b-4552-9f6b-09b2be3d3afe
# ╠═6c203b8e-c022-4113-8974-eb2a885b10be
# ╠═731e0924-793a-445b-9988-b97149e14548
# ╟─91591eb7-a9d3-47a6-bd22-e1eec8af1509
# ╠═af943162-f0d3-4a45-977e-32661d7ba500
# ╠═a729576b-8048-4a45-bcc2-a76bb566b6ff
# ╟─7d02f9a4-0af7-42fb-9558-de2fc2238e75
# ╠═23290f4c-5289-4bc8-8b38-6bce6a54007b
# ╠═56b44689-7c55-4801-aa0f-dfebf3652370
# ╠═9edef571-122b-4f10-88db-3e09261a7001
# ╠═2ea5061b-317a-41fd-af75-e628720f9343
# ╠═65b82ca6-ff9a-4695-9d31-74b1e56be8cc
# ╠═f69a3328-279f-47cb-8850-7a0a525dfe10
# ╠═634bec64-eea0-49a6-ad5f-96fdfe55e371
# ╠═d2afdda0-9b15-46b8-b086-9ab2b0b0f171
# ╠═e8b1ce1d-2dc9-4413-8ef9-451470168bfb
# ╠═0b0072b1-2aca-4665-9ef4-b67a59f24cb1
# ╠═8b6d7601-ffa5-4776-afdc-0ee592641196
# ╟─866ee948-290d-463b-a8bf-48079fcf6f4c
# ╟─05c3a217-beb6-4d70-b739-5ec8814dbf9a
# ╟─ed834e33-b811-43df-afdf-d11dba6ce05e
# ╟─f02fe051-76c2-46b9-a603-c52c155557c6
# ╠═95d7a55c-58f0-414e-ac53-aecb23183efc
# ╟─1a107f4e-e064-415b-b084-ff29d370d26c
# ╠═d13ad822-f846-45a6-b31d-eed8cf82282b
# ╟─2ca34534-c537-478e-9d1b-b27267b68552
# ╠═a6bd5e8a-76fe-4e61-96ae-00ac5dc945c6
# ╠═d73a840c-8dc0-4c5e-bfc6-c9bf14c48ced
# ╟─1e3509a5-cb14-4061-b121-17008abfdfd0
# ╠═d4e3d419-ff16-453b-98b0-a641c3cf45ca
# ╟─e640f5f7-4e9b-470a-af6b-0c7e6142ef55
# ╟─1afd3db0-6b65-4a33-8309-b768df2dc8a1
# ╠═6400635c-19a6-4afe-8e0d-8a8a8d29429e
# ╟─3b319b02-33a5-4beb-a965-b4a24ff2e00d
# ╟─6b029590-c622-4475-8d7b-b51fd6a03987
# ╟─375ad838-117f-40b2-a06e-e51f556c2e63
# ╟─572346fc-8ff7-4f4f-9d4b-554a7856a1db
# ╟─d5a42b8e-4517-435d-9bbc-40a24ef50fd5
# ╟─a48432d2-67c6-4ef0-882d-0c1c20e356fb
# ╠═b6265311-e2f1-4e8d-bb09-29edad4690fd
# ╟─ca9db6a6-4fee-4544-b175-38ffb7cc6426
# ╠═eef41d25-fa0d-46a5-a4cb-8c397bcaf9ab
# ╠═c6424d9c-46e7-4f0a-a247-6a0bb6dc9ec9
# ╠═9a456be8-8e77-4672-b60b-72d725ef367c
# ╟─21bd7eac-207e-44b0-9f23-7bf5b22b149a
# ╟─38bd3746-76dd-4fb1-b772-575d6d957bb3
# ╠═bc49e1a9-1575-4934-a570-cb2e724e8299
# ╟─a78e1109-e568-4772-b3e6-d1095853c0c7
# ╟─f46c4a94-2721-4650-bf74-43c7cff9d00c
# ╟─027345af-2a40-41ff-976e-7e87190a775d
# ╟─a464db01-1cf8-4934-83a3-f6d946abb79b
# ╟─6f41d79f-9ee4-42cb-b76c-4e0ec73a0db3
# ╟─4701b072-b304-4c70-8daa-6c12c7ed3097
# ╟─aa541586-f323-430d-9730-6009e7ab8e5e
# ╠═2d36247d-494d-4f48-8937-bc0c5525890f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
