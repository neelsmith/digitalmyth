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

# ╔═╡ f6bc3e32-4b5a-11ee-06ae-0fbebdca7dfd
begin
	using PlutoUI
	using PlutoTeachingTools
end

# ╔═╡ 9978b453-2abb-40d7-8152-37e0919b353e
using Downloads

# ╔═╡ 6bf51ab9-dee0-4563-9a88-94fb70f14c2e
TableOfContents()

# ╔═╡ c35a93b3-cccd-49aa-8ebe-a0ec27fdea52
md"""
# Pluto notebook 1: identifying named entities
"""

# ╔═╡ 565bd719-468b-4d1b-bfbb-2411e3cab06f
md""" ## Before you start: authors
"""

# ╔═╡ 6f2fb7a1-da48-4099-867e-7f0cf8fe43e6
team = ""

# ╔═╡ 52c1724d-1c53-4ba1-bde6-c3eca9825703
if isempty(team)
	still_nothing(md"Assign to the variable `team` a single string with a list of all members of your group.")
end

# ╔═╡ cc5deeee-42ff-401c-acb5-5458eb4b9fe2
md"""
> ## Overview of assignment
>
> This Pluto notebook will guide you through identifying named entities in English translations of Apollodorus or Hyginus. (See [assignment on course web site](https://neelsmith.github.io/digitalmyth/assignments/nb1/)).
>
> You will:
>
> 1. select a text to analyze
> 2. read the contents of the text from a URL
> 3. tokenize the file
> 4. filter the list of tokens to include only named entities
> 5. write the results to a file on your computer
>
> When your team has completed the notebook, you should:
>
> 1. save the notebook to your computer
> 2. all team members should then add a copy of the notebook to their folder in the course Google drive
> 


"""

# ╔═╡ a9f68169-d603-499a-b36d-1e445a7e360f
md"""## Selecting a text


"""

# ╔═╡ a2d34e4a-d7e0-4ca8-9b6c-a4c67cac337e
md"""
> **Instructions**:  The first task, selecting a text to analyze from a menu, has been provided for you!  The following cell uses a widget that gives users a menu of choices, and returns a value.  In this case, the value that the user chooses is assigned to a variable named `text_url`.  Try different selections from the menu, and observe in the following cell what happens to the value of the `text_url` variable.
"""

# ╔═╡ 0c187725-1b0d-4b2f-97f6-6839c73bad03
md"""`isempty` is a Julia function that takes one parameter (or argument): a string value.  Observe how its result changes when you make different choices from the menu and change the value of the `text_url` variable.
"""

# ╔═╡ 9ae5f7f5-9099-4e47-a47c-854cbf68b555
md"""## Read the contents of the text from a URL"""

# ╔═╡ a0215564-e763-43ce-ad67-f24296dd0976
md"""
> **Instructions**: Our next text is to download a text from the internet, and read its contents.
>
> In [these class notes](https://neelsmith.github.io/digitalmyth/julia/julia-collections-of-data.html), review the section labelled "Downloading from the internet", and complete the next section of this notebook.
"""

# ╔═╡ 98e28be6-27af-4b50-951e-8cf6ccce8e1a
md"""Recall that we'll need to use the built-in `Downloads` package."""

# ╔═╡ 43be0af1-ca53-4fa9-a99c-b15a62b901a8
md"""We're next going write a function that takes one parameter (or argument): a string value giving the URL of a file to download.  We want the function to:

- download the file to your computer
- read the downloaded contents with Julia's `read` function
- convert the content you read into a single String

"""

# ╔═╡ e3807564-23d4-4a7b-9cda-8c28bb23200b
md"""Before you begin writing, however, we should define a test: how can we be sure our function works?

I've manually created a test file that has exactly 18 characters in it. You can use it to see if your function reads the data correctly. The result should:

1. be a String type of object
2. be 18 characters long

Here's the URL for the test file:
"""

# ╔═╡ d63f35fe-a318-4100-8544-ec699fec3a49
testurl = "https://raw.githubusercontent.com/neelsmith/digitalmyth/main/texts/test_dl.txt"

