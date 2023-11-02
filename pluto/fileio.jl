### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 0064d774-73ff-11ee-13ac-cf24cdd2ad4f
md""" # Reading and writing data in Julia: file I/O"""

# ╔═╡ 6f9062a8-f892-4ccc-b345-c4dfcb128767
md"""## Working with files and directories

"""


# ╔═╡ a872c2f9-526b-4cba-9b41-1ea5e26cbfe2
md"""!!! tip "File and directory names are just strings in Julia"
"""

# ╔═╡ 117e9f3c-e2eb-40c2-86f9-1cf61584bef6
f = "fileio.jl"

# ╔═╡ 1664aecf-8b69-4fd6-9961-b4fba5485f71
badfilename = "Not really a file"

# ╔═╡ b41568bf-404c-4d03-9489-0cf54a7b74f8
md"""
!!! tip "Check your sanity"

- `isfile()` 
- `isdir()`
"""

# ╔═╡ ca9c36ed-0431-4887-8ffb-28f74a5c0e28
isfile(f)

# ╔═╡ 5c62de54-9576-4c69-8c58-a077eec808cd
isfile(badfilename)

# ╔═╡ 6039bfb2-acec-4037-a7f9-b3a35c8fc3d6
isdir(f)

# ╔═╡ 23e9ea01-bd08-4942-955d-bbf172c84956
isdir(badfilename)

# ╔═╡ 61edb53b-63a4-4e03-8a22-28c35cecd016
md"""!!! tip "Finding directory names"

"""

# ╔═╡ a5df32a4-9d22-4657-bf41-bf970ffd47b6
md"""
`P`rint your `W`orking `D`irectory: 

- `pwd()`
"""

# ╔═╡ ef7c257d-319e-483a-a82d-6f2b312346c6
pwd()

# ╔═╡ 9af7b9dd-cc5f-4d39-8b16-eec5a821f0eb
md"""Find the parent (containing) directory:

- `dirname()`
"""

# ╔═╡ 232c3cf5-9276-4ec7-ba41-dce5b3041aef
parent = dirname(pwd())

# ╔═╡ 4dfe5b2d-7a81-48b6-9170-8a24d9872330
md"""!!! tip "Safely create file names with joinpath()"
"""

# ╔═╡ b72bdd0a-03a0-4322-b14f-851573141c04
apollodorus_file = joinpath(parent, "texts", "apollodorus-topos.txt")

# ╔═╡ e8653acb-662b-44b2-bf20-86ed283264b5
isfile(apollodorus_file)

# ╔═╡ 11a40f76-ffa5-4024-9970-3baf2c04203a
md"""## Reading files"""

# ╔═╡ 1c8b8e5b-28dd-4afa-bf57-caa26d18a680
md""" Read entire file contents
"""

# ╔═╡ ae5b20b9-6386-4804-bd18-d7fba01c61ae
md"""!!! tip "The read() function reads numeric bytes of data, so if you want textual data, remember to convert it to a string!"
"""

# ╔═╡ 42f7900c-0e68-4118-893b-4d431173e3b3
md"""Read the entire file into a string:"""

# ╔═╡ b010ee7e-d8aa-4c6b-922e-7ee36404bec0
fulltext = read(apollodorus_file) |> String

# ╔═╡ 028f8cee-1a88-4e98-908e-22c017ed24cc
md"""Read a file line-by-line into a Vector of strings:"""

# ╔═╡ 72843331-0665-4f89-b6e1-a2dfae2105c3
chapters = readlines(apollodorus_file)

# ╔═╡ 97a04379-3c68-443a-976f-e25c6252c696
md"""## Writing files"""

# ╔═╡ 1fd024c1-829a-4dc2-ae68-e152e1c65ea3
md"""Start with a file name (again, just a string)."""

# ╔═╡ 8662093d-9bcf-4bac-8357-9a5361a57d1d
outputfile = joinpath(parent, "testfilewriting.txt")

# ╔═╡ 28770e1d-ce2c-4c90-954d-8751ef18716a
md"""Your output data should also be a single string.  For example, if you have a *vector* of objects, use `join` to create a single string."""

# ╔═╡ ede0e11e-661d-48aa-9a0e-50a1b773ef34
md"""The next two cells strip out punctuation, and create an alphabetized list of Apollodorus' vocabulary:"""

