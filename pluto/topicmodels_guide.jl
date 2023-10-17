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

# ╔═╡ 910bb052-82e1-4566-96eb-70d3789982bb
# ╠═╡ show_logs = false
begin
	using Pkg
	
	Pkg.add(url="https://github.com/neelsmith/CitableCorpusAnalysis.jl")
	using CitableCorpusAnalysis

	Pkg.add("TopicModelsVB")
	using TopicModelsVB

	Pkg.add("CitableBase")
	using CitableBase
	Pkg.add("CitableCorpus")
	using CitableCorpus
	Pkg.add("Orthography")
	using Orthography

	Pkg.add("PlutoUI")
	using PlutoUI

	Pkg.add("Statistics")
	using Statistics
	Pkg.add("SplitApplyCombine")
	using SplitApplyCombine

	Pkg.add("StatsBase")
	using StatsBase
	Pkg.add("OrderedCollections")
	using OrderedCollections

	Pkg.add("TSne")
	using TSne
	
	Pkg.add("PlotlyJS")
	using PlotlyJS

	#Pkg.add("TSne")
	#using TSne
	md"""(*Unhide this cell to see or modify your Julia environment*) """
end

# ╔═╡ 76656778-6698-11ee-09ce-a730fa578e8e
md"""# Topic modelling with the `TopicModelsVB` package"""

# ╔═╡ dc23825d-586d-4591-b004-4d37cfd18589
md"""
!!! note "Settings for topic model"
""" 

# ╔═╡ 7f1a8602-392f-431c-9059-d53d1c2d9cc1
md"""*Number of topics*: $(@bind n confirm(Slider(2:30, default=12, show_value = true))) *Iterations* $(@bind iters confirm(Slider(100:50:1000, default=200, show_value = true)))
"""

# ╔═╡ 90b5a2ef-c8ab-4fb9-a12d-0832a9d4e9fb
(n, iters)

# ╔═╡ 9e43dba0-1ed9-441b-aca1-7bdadabae761
"""Train a model on corpus `corp`.
"""
function modeltopics(corp, n)
	model = fCTM(corp, n)
	train!(model, tol = 0, checkelbo = Inf)
	model
end

# ╔═╡ b813512f-f26f-4156-9c4a-98653a4818bb
md"""
*Number of stop-word candidates to review* $(@bind top_n confirm(Slider(20:500, default = 100, show_value = true)))
"""

# ╔═╡ 4f50711c-ed11-4230-94d0-4d6b8619bd13
md"""
*Any **unchecked** terms will be treated as stop words.  **Check** any terms to include in the topic model.*
"""

# ╔═╡ e295ca3b-7e89-41c6-9163-b2a85526ebf0
md"""
!!! note "Results"
"""

# ╔═╡ 645301aa-2870-44fd-a076-33d3a676e69b
md"""
*Number of terms to show* $(@bind terms_n Slider(5:50, default=10, show_value = true))
"""

# ╔═╡ 556457dc-bbbd-41a8-bf47-21b19ce3dec7
thelayout = Layout(
	title = "Plotted",
	height = 300
)

# ╔═╡ 893a7b3d-102a-4c2c-98d1-d37a03d0fa8a
html"""
<br/><br/><br/><br/><br/>
"""

# ╔═╡ 89d9e7cd-a425-4afc-8403-b5469323e63c
md""">  **Load data**"""

# ╔═╡ 444060a8-c88a-45c5-b8c2-f97065c85888
apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/main/texts/apollodorus.cex"

# ╔═╡ 38a31546-a376-4398-a185-fb751f769362
c = fromcex(apollodorus_url, CitableTextCorpus, UrlReader)

# ╔═╡ 8eceb8d5-5e86-4b71-96d2-d78c94d2e552
md"""*Passages to include*: $(@bind n_psgs confirm(Slider(0:length(c.passages), default=10, show_value = true))) 
"""

# ╔═╡ e3e84c55-1e00-46ad-9d1a-f0723326268d
lex = filter(t -> t.tokentype == LexicalToken(), tokenize(c, simpleAscii()))

# ╔═╡ 27d954bf-16e7-479f-aab9-89a976a302e4
counts = countmap(map( t -> t.passage.text, lex)) |> OrderedDict

# ╔═╡ 313e6cc1-3fb0-41bc-8190-deebf45564d3
sorteddict = sort(counts, rev=true, byvalue = true)

# ╔═╡ c09bb3ec-b7bf-4d52-8ecd-e9f95a389cdc
sorted = keys(sorteddict) |> collect

# ╔═╡ 021a00fe-e6f6-4c65-b31f-5af14d987c91
begin
	most_freq = sorted[1:top_n]
	@bind keepers MultiCheckBox(most_freq)
end

# ╔═╡ 2db7e0d3-8f44-4e1e-9043-c97d97b5eac3
"""From a `CitableTextCorpus`, create a `Corpus` in the model of the `TopicModelsVB` package
"""
function tmcorpus_eng(corp; limit = n_psgs, ortho = simpleAscii())
	tmcorpus(CitableTextCorpus(corp.passages[1:limit]), ortho)