# ╔═╡ 07e10060-0c17-4470-a56f-667b8f14b8e1
md"""The next 2 cells define our tests."""

# ╔═╡ f17add47-ca31-4a8e-9e71-ace4c1166760
"""Download the contents of `url` and read it as a string value."""
function read_url(url)
	# Make this function do something!
	nothing
end

# ╔═╡ 87ccb60d-a7fa-4537-8fc3-62706e426b98
read_url(testurl) isa String

# ╔═╡ 77d85986-5e0e-4b0d-a833-a602ea6a1c91
if read_url(testurl) isa String
	length(read_url(testurl))
else
	md"Wait! I didn't get a String value from `read_url`!"
end

# ╔═╡ 4be85ad4-51f3-4933-8534-90d2c3c9e7cc
begin

	teststringreading = read_url(testurl)

	if isnothing(teststringreading)
		still_missing(md"Make the `read_url` function return some value.")
	elseif ! (teststringreading isa String)
		keep_working(md"The value you return from `read_url` should be a string, not $(typeof(teststringreading)).")
			
	elseif length(teststringreading) != 18
		keep_working(md"Something's not right. Instead of reading 18 characters from the test document, your function read $(length(teststringreading)).")
		
	else
		correct(md"Great! Your function read the test document correctly!")
	end
end

# ╔═╡ 21c61c62-9598-4753-83cb-7059dff13cb8
md"""Let's go ahead and use our function with the URL the user selects from the menu.  We'll read the contents of the URL, and assign it to a variable."""

# ╔═╡ 4cd51841-e072-4976-af88-24dbb7feba69
tip(md"Notice how the next cell checks for the possibility that the user hasn't selected a text yet. We don't want to try to using an empty string with our `read_url` function.")

# ╔═╡ 777c86d6-0194-4037-824a-f5c38ac5f62f
md"""## Tokenizing the file"""

# ╔═╡ 0f464472-a457-4385-9c3f-cbe56a3e37ba
md"""
> **Instructions**: Now we should have the contents of the text in the variable `text_contents`.  We will write a function `wordlist` that splits a string into a list of words, and sorts the list.
>
> First review the notes on ["nouns and verbs" of the Julia language](https://neelsmith.github.io/digitalmyth/julia/julia-nouns-verbs.html), or on [working with collections of data in Julia](https://neelsmith.github.io/digitalmyth/julia/julia-collections-of-data.html) to find a good way to implement this function.
>
"""

# ╔═╡ 979c8c8f-aaf3-4ea5-abc7-bba46f89f3aa
md"""Again, let's define a test. Let's try our function out on a short string where we can easily figure the desired result."""

# ╔═╡ 9ab0b3dd-9bf1-4f3d-8b16-6457e4a6da50
test_input = "Now is the time."

# ╔═╡ a8cf9868-941d-44bb-97ac-2d5efc7cb5c4
md"""Does the list here match what you want?"""

# ╔═╡ 94cb21fd-8619-436d-a09a-344bf5cfbdd3
"Break up a String `s` into a list of words, and sort the list."
function wordlist(s)
	nothing
end

# ╔═╡ 43be1c9c-2a90-4c14-9d33-39a58ecc0beb
wordlist(test_input)

# ╔═╡ feffe07b-a5da-466c-a288-fe2de72c7c01
md"""
Now we can apply your function to the text contents we previously read.
"""

# ╔═╡ f514901d-5f69-464f-9e5a-eafbd8b3ecce
md"""## Find named entities in a list"""

# ╔═╡ 9fbbf32e-1672-4061-ad16-899b96892b2b
md"""
> **Instructions**: We want to select from the word list *only* the words that are probably named entities. We'll choose words that
>
> 1. start with an uppercase character
> 2. do not appear in the word list in lowercase form
>
"""

