### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ ded3ea33-1364-4566-acc0-e17be2797901
md"""# Using optional parameters"""

# ╔═╡ be628988-6ba7-4b6f-9fba-5cd36e976576
md"""
Key points about optional parameters:

- in defining your function, list *required* parameters, then a semicolon, then list *optional* parameters
- include a default value for optional parameters in format `name = value`
- in using your function, provide parameters in format `name = value`
"""

# ╔═╡ 4526372a-8559-4f0c-96d3-75aa7b65c059
md"""**Example of a function defintion with optional parameters**:

The following cell defines a function with one required paraemter named `txt`, and two optional parameters `case_sensitive` and `nopunct`.

"""

# ╔═╡ 84bcb6be-77da-11ee-0b53-15a09405a846
"""Tokenize a string. Allow optional specification of treating the string as case sensitive (default: `false`), and of stripping out punctuation (default: `false`).
"""
function tokenize(txt; case_sensitive = false, nopunct = false)
	if case_sensitive
		if nopunct
			punct_free = filter(c -> ! ispunct(c), txt)
			split(punct_free)
		else
			split(txt)
		end
		
	else # NOT case sensitive, so lower case everything
		lower = lowercase(txt)
		if nopunct
			punct_free = filter(c -> ! ispunct(c), lower)
			split(punct_free)
		else
			split(lower)
		end
	end
end

# ╔═╡ 78d13cff-c269-4827-a6a7-d2c6e106c829
s = "NOW is the time (TM)."

# ╔═╡ 8f0e0e5d-7246-428a-bb11-20c552749b39
md"""**Examples applying the function**

A sample string to test:
"""

# ╔═╡ 258b73dd-661a-4339-87f5-468db2459e93
md"""By default, the resulting list is *not* case sensitive and does *not* strip out punctuation."""

# ╔═╡ 66f7b1c8-ba78-468e-803a-8f8469228c05
tokenize(s)

# ╔═╡ 38fc9a5d-a118-45d0-9554-ac057c78965c
md"""Include one optional parameter"""

# ╔═╡ b91b0df9-f647-407d-b0ea-fefa0caf1cc7
tokenize(s;  nopunct = true)

# ╔═╡ d397d5bc-5270-44b8-a39f-b9cd964b3dfb
tokenize(s; case_sensitive = true)

# ╔═╡ fa31a076-79c2-4fab-ad8d-5a31060f5edd
tokenize(s; case_sensitive = true, nopunct = true)

# ╔═╡ Cell order:
# ╟─ded3ea33-1364-4566-acc0-e17be2797901
# ╟─be628988-6ba7-4b6f-9fba-5cd36e976576
# ╟─4526372a-8559-4f0c-96d3-75aa7b65c059
# ╠═84bcb6be-77da-11ee-0b53-15a09405a846
# ╟─8f0e0e5d-7246-428a-bb11-20c552749b39
# ╟─78d13cff-c269-4827-a6a7-d2c6e106c829
# ╟─258b73dd-661a-4339-87f5-468db2459e93
# ╠═66f7b1c8-ba78-468e-803a-8f8469228c05
# ╠═38fc9a5d-a118-45d0-9554-ac057c78965c
# ╠═b91b0df9-f647-407d-b0ea-fefa0caf1cc7
# ╠═d397d5bc-5270-44b8-a39f-b9cd964b3dfb
# ╠═fa31a076-79c2-4fab-ad8d-5a31060f5edd