end

# ╔═╡ f57b186d-1576-403f-86ea-2916678f9739
tm_corpus = tmcorpus_eng(c)

# ╔═╡ 741b67b6-a185-4ac8-a442-6a25067de3f7
model = modeltopics(tm_corpus, n)

# ╔═╡ 4c2472a2-8d5f-4093-b925-4e8698e79ff6
begin
	rows = []
	hdrs = ["Topic"]
	for hidx in 1:terms_n
		push!(hdrs, "Term $(hidx)")
	end
	push!(rows, "| " * join(hdrs, " | " ) * " |")

	formatspec = [" --- "]
	for fidx in 1:terms_n
		push!(formatspec, " --- ")
	end
	push!(rows, "| " * join(formatspec, " | " ) * " |")
	
	for (r,row) in enumerate(model.topics)
		colvals = ["**Topic $r**"]
       	for c in 1:terms_n
			push!(colvals, model.corp.vocab[model.topics[r][c]])
		end
		push!(rows, "| " * join(colvals, " | ") * " |" )
    end
	join(rows, "\n") |> Markdown.parse
end

# ╔═╡ 892ccf3b-f70d-4704-a062-afacb1b6cbd6
tmcorpus(CitableTextCorpus(c.passages[1:100]), simpleAscii())

# ╔═╡ 39a7935d-fb4b-4893-aad5-13abc205758d
md"""> **Reduce data for visualization**"""

# ╔═╡ 48a2ca09-b1f8-437f-8a39-09f9c68850d1
"""Scale data for plotting with TSne.
This is voodoo from the TSne docs.
"""
rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())

# ╔═╡ e8e4a94f-3d02-4e30-9405-80de8e652001
rescaled = rescale(model.beta, dims=1);

# ╔═╡ 4b050ad7-476f-4fd3-ac6e-446fe5960932
# ╠═╡ show_logs = false
reduced = tsne(transpose(rescaled))

# ╔═╡ ff379111-7817-4902-9f19-d4d8bb66a0b1
xs = reduced[:, 1]

# ╔═╡ f10919fa-4ab6-46f0-90ba-6a4d6412c462
ys = reduced[:, 2]

# ╔═╡ 218dede6-c21d-43de-850e-7d3bebe6a1d1
Plot(
	scatter(x = xs, y = ys, mode = "markers"),
	thelayout
)

# ╔═╡ Cell order:
# ╟─910bb052-82e1-4566-96eb-70d3789982bb
# ╟─76656778-6698-11ee-09ce-a730fa578e8e
# ╟─dc23825d-586d-4591-b004-4d37cfd18589
# ╟─7f1a8602-392f-431c-9059-d53d1c2d9cc1
# ╟─8eceb8d5-5e86-4b71-96d2-d78c94d2e552
# ╠═90b5a2ef-c8ab-4fb9-a12d-0832a9d4e9fb
# ╟─9e43dba0-1ed9-441b-aca1-7bdadabae761
# ╟─b813512f-f26f-4156-9c4a-98653a4818bb
# ╟─4f50711c-ed11-4230-94d0-4d6b8619bd13
# ╟─021a00fe-e6f6-4c65-b31f-5af14d987c91
# ╟─e295ca3b-7e89-41c6-9163-b2a85526ebf0
# ╟─741b67b6-a185-4ac8-a442-6a25067de3f7
# ╟─218dede6-c21d-43de-850e-7d3bebe6a1d1
# ╟─645301aa-2870-44fd-a076-33d3a676e69b
# ╟─4c2472a2-8d5f-4093-b925-4e8698e79ff6
# ╟─556457dc-bbbd-41a8-bf47-21b19ce3dec7
# ╟─893a7b3d-102a-4c2c-98d1-d37a03d0fa8a
# ╟─89d9e7cd-a425-4afc-8403-b5469323e63c
# ╟─f57b186d-1576-403f-86ea-2916678f9739
# ╟─444060a8-c88a-45c5-b8c2-f97065c85888
# ╠═38a31546-a376-4398-a185-fb751f769362
# ╠═e3e84c55-1e00-46ad-9d1a-f0723326268d
# ╠═27d954bf-16e7-479f-aab9-89a976a302e4
# ╠═313e6cc1-3fb0-41bc-8190-deebf45564d3
# ╠═c09bb3ec-b7bf-4d52-8ecd-e9f95a389cdc
# ╠═2db7e0d3-8f44-4e1e-9043-c97d97b5eac3
# ╠═892ccf3b-f70d-4704-a062-afacb1b6cbd6
# ╟─39a7935d-fb4b-4893-aad5-13abc205758d
# ╟─48a2ca09-b1f8-437f-8a39-09f9c68850d1
# ╠═e8e4a94f-3d02-4e30-9405-80de8e652001
# ╠═4b050ad7-476f-4fd3-ac6e-446fe5960932
# ╠═ff379111-7817-4902-9f19-d4d8bb66a0b1
# ╠═f10919fa-4ab6-46f0-90ba-6a4d6412c462