# ╔═╡ ba2146e6-8e7d-455b-bbc9-0eb101ea2b4e
md"""We'll need two Julia functions: `isuppercase` is a boolean function that is true when a character is upper case. Remember that we use regular list indexes to refer to characters in a string."""

# ╔═╡ fdd8adbb-0861-4e05-9284-7815ed1a0600
name = "Zeus"

# ╔═╡ 13dd752c-7eaa-4ccd-9cd5-044383bde9ae
not_a_name = "father of the gods"

# ╔═╡ 34c080ed-7fd4-4477-bbea-0a8d12834f47
isuppercase(not_a_name[1])

# ╔═╡ 52eda228-be5b-4825-a22c-4c232829b8b6
md"""We'll also need the function `lowercase`: this converts a string to all lower-case letters.
"""

# ╔═╡ cc023f06-030f-4773-8598-4796d4cc1340
lowercase(name)

# ╔═╡ 35a78d3a-531c-418b-b555-e751692d67b7
md"""Our function `named_entities` will need first to filter a word list and select only those items that start with an uppercase letter."""

# ╔═╡ 959aef77-147a-4d71-b6db-4a5248b21610
md"""If you save those results, you can then filter it further by testing to see if we *also* have a lower-case only version of the word in our list.  That's easy to do with Julia's `in` function which is true if an item is in a list. Here's an example:"""

# ╔═╡ 646593a9-30cb-42a5-8a33-ffbbc9b1b5b7
olympians = ["Apollo", "Athena", "Zeus", "Hera"]

# ╔═╡ 9c64e61a-d2fe-4371-b0a1-06940f48c462
name in olympians

# ╔═╡ 29296cab-24d9-4146-8343-5b7de8acd002
function named_entities(wordsvector)
	nothing
end

# ╔═╡ 37b05771-0a0e-490b-a0e3-65288fc3c5b2
begin
	
	testnelist = named_entities(["Zeus", "Father", "Gods", "father", "of", "the", "gods"])

	if isnothing(testnelist)
		still_missing(md"Make the function  `named_entities` return some value.")
	
	elseif  isempty(testnelist)
		keep_working(md"Your function returned an empty list.")
			
	elseif testnelist == ["Zeus"]
		correct(md"Great! Your function selected named entiteis correctly from a test list.")
	end
end

# ╔═╡ d61f1a42-2fcc-46fe-9df7-40aeffa1373d
md"""## Write the list of named entities to a file"""

# ╔═╡ 07ec05a7-d71d-48d5-ade6-dcd90efa27c0
md"""
> **Instructions**: Finally, we'll save our results to a file, using the `write` function.  You'll need to define a file name, and convert your list of named entities to a single string.
>
"""

# ╔═╡ 8a55750c-6b99-4d37-9b59-8ab9b72a6f8f
md"""Define a name for the file where you'll write your results."""

# ╔═╡ 15eff456-bb73-4042-bef3-ab17e98fc8b0
fname = "" # e.g., "Hyginus-named-entities.txt"? "Apollodorus-names.txt" ?

# ╔═╡ 2216e17c-bd94-4f6a-abdb-da4e8e8cc7f7
md"""You can use Julia's built-in `join` function to make a single string out of a list of objects.  See if you can figure out how it works from these two examples."""
	


# ╔═╡ bf36a60e-9dc0-4fa0-bec0-91f3716acb00
join(["a","b","c"])

# ╔═╡ 2614a412-6bf8-4e34-8e83-d92e55108e2f
join(["a","b","c"], ":")

# ╔═╡ 8ee4dc67-1332-4692-99df-2b10b6e845b4
md"""In the following cell, replace `nothing` with an invocation of the `join` function.  Your first parameter should be your list of named entities.  To format your list one name per line, make the second parameter the new line character, which you can write in Julia as `"\n"`."""

# ╔═╡ fca20741-83fc-4292-94b8-81f7ee78241f
result_string = nothing # 

# ╔═╡ d43599f5-fcb7-4001-bf86-cde36380ce5f
md"""When you have your results in one string, uncomment the `write` function in the following cell."""

