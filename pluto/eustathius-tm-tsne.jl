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

# ╔═╡ ccbe499f-409b-4383-8e79-599a31d917d7
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.add(url="https://github.com/neelsmith/CitableCorpusAnalysis.jl")
	using CitableCorpusAnalysis

	Pkg.add("TopicModelsVB")
	using TopicModelsVB

	Pkg.add("CitableCorpus")
	Pkg.add("CitableText")
	Pkg.add("CitableBase")
	using CitableBase, CitableText, CitableCorpus

	Pkg.add("Orthography")	
	using Orthography

	Pkg.add("PolytonicGreek")
	using PolytonicGreek


	Pkg.add("TSne")
	using TSne
	
	Pkg.add("PlotlyJS")
	using PlotlyJS

	Pkg.add("Statistics")
	using Statistics

	Pkg.add("SplitApplyCombine")
	using SplitApplyCombine

	Pkg.add("Kanones")
	using Kanones
	
	Pkg.add("PlutoUI")
	using PlutoUI

	md"""(*Unhide this cell to see or modify your Julia environment*) """
end

# ╔═╡ 6722d320-9eee-4ef2-ae9d-e7a715b16bcc
thelayout = Layout(
	title = "Cluster this",
	height = 300
)

# ╔═╡ a54a1bb6-fd70-11ec-2886-cdc4fb2e0c98
md"""
# Topic modeling tokens in Eustathius
"""

# ╔═╡ a24725e3-182b-4517-97da-33920b4fde27
md"""
!!! note "Settings for model"
"""

# ╔═╡ 34b24086-6510-4915-a039-31685a4c00a1
md"""*Number of topics*: $(@bind n confirm(Slider(2:20, default=12, show_value = true))) *Iterations* $(@bind iters confirm(Slider(100:50:1000, default=200, show_value = true)))
"""

# ╔═╡ 88c105d9-471d-48c7-9661-13503783ef8d
md"""
*Number of stop-word candidates to review* $(@bind top_n confirm(Slider(20:500, default = 100, show_value = true)))
"""

# ╔═╡ c1a7755b-c100-49ec-9a20-5b34ebe7a7f1
md"""
*Any **unchecked** terms will be treated as stop words.  **Check** any terms to include in the topic model.*
"""

# ╔═╡ c67e13cc-e823-4052-a04c-6916e7649f0a
md"""
*Computing models for **$(n) topics**, computed with up to **$(iters) iterations**.*
"""

# ╔═╡ 1c306e50-ec4c-4201-ba25-e3c6d2f3a633
md"""!!! note "Size of corpus"
    Choose `0` to include *all* passages in the corpus; otherwise, set a number of passages to model.
"""

# ╔═╡ ff168b8e-84b4-4b7d-9dfa-9ef48f89747d
md"""
!!! note "Results: fCTM algorithm"
"""

# ╔═╡ 39a33cee-b384-4a5c-bfd6-1c66d3c27956
md"""## Topic definitions"""

# ╔═╡ 54d1fe06-1ce6-4235-b89e-cb9236b0406d
md"""
*Number of terms to show* $(@bind terms_n Slider(5:50, default=10, show_value = true))
"""

# ╔═╡ df4681eb-ce41-4676-b54d-c88ae23ab680
#scatter(reduced[:,1], reduced[:,2])

# ╔═╡ 2a7a5ebf-f933-4db8-88b9-adcd8c4a1b64
html"""
<br/><br/><br/><br/><br/>
<hr/>
<i>You can ignore content below here</i>
"""

# ╔═╡ ae80ab9b-b002-4a38-a4a4-cca9e3284460
md"""
!!! note "The lexicon"
"""

# ╔═╡ 23b4c746-d640-4be8-84dc-503b3d081d1f
md"""

!!! note "Configuration and loading data"
"""

# ╔═╡ 48b10dd6-f1c8-424e-acfd-b67292620977
url = "https://raw.githubusercontent.com/neelsmith/eustathius/main/cex/bk21.cex"

# ╔═╡ 005fba72-a05f-4de0-996b-5187b6d992b2
corpus = fromcex(url, CitableTextCorpus, UrlReader)

# ╔═╡ dbf8e673-a705-4dd0-a5ba-23e28a2065a9
md"""*Comments to include*: $(@bind n_psgs confirm(Slider(0:length(corpus.passages), default=10, show_value = true))) 
"""

# ╔═╡ 1f659cb3-846a-4104-a602-7aab315dc050
normalized = map(corpus) do rawpsg
	CitablePassage(rawpsg.urn, knormal(rawpsg.text))
end |> CitableTextCorpus

# ╔═╡ 65240de4-2af4-45ef-834c-df6bc21c9874
ortho  = literaryGreek()

# ╔═╡ 1b3b47cc-a64d-48c3-9ff1-7b1ea87239c6
tkns = begin
	alltokens = tokenize(normalized, ortho)
	filter(alltokens) do t
		t.tokentype == LexicalToken()
	end
end

# ╔═╡ 831ef9d5-e70b-4b06-a250-b7cba1b12337
 sorted =  begin
 	
	lex = filter(tkns) do tpair
		tpair.tokentype == LexicalToken()
	end
 	termdict = map(lex) do t
       t.passage.text |> lowercase
	end |> group
	counts = []
	for k in keys(termdict)
		push!(counts, (k, length(termdict[k])))
	end
	sort(counts, by = pr -> pr[2], rev = true)
 end

# ╔═╡ 9d83f24b-b4bb-452c-8a77-72591a2edb83
begin
	most_freq = map(sorted[1:top_n]) do pr
		pr[1]
	end
	
	@bind keepers MultiCheckBox(most_freq)
