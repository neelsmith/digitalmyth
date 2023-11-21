### A Pluto.jl notebook ###
# v0.19.29

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

# ╔═╡ 605a8521-c7e8-41a7-80cd-03b563d9d508
begin
	using Downloads
end

# ╔═╡ 305b08d9-06a1-4dd2-9039-8bdde87dc3f8
using PlutoUI

# ╔═╡ e857609c-6379-11ee-3280-93844e2bf03a
md"""# Filtering out family relationship terms"""

# ╔═╡ ac07b29c-6fee-4c90-aa3c-91639ac51dfa
md"""
In this notebook, we will filter out all family relationship terms from a text. This is so that, when topic-modeling the text, we can cut out family terms to focus on specific stories with names, places, important objects, and verbs.

First, let's select a text to filter.
"""

# ╔═╡ a90acee0-a073-4017-ab78-6e4e41ff3fda
html"""<br></br>"""

# ╔═╡ 0e3ca6b6-ecc4-42fc-a44b-9b1b34c46547
md"""I have defined a list of family relationship terms to filter out. With the arguments we put into the filter function, Julia will look for these terms in the all-lowercase version of the text we have chosen and filter them out. After defining this list, I cleaned up and tokenized the text so that it is just a list of all the tokens in the text, converted to lowercase."""

# ╔═╡ 76ef01d7-1f16-4b81-8b96-b1fa23f06a5b
family_terms = ["son", "sons", "child", "children", "daughter", "daughters", "sibling", "siblings", "parent", "parents", "father", "mother", "fathers", "mothers", "grandfather", "grandfathers", "grandmother", "grandmothers", "grandparent", "grandparents", "aunt", "aunts", "uncle", "uncles", "cousin", "cousins", "nephew", "nephews", "niece", "nieces"]

# ╔═╡ d89bf453-0177-4b1e-ab55-abb00b6be26c
html"""<br></br>"""

# ╔═╡ a816cecc-dca9-4e8c-95b9-622c12c8020f
"father" in family_terms

# ╔═╡ 3f1487d5-fb46-45b5-8817-b8e643c1c371
md"""Let's filter our text. We want to keep only the words that are not in the list family_terms. The first difference from the unfiltered list will occur at item 94– "children" in the unfiltered text– which has been removed."""

# ╔═╡ 64c6a3b5-ed86-4100-9c48-327d8f64d8cb
html"""

<br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/>
"""

# ╔═╡ 674705e6-f472-4730-b80f-05a851def8bf
md"""> Things we all already know how to do"""

# ╔═╡ c3ff98b5-6aea-4ae6-b9b9-b0bcc83f7d94
function removepunct(s)
	filter(c-> !ispunct(c) , s )
end

# ╔═╡ a22a716a-ff35-451b-af4c-6f58b1f502fc
function read_url(u)
	Downloads.download(u) |> read |> String
end

# ╔═╡ 20b5cb1c-0bb6-4346-9efe-9d69b71581d7
function tokenizeurl(u)
	text = read_url(u)
	text = removepunct(text)
	text = map(s -> lowercase(s), text)
	text = split(text)
end

# ╔═╡ 322cc52b-502e-448d-9033-1ebf57b6945b
md"""> **Optional**: look at the following cells if you want to see how to build a pull-down menu with the `PlutoUI` package.
"""

# ╔═╡ 90713c1d-5342-422f-b65e-be284d85c8ce
md"""
The `PlutoUI` package gives us **U**ser-**I**nterface (**UI**) widgets like pull-down menus.
"""

# ╔═╡ 44ff7b9c-df7c-4c6d-bbeb-cff1bc73ebc5
md"""To make our menu more legible, we can assign long, unwieldly URLs to variables:"""

# ╔═╡ 64b6e451-45d8-4f78-911a-5677c672bf7e
hyginus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/grant-hyginus.txt"

# ╔═╡ da0d95a3-def8-4bcf-8778-dbd99e148079
apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/apollodorus-topos.txt"

# ╔═╡ 09db8604-a983-4348-8bf6-f560bb240c38
md"""
The PlutoUI menu widget works with a Vector of entries.  Each entry is a *Pair*, shown in Julia by connecting two values with a "fat arrow" `=>`.  (Don't confuse this with the "skinny arrow" `->`: remember that the skinny arrow defines a function!)  The right-hand value of the pair will be displayed in the pull-down menu. When you make a choice, the corresponding left-hand value will be assigned to a variable.

"""

# ╔═╡ d981c941-cd32-4e0d-b8c1-d8b23050a7df
menu = ["" => "Choose a text", hyginus_url => "Hyginus", apollodorus_url => "Apollodorus"]

# ╔═╡ 0c32e490-c975-4fa7-bbc3-049392d1c180
@bind text_url Select(menu)