# ╔═╡ dcb05b4f-3f4a-4355-a610-54cca730da3b
#open(fname, "w") do io
	#write(fname, result_string)
#end

# ╔═╡ 9150ac0b-b71e-40d4-8b5b-4fcd9c4d2228
md"""## Improvements?"""

# ╔═╡ d93fc631-0fe8-4d5f-9a3c-9a3fed8d82b9
tip(md"""Reminder that at  some point, everyone will work on an individual extension of or improvement to one of your required assignments.  Can you think of any ways that you could improve this project?

Feel free to speak with me if you have ideas!
""")

# ╔═╡ 25b9a85f-3af4-4c90-a504-fc0432a89d3d
html"""
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ e6b9acf9-1894-4aa6-842f-5cccad765e42
md"""> #### *Stuff you don't need to look at to complete this assignment*"""

# ╔═╡ b175a852-bd9a-4e93-b125-51a439b54425
hyginus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/grant-hyginus.txt"

# ╔═╡ 13f1e279-d31f-4b97-81aa-4f0df6c77e0a
apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/apollodorus-topos.txt"

# ╔═╡ bb4b58ea-d5db-4d93-9630-f7ff613c2c50
menu = ["" => "Choose a text", hyginus_url => "Hyginus", apollodorus_url => "Apollodorus"]

# ╔═╡ 30dc0643-c8d2-417a-a285-b7510929c444
@bind text_url Select(menu)

# ╔═╡ dba98e0d-b8f9-4ef2-b41e-beda5aacf83c
text_url

# ╔═╡ 5e8909f6-511d-4fe6-9cd3-32c8d124f2d8
isempty(text_url)

# ╔═╡ 9b64de87-8fc0-4a19-bba6-563ad818d89e
text_contents = if isempty(text_url)
	""
else
	read_url(text_url)
end

# ╔═╡ a8d8012b-16d2-48e2-9e3e-44d0523b96cb
words = wordlist(text_contents)