end

# ╔═╡ a5d8aad0-15dd-4d50-8b58-15e604c6424f
stopwords = begin
	stopterms = map(sorted[1:top_n]) do termpair
		termpair[1]
	end
	finalstops = filter(stopterms) do stopterm
		! (stopterm in keepers)
	end
	finalstops
end

# ╔═╡ 08028ea4-725e-4b74-8689-2613024f94d8
# ╠═╡ show_logs = false
tmc = begin
	selectedcorpus = n_psgs == 0 ? normalized : CitableTextCorpus(normalized.passages[1:n_psgs])
	tmcorpus(selectedcorpus, ortho)
end

# ╔═╡ 02290f23-b89b-49f9-8096-99f40017f01a
begin
	model = fCTM(tmc, n)
	train!(model, tol = 0, checkelbo = Inf)
	model
end

# ╔═╡ d430eb4b-c9df-4e5a-a9c1-5b426a01eabc
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

# ╔═╡ 93e85656-ff97-44b2-b93e-8e6aef044d46
md"""

!!! note "Computing results"
"""

# ╔═╡ 05198d19-b82c-4b79-ba5d-676adf4958fa
"""Scale data for plotting with TSne.
This is voodoo from the TSne docs.
"""
rescale(A; dims=1) = (A .- mean(A, dims=dims)) ./ max.(std(A, dims=dims), eps())

# ╔═╡ 92166f58-0ce5-4434-9567-7a3e8375570a
rescaled = rescale(model.beta, dims=1);

# ╔═╡ e2be100d-debe-4d34-95d6-2e9c18b34193
# ╠═╡ show_logs = false
reduced = tsne(transpose(rescaled))

# ╔═╡ f8efda66-b549-4686-8e6b-53844cb47eb5
xs = reduced[:,1]

# ╔═╡ 5709e998-7a56-4c89-a176-e37eb0d5ba5c
typeof(xs)

# ╔═╡ c6a7b85a-cbea-4513-9975-10e9d056b199
ys = reduced[:,2]

# ╔═╡ fc861249-90e6-4982-9b56-8bbc8e5ccc5b
theplot = scatter(x = xs, y = ys, mode = "markers")

# ╔═╡ f06a5608-08bd-46e2-aaee-b73e50049ab7
Plot(theplot, thelayout)

# ╔═╡ c447eccb-4b33-4e28-bb10-336e815c7ac8
typeof(ys)

# ╔═╡ Cell order:
# ╟─ccbe499f-409b-4383-8e79-599a31d917d7
# ╠═fc861249-90e6-4982-9b56-8bbc8e5ccc5b
# ╠═6722d320-9eee-4ef2-ae9d-e7a715b16bcc
# ╠═f06a5608-08bd-46e2-aaee-b73e50049ab7
# ╟─a54a1bb6-fd70-11ec-2886-cdc4fb2e0c98
# ╟─a24725e3-182b-4517-97da-33920b4fde27
# ╟─34b24086-6510-4915-a039-31685a4c00a1
# ╟─88c105d9-471d-48c7-9661-13503783ef8d
# ╟─c1a7755b-c100-49ec-9a20-5b34ebe7a7f1
# ╟─9d83f24b-b4bb-452c-8a77-72591a2edb83
# ╟─c67e13cc-e823-4052-a04c-6916e7649f0a
# ╟─1c306e50-ec4c-4201-ba25-e3c6d2f3a633
# ╠═dbf8e673-a705-4dd0-a5ba-23e28a2065a9
# ╟─ff168b8e-84b4-4b7d-9dfa-9ef48f89747d
# ╠═02290f23-b89b-49f9-8096-99f40017f01a
# ╟─39a33cee-b384-4a5c-bfd6-1c66d3c27956
# ╟─54d1fe06-1ce6-4235-b89e-cb9236b0406d
# ╟─d430eb4b-c9df-4e5a-a9c1-5b426a01eabc
# ╟─df4681eb-ce41-4676-b54d-c88ae23ab680
# ╠═f8efda66-b549-4686-8e6b-53844cb47eb5
# ╠═c6a7b85a-cbea-4513-9975-10e9d056b199
# ╠═5709e998-7a56-4c89-a176-e37eb0d5ba5c
# ╠═c447eccb-4b33-4e28-bb10-336e815c7ac8
# ╟─2a7a5ebf-f933-4db8-88b9-adcd8c4a1b64
# ╟─ae80ab9b-b002-4a38-a4a4-cca9e3284460
# ╟─a5d8aad0-15dd-4d50-8b58-15e604c6424f
# ╟─831ef9d5-e70b-4b06-a250-b7cba1b12337
# ╟─23b4c746-d640-4be8-84dc-503b3d081d1f
# ╠═1b3b47cc-a64d-48c3-9ff1-7b1ea87239c6
# ╠═08028ea4-725e-4b74-8689-2613024f94d8
# ╠═48b10dd6-f1c8-424e-acfd-b67292620977
# ╠═005fba72-a05f-4de0-996b-5187b6d992b2
# ╠═1f659cb3-846a-4104-a602-7aab315dc050
# ╟─65240de4-2af4-45ef-834c-df6bc21c9874
# ╟─93e85656-ff97-44b2-b93e-8e6aef044d46
# ╠═05198d19-b82c-4b79-ba5d-676adf4958fa
# ╠═92166f58-0ce5-4434-9567-7a3e8375570a
# ╠═e2be100d-debe-4d34-95d6-2e9c18b34193
