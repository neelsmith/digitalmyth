### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 1e29e55b-92f4-4d8b-97ce-2e095020e14b
begin
	using PlutoTeachingTools
end

# ╔═╡ 88551448-5b01-40ba-9701-d3460992ad89
using StatsBase

# ╔═╡ 5e4b385c-5876-11ee-3683-3b2877de5d1c
md"""# More with collections of data"""

# ╔═╡ ebcf6ac5-8fa2-4c3b-9d62-c031e829b5e6
md"""## Composing texts from vectors of strings"""

# ╔═╡ 783c14af-d644-4139-82bb-89ccad5e64d6
md"""Julia's `join` function can be a handy way to compose a plain-text file one line at a time.

Consider the following example that takes a list of node-pairs, and writes a valid DOT-format graph file.
"""

# ╔═╡ 44d483b6-1860-4785-802f-1581a836df17
md"""We start with a vector of *pairs*: that is, a Vector of Vectors, where each inner Vector has two names."""

# ╔═╡ 2bd9e98e-cd1c-40d6-93d8-52b0b653951f
nodepairs = [
	["Athena", "Zeus"],
	["Hera", "Zeus"],
	["Apollo", "Zeus"],
	["Apollo", "Athena"]
]

# ╔═╡ c479782d-8c24-40fa-8067-c4cb311fd44d
md"""The function in the following cell builds up the output data line by line,
pushing each line to the `datalines` array.  It concludes by turning the the Vector of data lines into a single String, with each element in the Vector joined to the next by a new line character (`\n`).
"""

# ╔═╡ e1c67cd1-7ba8-48b2-be7d-9f9055bac7ab
"""Given a list of pairs, compose a DOT-format string
representing these pairs as a social network.
"""
function dotformat(pairlist)
	datalines = []
	push!(datalines, """graph "sample-graph" {""")
	for pair in pairlist
		dataline = pair[1] * " -- " * pair[2]
		push!(datalines, dataline)
	end
	push!(datalines, "}")
	join(datalines, "\n")
end

# ╔═╡ 85c3e1b6-ba86-4e2f-b757-5d8d24d49fd9
md"""Let's test the function:"""

# ╔═╡ c37a2af0-5a79-4af6-af65-e6f84e054316
dotdata = dotformat(nodepairs)

# ╔═╡ eaa2b47d-da29-471b-a3fc-7de688d67798
md"""Because the multi-line string can be hard to read in Pluto, we can use Julia's `print` function to look at it:"""

# ╔═╡ da8386de-60f6-40ad-8025-a190d2edf15b
dotdata |> print

# ╔═╡ 5a4ccf56-b17e-45b2-97d7-854562fdb4cc
tip(md"""If you'd like to save the data to a file on your computer, you can un-comment the lines in the following cell.  It will write a file named `sampledot.dot` to your computer wherever you started up Pluto.  

This is a valid DOT file you could open and visualize in Gephi!
""")

# ╔═╡ 4c51b959-ec1f-422b-9d42-9ca77b189a28
# open("sampledot.dot", "w") do io
	#write(io, dotdata)
#end

# ╔═╡ cc10b7ca-84f0-45e4-afa2-bde540852c62
md"""## `for` loops"""

# ╔═╡ c062b8a3-2970-46a4-a927-ad03f82521b6
md"""A `for` loop allows you to examine each element of a Vector.  Here's a function that transforms every string in a list to its lower case version, for example.
"""

# ╔═╡ 86af8dd0-7754-42f9-8288-5e56a3d9a639
function lc_list(wordlist)
	results = []
	for word in wordlist
		push!(results, lowercase(word))
	end
	results
end

# ╔═╡ 1fe18f05-8c85-4f6a-8eec-c51af1ac9a37
heroes = ["Achilles", "Hector", "Patroclus", "Paris"]

# ╔═╡ 34af2544-d736-4e2a-9116-c1a6fbdc85f5
lc_list(heroes)

# ╔═╡ f5ed36b8-e724-46c4-8dca-5ec1f6ded7f1
md"""Of course in this example, we could have done exactly the same thing with the `map` function, like this:
"""

# ╔═╡ 950a7f57-dec1-48fb-beb9-1b7c30c99fea
map(hero -> lowercase(hero), heroes)

# ╔═╡ 83266fdb-3725-4299-822a-25af6b706f89
md"""Sometimes, however, the way you need to process each element is complex enough that `map` expression can be awkward, and a `for` loop more convenient.  A good example is when you want need to have a loop inside a loop
"""