# ╔═╡ 948a4c0f-9e90-4b30-b613-e03a71037119
result_list = named_entities(words)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "1da3308db7b45dbb42f679dd063bdb730a7b5248"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

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

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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
git-tree-sha1 = "1e597b93700fa4045d7189afa7c004e0584ea548"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

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
# ╟─f6bc3e32-4b5a-11ee-06ae-0fbebdca7dfd
# ╟─6bf51ab9-dee0-4563-9a88-94fb70f14c2e
# ╟─c35a93b3-cccd-49aa-8ebe-a0ec27fdea52
# ╟─565bd719-468b-4d1b-bfbb-2411e3cab06f
# ╠═6f2fb7a1-da48-4099-867e-7f0cf8fe43e6
# ╟─52c1724d-1c53-4ba1-bde6-c3eca9825703
# ╟─cc5deeee-42ff-401c-acb5-5458eb4b9fe2
# ╟─a9f68169-d603-499a-b36d-1e445a7e360f
# ╟─a2d34e4a-d7e0-4ca8-9b6c-a4c67cac337e
# ╟─30dc0643-c8d2-417a-a285-b7510929c444
# ╠═dba98e0d-b8f9-4ef2-b41e-beda5aacf83c
# ╟─0c187725-1b0d-4b2f-97f6-6839c73bad03
# ╠═5e8909f6-511d-4fe6-9cd3-32c8d124f2d8
# ╟─9ae5f7f5-9099-4e47-a47c-854cbf68b555
# ╟─a0215564-e763-43ce-ad67-f24296dd0976
# ╟─98e28be6-27af-4b50-951e-8cf6ccce8e1a
# ╠═9978b453-2abb-40d7-8152-37e0919b353e
# ╟─43be0af1-ca53-4fa9-a99c-b15a62b901a8
# ╟─e3807564-23d4-4a7b-9cda-8c28bb23200b
# ╟─d63f35fe-a318-4100-8544-ec699fec3a49
# ╟─07e10060-0c17-4470-a56f-667b8f14b8e1
# ╠═87ccb60d-a7fa-4537-8fc3-62706e426b98
# ╠═77d85986-5e0e-4b0d-a833-a602ea6a1c91
# ╠═f17add47-ca31-4a8e-9e71-ace4c1166760
# ╟─4be85ad4-51f3-4933-8534-90d2c3c9e7cc
# ╟─21c61c62-9598-4753-83cb-7059dff13cb8
# ╟─4cd51841-e072-4976-af88-24dbb7feba69
# ╠═9b64de87-8fc0-4a19-bba6-563ad818d89e
# ╟─777c86d6-0194-4037-824a-f5c38ac5f62f
# ╟─0f464472-a457-4385-9c3f-cbe56a3e37ba
# ╟─979c8c8f-aaf3-4ea5-abc7-bba46f89f3aa
# ╠═9ab0b3dd-9bf1-4f3d-8b16-6457e4a6da50
# ╟─a8cf9868-941d-44bb-97ac-2d5efc7cb5c4
# ╠═43be1c9c-2a90-4c14-9d33-39a58ecc0beb
# ╠═94cb21fd-8619-436d-a09a-344bf5cfbdd3
# ╟─feffe07b-a5da-466c-a288-fe2de72c7c01
# ╠═a8d8012b-16d2-48e2-9e3e-44d0523b96cb
# ╟─f514901d-5f69-464f-9e5a-eafbd8b3ecce
# ╟─9fbbf32e-1672-4061-ad16-899b96892b2b
# ╟─ba2146e6-8e7d-455b-bbc9-0eb101ea2b4e
# ╠═fdd8adbb-0861-4e05-9284-7815ed1a0600
# ╠═13dd752c-7eaa-4ccd-9cd5-044383bde9ae
# ╠═34c080ed-7fd4-4477-bbea-0a8d12834f47
# ╟─52eda228-be5b-4825-a22c-4c232829b8b6
# ╠═cc023f06-030f-4773-8598-4796d4cc1340
# ╟─35a78d3a-531c-418b-b555-e751692d67b7
# ╟─959aef77-147a-4d71-b6db-4a5248b21610
# ╠═646593a9-30cb-42a5-8a33-ffbbc9b1b5b7
# ╠═9c64e61a-d2fe-4371-b0a1-06940f48c462
# ╠═29296cab-24d9-4146-8343-5b7de8acd002
# ╟─37b05771-0a0e-490b-a0e3-65288fc3c5b2
# ╠═948a4c0f-9e90-4b30-b613-e03a71037119
# ╟─d61f1a42-2fcc-46fe-9df7-40aeffa1373d
# ╟─07ec05a7-d71d-48d5-ade6-dcd90efa27c0
# ╟─8a55750c-6b99-4d37-9b59-8ab9b72a6f8f
# ╠═15eff456-bb73-4042-bef3-ab17e98fc8b0
# ╟─2216e17c-bd94-4f6a-abdb-da4e8e8cc7f7
# ╠═bf36a60e-9dc0-4fa0-bec0-91f3716acb00
# ╠═2614a412-6bf8-4e34-8e83-d92e55108e2f
# ╟─8ee4dc67-1332-4692-99df-2b10b6e845b4
# ╠═fca20741-83fc-4292-94b8-81f7ee78241f
# ╟─d43599f5-fcb7-4001-bf86-cde36380ce5f
# ╠═dcb05b4f-3f4a-4355-a610-54cca730da3b
# ╟─9150ac0b-b71e-40d4-8b5b-4fcd9c4d2228
# ╟─d93fc631-0fe8-4d5f-9a3c-9a3fed8d82b9
# ╟─25b9a85f-3af4-4c90-a504-fc0432a89d3d
# ╟─e6b9acf9-1894-4aa6-842f-5cccad765e42
# ╟─b175a852-bd9a-4e93-b125-51a439b54425
# ╟─13f1e279-d31f-4b97-81aa-4f0df6c77e0a
# ╟─bb4b58ea-d5db-4d93-9630-f7ff613c2c50
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