# ╔═╡ 490f28f1-c892-413c-b5af-836ae376242c
nopunct = filter(c -> ! ispunct(c), fulltext)

# ╔═╡ 3687316f-12d3-46f3-abd3-ded12f1f8d28
wordlist = split(lowercase(nopunct)) |> unique |> sort

# ╔═╡ e7603c32-eb88-4bd7-9930-a767c976778c
md"""The next cell uses the `join` function to construct a single string with each word separated by a new-line character (written `\n` in Julia)."""

# ╔═╡ f6bded73-0e0e-4e69-8f16-7e99a3c4d9ba
outputstring = join(wordlist, "\n")

# ╔═╡ c04270e2-b2d5-4499-b8f4-22d5b7ae07d1
md""" The last steps are:

- open the file with *write* permission
- write the *string* data to the file
"""

# ╔═╡ bab5f443-362c-4253-bed6-7d9e4220d33c
md"""
You can just copy this idiom and use it in your code (in a terminal, VS Code, or a Pluto notebook):
"""

# ╔═╡ 2dbd6b24-aa90-4f92-b2b4-6a3287fb4e2e
open(outputfile, "w" ) do io
	write(io, outputstring)
end

# ╔═╡ Cell order:
# ╟─0064d774-73ff-11ee-13ac-cf24cdd2ad4f
# ╟─6f9062a8-f892-4ccc-b345-c4dfcb128767
# ╟─a872c2f9-526b-4cba-9b41-1ea5e26cbfe2
# ╠═117e9f3c-e2eb-40c2-86f9-1cf61584bef6
# ╠═1664aecf-8b69-4fd6-9961-b4fba5485f71
# ╟─b41568bf-404c-4d03-9489-0cf54a7b74f8
# ╠═ca9c36ed-0431-4887-8ffb-28f74a5c0e28
# ╠═5c62de54-9576-4c69-8c58-a077eec808cd
# ╠═6039bfb2-acec-4037-a7f9-b3a35c8fc3d6
# ╠═23e9ea01-bd08-4942-955d-bbf172c84956
# ╟─61edb53b-63a4-4e03-8a22-28c35cecd016
# ╟─a5df32a4-9d22-4657-bf41-bf970ffd47b6
# ╠═ef7c257d-319e-483a-a82d-6f2b312346c6
# ╟─9af7b9dd-cc5f-4d39-8b16-eec5a821f0eb
# ╠═232c3cf5-9276-4ec7-ba41-dce5b3041aef
# ╟─4dfe5b2d-7a81-48b6-9170-8a24d9872330
# ╠═b72bdd0a-03a0-4322-b14f-851573141c04
# ╠═e8653acb-662b-44b2-bf20-86ed283264b5
# ╟─11a40f76-ffa5-4024-9970-3baf2c04203a
# ╟─1c8b8e5b-28dd-4afa-bf57-caa26d18a680
# ╟─ae5b20b9-6386-4804-bd18-d7fba01c61ae
# ╟─42f7900c-0e68-4118-893b-4d431173e3b3
# ╠═b010ee7e-d8aa-4c6b-922e-7ee36404bec0
# ╟─028f8cee-1a88-4e98-908e-22c017ed24cc
# ╟─72843331-0665-4f89-b6e1-a2dfae2105c3
# ╟─97a04379-3c68-443a-976f-e25c6252c696
# ╟─1fd024c1-829a-4dc2-ae68-e152e1c65ea3
# ╠═8662093d-9bcf-4bac-8357-9a5361a57d1d
# ╟─28770e1d-ce2c-4c90-954d-8751ef18716a
# ╟─ede0e11e-661d-48aa-9a0e-50a1b773ef34
# ╠═490f28f1-c892-413c-b5af-836ae376242c
# ╟─3687316f-12d3-46f3-abd3-ded12f1f8d28
# ╟─e7603c32-eb88-4bd7-9930-a767c976778c
# ╠═f6bded73-0e0e-4e69-8f16-7e99a3c4d9ba
# ╟─c04270e2-b2d5-4499-b8f4-22d5b7ae07d1
# ╟─bab5f443-362c-4253-bed6-7d9e4220d33c
# ╠═2dbd6b24-aa90-4f92-b2b4-6a3287fb4e2e