# ╔═╡ 947a727d-a428-4d9e-aed4-3e5ca22f15b8
md"""Study the following function.  The outer loop starts by looking at each element in a Vector (here referred to as `wrd`).  Each time it looks at one word in the list, the inner loop then cycles through every word in the list and compares the pair.  If the two terms are not identical, we push the pairing onto the `results` Vector.

"""

# ╔═╡ 1b784c5d-1303-4e44-92ae-869e9f308fcc
"""Given a list of words, find all pairs of names."""
function namepairs(wordlist)
	results = []
	for wrd in wordlist
		for wrd2 in wordlist
			if wrd == wrd2
			else
				push!(results, sort([wrd, wrd2]))
			end
		end
	end
	unique(results)
end

# ╔═╡ be0ed2f7-bd34-4719-8749-bef174892aa0
namepairs(heroes)

# ╔═╡ 41a329b3-8909-46d8-a1b3-7dbc81fd5bd8
md"""## Counting items in a collection with a dictionary"""

# ╔═╡ edfa69e7-32a6-4a8d-aa8c-1fe85ffae0d5
s = "The quick brown fox jumped over the lazy dog."

# ╔═╡ 20fd50bc-ef52-43e8-a594-972201e29d5f
md"""How many times does each character occur in the preceding sentence?  We can use the familiar `split` function to split the string up into a list of single-character strings by splitting the text on... an empty string!
"""

# ╔═╡ 80409f26-3563-4048-abc7-ed448787b273
charlist = split(s,"")

# ╔═╡ 9c4cca08-bb94-4591-89ec-b04619b95683
md"""We could write custom code to count each letter. (That would not be difficult with a `for` loop.) But counting elements of a Vector is a common operation, and there is a thoroughly tested function to do just that in the `StatsBase` package.
"""

# ╔═╡ d79c129d-16ae-4f68-9b37-237b1c5d3e8a
md"""The function is called `countmap`.  Notice the *type* of the object it returns."""

# ╔═╡ c7cb039b-a00f-4a29-a05a-339bbd0865fd
lettercounts = countmap(charlist)

# ╔═╡ 19f6baaf-ad87-4da5-bf11-b177a92ab4ca
md"""In Julia, the `Dict` type is a *dictionary*.  This is a different kind of collection, where every element has a unique *key* and a corresponding *value*.  To look up a value in the dictionary, you provide a key value between square brackets, like the numeric index to a Vector.  Here, for example ,we can see that the single letter `e` occurs 4 times.
"""

# ╔═╡ 28b39582-371c-4f41-949b-3fda0db5d157
lettercounts["e"]

# ╔═╡ 55cf0ea4-ecd3-4cc9-b0d4-2323c9f6f116
md"""Unlike Vectors, dictionaries do *not* have an order. Instead, the expectation is that you will have some specific value you want to look up.  You can find all the key values in a `Dict` with the `keys` function.
"""

# ╔═╡ 618e0729-184e-4b53-9af8-08cd2f0f2f8a
keys(lettercounts)

# ╔═╡ 3905bd9f-bf06-4dea-9d73-8f510c45751e
md"""You can also use the `haskey` function to test if a key value occurs in your dictionary.
"""

# ╔═╡ 420b3bea-7500-4ef4-bfc2-6c22ffd5e92e
haskey(lettercounts, "e")

# ╔═╡ d939cfb2-c169-4685-8647-c7b6e6a40aff
haskey(lettercounts, "5")

# ╔═╡ 19d2f0a2-20c1-413e-95e2-da83b417fe8b
md"""You can create your own empty dictionary like this."""

# ╔═╡ 1d22c6cb-edf1-47c1-a377-b6d213a87138
greeknames = Dict()

# ╔═╡ 728a4194-b933-490f-9573-e36f7097ba96
md"""Use the same square-bracket notation to add values to your dictionary."""

# ╔═╡ 1d8763e9-c997-405f-b1d0-fd4dc0e8ddee
greeknames["Zeus"] =  "Ζεύς"

# ╔═╡ 61db36b7-fd24-49b4-8866-835eaebfd359
greeknames["Hera"] =  "Ἥρα"

# ╔═╡ 03957927-268d-4e53-8c69-0c0ea37b52da
greeknames["Apollo"] =  "Ἀπόλλων"

# ╔═╡ 9a81efce-f0fa-4919-a3c1-fb9ca8433349
greeknames["Artemis"] = "Ἄρτεμις"

# ╔═╡ 097ef8fb-ee86-442b-b804-65d5cbb9ecd8
greeknames["Apollo"]

# ╔═╡ d3bf979e-52ff-4296-95cb-46e9d911028f
gods = ["Zeus", "Hera"]

# ╔═╡ 73939ece-fda0-4d0d-b956-9869917b8a87
md"""Here's an example that uses a dictionary to map every element of a Vector to the corresponding value in the dictionary."""