# ╔═╡ 3829e54d-7180-4b80-b742-e68c273b8de0
if isempty(text_url)
	md"""*Please choose a URL to download*"""
else
	text_url
end

# ╔═╡ e027721e-cd84-49f9-a94a-b3e9c2627bde
isempty(text_url)

# ╔═╡ bd9b1108-1d00-4264-a625-0fe019cbd403
words = if isempty(text_url)
	[]
else
	tokenizeurl(text_url)
end

# ╔═╡ 10e9b139-5266-4edb-9a33-748ee351e5da
no_family = filter(word -> !(word in family_terms), words)

# ╔═╡ 862f3ff2-9504-4961-926c-41429b8afcd4
length(no_family)

# ╔═╡ 6df6eaec-9b38-45a1-87c9-c30edb5e8b56
length(words)

# ╔═╡ 403fbde8-4c2c-4ee5-9873-6b7cec823ebc
md"""Here's an example (exactly like the one at the top of this notebook) that shows how you create a widget with the menu values.  The syntax looks a little weird: you can just accept it as the magic we need to make an interactive menu.

> *Under the hood*: `@bind` is an example of a Julia *macro*. Macros are a lot like functions; they're used in `PlutoUI` because they allow us to create and actually run the interactive code for the menu.
"""

# ╔═╡ 0a8d017a-7f33-4795-a009-6aabccb47f75
@bind sample_url Select(menu)

# ╔═╡ 4ce918e8-3d01-48aa-baaa-9741bd4f9362
sample_url

# ╔═╡ 0cfd73de-4e37-4b36-ab7f-cae9bb33577c
md"""
Notice that we included in our menu an entry labelled "Choose a text" that has an empty String as its value.  You can test whether a string is empty before you try to use it.

"""

# ╔═╡ ebbc71f3-05af-4f6d-be64-8eb7cb426936
isempty(sample_url)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.52"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "2d650066e3919f3fa885923d00aabe420705bc03"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

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
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

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
# ╟─e857609c-6379-11ee-3280-93844e2bf03a
# ╟─ac07b29c-6fee-4c90-aa3c-91639ac51dfa
# ╟─605a8521-c7e8-41a7-80cd-03b563d9d508
# ╟─0c32e490-c975-4fa7-bbc3-049392d1c180
# ╟─3829e54d-7180-4b80-b742-e68c273b8de0
# ╠═e027721e-cd84-49f9-a94a-b3e9c2627bde
# ╟─bd9b1108-1d00-4264-a625-0fe019cbd403
# ╟─a90acee0-a073-4017-ab78-6e4e41ff3fda
# ╟─0e3ca6b6-ecc4-42fc-a44b-9b1b34c46547
# ╠═76ef01d7-1f16-4b81-8b96-b1fa23f06a5b
# ╟─d89bf453-0177-4b1e-ab55-abb00b6be26c
# ╠═a816cecc-dca9-4e8c-95b9-622c12c8020f
# ╟─3f1487d5-fb46-45b5-8817-b8e643c1c371
# ╠═10e9b139-5266-4edb-9a33-748ee351e5da
# ╠═6df6eaec-9b38-45a1-87c9-c30edb5e8b56
# ╠═862f3ff2-9504-4961-926c-41429b8afcd4
# ╟─64c6a3b5-ed86-4100-9c48-327d8f64d8cb
# ╟─674705e6-f472-4730-b80f-05a851def8bf
# ╠═c3ff98b5-6aea-4ae6-b9b9-b0bcc83f7d94
# ╠═a22a716a-ff35-451b-af4c-6f58b1f502fc
# ╠═20b5cb1c-0bb6-4346-9efe-9d69b71581d7
# ╟─322cc52b-502e-448d-9033-1ebf57b6945b
# ╟─90713c1d-5342-422f-b65e-be284d85c8ce
# ╠═305b08d9-06a1-4dd2-9039-8bdde87dc3f8
# ╟─44ff7b9c-df7c-4c6d-bbeb-cff1bc73ebc5
# ╠═64b6e451-45d8-4f78-911a-5677c672bf7e
# ╠═da0d95a3-def8-4bcf-8778-dbd99e148079
# ╠═09db8604-a983-4348-8bf6-f560bb240c38
# ╠═d981c941-cd32-4e0d-b8c1-d8b23050a7df
# ╟─403fbde8-4c2c-4ee5-9873-6b7cec823ebc
# ╠═0a8d017a-7f33-4795-a009-6aabccb47f75
# ╠═4ce918e8-3d01-48aa-baaa-9741bd4f9362
# ╟─0cfd73de-4e37-4b36-ab7f-cae9bb33577c
# ╠═ebbc71f3-05af-4f6d-be64-8eb7cb426936
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
