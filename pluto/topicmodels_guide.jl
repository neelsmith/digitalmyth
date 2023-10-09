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

# ╔═╡ 910bb052-82e1-4566-96eb-70d3789982bb
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.add(url="https://github.com/neelsmith/CitableCorpusAnalysis.jl")
	
	using TopicModelsVB
	using CitableCorpusAnalysis
	using CitableBase
	using CitableCorpus
	using Orthography
	using PlutoUI
end

# ╔═╡ 76656778-6698-11ee-09ce-a730fa578e8e
md"""# Topic modelling with the `TopicModelsVB` package"""

# ╔═╡ dc23825d-586d-4591-b004-4d37cfd18589
md"""
!!! note "Settings for topic model"
""" 

# ╔═╡ 7f1a8602-392f-431c-9059-d53d1c2d9cc1
md"""*Number of topics*: $(@bind n confirm(Slider(2:20, default=12, show_value = true))) *Iterations* $(@bind iters confirm(Slider(100:50:1000, default=200, show_value = true)))
"""

# ╔═╡ 90b5a2ef-c8ab-4fb9-a12d-0832a9d4e9fb
(n, iters)

# ╔═╡ 9e43dba0-1ed9-441b-aca1-7bdadabae761
function modeltopics(corp, n)
	model = fCTM(corp, n)
	train!(model, tol = 0, checkelbo = Inf)
	model
end

# ╔═╡ e295ca3b-7e89-41c6-9163-b2a85526ebf0
md"""
!!! note "Results"
"""

# ╔═╡ 645301aa-2870-44fd-a076-33d3a676e69b
md"""
*Number of terms to show* $(@bind terms_n Slider(5:50, default=10, show_value = true))
"""

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

# ╔═╡ Cell order:
# ╟─910bb052-82e1-4566-96eb-70d3789982bb
# ╟─76656778-6698-11ee-09ce-a730fa578e8e
# ╟─dc23825d-586d-4591-b004-4d37cfd18589
# ╟─7f1a8602-392f-431c-9059-d53d1c2d9cc1
# ╟─8eceb8d5-5e86-4b71-96d2-d78c94d2e552
# ╠═90b5a2ef-c8ab-4fb9-a12d-0832a9d4e9fb
# ╠═9e43dba0-1ed9-441b-aca1-7bdadabae761
# ╟─e295ca3b-7e89-41c6-9163-b2a85526ebf0
# ╠═741b67b6-a185-4ac8-a442-6a25067de3f7
# ╟─645301aa-2870-44fd-a076-33d3a676e69b
# ╟─4c2472a2-8d5f-4093-b925-4e8698e79ff6
# ╟─893a7b3d-102a-4c2c-98d1-d37a03d0fa8a
# ╟─89d9e7cd-a425-4afc-8403-b5469323e63c
# ╟─f57b186d-1576-403f-86ea-2916678f9739
# ╟─444060a8-c88a-45c5-b8c2-f97065c85888
# ╠═38a31546-a376-4398-a185-fb751f769362
# ╠═2db7e0d3-8f44-4e1e-9043-c97d97b5eac3