# ╔═╡ 1673c6e6-dceb-4a08-b33a-aeed6d38cc3f
map(god -> greeknames[god], gods)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
PlutoTeachingTools = "~0.2.13"
StatsBase = "~0.34.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "606566672820c7389d14f1b3800cf718c0b2caaf"

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

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

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

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

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

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

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

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

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
git-tree-sha1 = "7364d5f608f3492a4352ab1d40b3916955dc6aec"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.5.5"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

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
# ╟─1e29e55b-92f4-4d8b-97ce-2e095020e14b
# ╟─5e4b385c-5876-11ee-3683-3b2877de5d1c
# ╟─ebcf6ac5-8fa2-4c3b-9d62-c031e829b5e6
# ╟─783c14af-d644-4139-82bb-89ccad5e64d6
# ╟─44d483b6-1860-4785-802f-1581a836df17
# ╟─2bd9e98e-cd1c-40d6-93d8-52b0b653951f
# ╟─c479782d-8c24-40fa-8067-c4cb311fd44d
# ╠═e1c67cd1-7ba8-48b2-be7d-9f9055bac7ab
# ╟─85c3e1b6-ba86-4e2f-b757-5d8d24d49fd9
# ╠═c37a2af0-5a79-4af6-af65-e6f84e054316
# ╟─eaa2b47d-da29-471b-a3fc-7de688d67798
# ╠═da8386de-60f6-40ad-8025-a190d2edf15b
# ╟─5a4ccf56-b17e-45b2-97d7-854562fdb4cc
# ╠═4c51b959-ec1f-422b-9d42-9ca77b189a28
# ╟─cc10b7ca-84f0-45e4-afa2-bde540852c62
# ╟─c062b8a3-2970-46a4-a927-ad03f82521b6
# ╠═86af8dd0-7754-42f9-8288-5e56a3d9a639
# ╠═1fe18f05-8c85-4f6a-8eec-c51af1ac9a37
# ╠═34af2544-d736-4e2a-9116-c1a6fbdc85f5
# ╟─f5ed36b8-e724-46c4-8dca-5ec1f6ded7f1
# ╠═950a7f57-dec1-48fb-beb9-1b7c30c99fea
# ╟─83266fdb-3725-4299-822a-25af6b706f89
# ╟─947a727d-a428-4d9e-aed4-3e5ca22f15b8
# ╠═1b784c5d-1303-4e44-92ae-869e9f308fcc
# ╠═be0ed2f7-bd34-4719-8749-bef174892aa0
# ╟─41a329b3-8909-46d8-a1b3-7dbc81fd5bd8
# ╟─edfa69e7-32a6-4a8d-aa8c-1fe85ffae0d5
# ╟─20fd50bc-ef52-43e8-a594-972201e29d5f
# ╠═80409f26-3563-4048-abc7-ed448787b273
# ╟─9c4cca08-bb94-4591-89ec-b04619b95683
# ╠═88551448-5b01-40ba-9701-d3460992ad89
# ╟─d79c129d-16ae-4f68-9b37-237b1c5d3e8a
# ╠═c7cb039b-a00f-4a29-a05a-339bbd0865fd
# ╟─19f6baaf-ad87-4da5-bf11-b177a92ab4ca
# ╠═28b39582-371c-4f41-949b-3fda0db5d157
# ╟─55cf0ea4-ecd3-4cc9-b0d4-2323c9f6f116
# ╠═618e0729-184e-4b53-9af8-08cd2f0f2f8a
# ╠═3905bd9f-bf06-4dea-9d73-8f510c45751e
# ╠═420b3bea-7500-4ef4-bfc2-6c22ffd5e92e
# ╠═d939cfb2-c169-4685-8647-c7b6e6a40aff
# ╟─19d2f0a2-20c1-413e-95e2-da83b417fe8b
# ╠═1d22c6cb-edf1-47c1-a377-b6d213a87138
# ╠═728a4194-b933-490f-9573-e36f7097ba96
# ╠═1d8763e9-c997-405f-b1d0-fd4dc0e8ddee
# ╠═61db36b7-fd24-49b4-8866-835eaebfd359
# ╠═03957927-268d-4e53-8c69-0c0ea37b52da
# ╠═9a81efce-f0fa-4919-a3c1-fb9ca8433349
# ╠═097ef8fb-ee86-442b-b804-65d5cbb9ecd8
# ╠═d3bf979e-52ff-4296-95cb-46e9d911028f
# ╟─73939ece-fda0-4d0d-b956-9869917b8a87
# ╠═1673c6e6-dceb-4a08-b33a-aeed6d38cc3f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
