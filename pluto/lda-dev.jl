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

# ╔═╡ 0c6337e6-4de7-4e76-9589-42bc170a931a
# ╠═╡ show_logs = false
begin
	using PlutoUI, Markdown
	using Downloads 
	
	using CitableBase, CitableCorpus, CitableText
	using Orthography
	
	using StatsBase
	using OrderedCollections
	
	using TextAnalysis

	using UMAP
	using PlotlyJS
	
	md"*Unhide this cell to see the Julia environment.*"
end

# ╔═╡ ffb548e0-71b5-4ead-9033-9c44ca70b22a
md"""> ## DEV VERSION"""

# ╔═╡ c0543064-597c-4104-b26a-333437ddf4d8
nbversion = "2.1.0"

# ╔═╡ 6d24ec36-6d02-11ee-24af-7f32effe1a76
md"""# LDA topic modeling with the Julia `TextAnalysis` package

*Notebook version* **$(nbversion)**.

"""

# ╔═╡ 082b0f1f-12b2-4f09-be8f-4e2cbf35d714
md"""*See release notes* $(@bind release_history CheckBox())"""

# ╔═╡ f0bd2768-68bd-4535-b90e-34359b3030f9
if release_history
md"""
- **2.1.0**: add UMAP for dimensionality reduction; improve variable names and documentation of functions looking up LDA data values; improve UI with labelling of topics by top terms.
- **2.0.0**: remove TSne reduction of documents in topic space in anctipation of switch to using UMAP for dimensionality reduction; fixes bug in plotting of topic distribution per document; supports labelling of Gettysburg address versions.
- **1.1.0**: add plotting of TSne reduction of documents in topic space
- **1.0.0**: initial release
"""
end

# ╔═╡ e2ea0057-9a4c-4ddf-985a-e107fb3b0b38
md"""
!!! note "Load corpus and edit stop words"
"""

# ╔═╡ 0e6f70dc-2da6-43f1-9ded-66dcaa92877d
md"""*Case-insensitive*: $(@bind case_insensitive CheckBox(default = true))"""

# ╔═╡ dceb616c-e86d-40f9-815b-d8acbf2744f0
md"""
!!! note "Compute topic model"
"""

# ╔═╡ 423c2f39-5e1a-4751-989f-b68003d061d4
md"""*α* $(@bind α confirm(Slider(0:0.1:1.0, default = 0.1, show_value = true)))"""

# ╔═╡ 94672682-2e7e-4f70-b335-01f09f603add
md"""*β* $(@bind β confirm(Slider(0:0.1:1.0, default = 0.1, show_value = true)))"""

# ╔═╡ 3044d17c-b365-402a-a276-f3d4ae807cb5
md"""*Number of iterations* $(@bind iters confirm(Slider(1000:200:4000, show_value = true)))"""

# ╔═╡ 99b012eb-6f17-403e-b541-c1497ee1e7e5
md"""*Number of topics (`k`)* $(@bind k confirm(Slider(2:40, default = 6, show_value = true)))"""

# ╔═╡ 2733adb5-8dfd-4df9-8e28-5aa6dae9c175
md"""*Computation of ϕ and θ using LDA algorithm*:"""

# ╔═╡ 8d5f6c03-a776-4304-9b5f-dfd9c235edbd
md"""
!!! note "Review results: highest term scores for each topic"
"""

# ╔═╡ 4b742534-045e-43ce-96c1-9ad1587fba80
md"""*View top terms for each topic*: $( @bind toptermcount confirm(Slider(1:30, default =10, show_value = true)))"""

# ╔═╡ 1bce7141-c7db-4a86-ac1a-36bff54edc86
md"""*Plot term weights for topic:*"""

# ╔═╡ 7d740f6c-9430-4367-90a6-32933c3b4cd7
md"""
!!! note "View most significant documents for each topic"
"""

# ╔═╡ 0aad525c-1a6d-4a33-a046-1704fb0cbc36
md"""*View highest scoring passages (documents) for each topic* $(@bind topdocscount confirm(Slider(1:30, default = 8, show_value = true)))"""

# ╔═╡ 0e1fc056-c946-4c53-a046-69c6edec3044
md"""
!!! note "View details for a given passage (\"document\")"
"""

# ╔═╡ ec514c67-d35a-42aa-b2c0-cd56ba105c51
md"""*Select a passage*:"""

# ╔═╡ 8a2f14b8-6fb3-49f3-b161-e06ffe32108a
html"""
<br/><br/><br/><br/>
<br/><br/><br/><br/>
<br/><br/><br/><br/>
"""

# ╔═╡ 7214e92f-9bfa-42c2-b970-c1799f072d65
md"""
!!! warn "Everything below here is computation, not user interaction"
"""

# ╔═╡ fc12e5a6-6451-4b1e-8300-6d115c94cf66
md"""> **Find document data in theta**
"""

# ╔═╡ f50104d7-1c06-4813-bc86-1a6d4167d309
md"""> **Computing LDA**"""

# ╔═╡ 7c3d0dfc-6bf2-4b1a-848e-ecb07a298048
# top_scores(θ[:, 1], map(x -> labeltopic(ϕ[x,:], dtmatrix.terms), collect(1:k)))

# ╔═╡ ab7df6f8-2f79-4ee2-bf94-dcba9a1cfe3a
"""Given one row of a topic index, find top `n` scores,
and return a Vector of `n` pairs of topic relations and scores."""
function raw_pairs(row, termlist; n = 10)
	sorted = sort(row, rev = true)
	termvalpairs = []
	for val in sorted[1:n]	
		rowidx = findall(col -> col == val, row)
		push!(termvalpairs, (termlist[rowidx], val))
	end
    termvalpairs
end


# ╔═╡ 2ee1af26-c722-4874-a497-3dcd2d9d39fd
"""Given a list of possible index keys with corresponding scores, flatten the
list to create a list of the top `n` value-score pairs."""
function isolatescores(scorelists, n)
    flatresults = []
    names = map(pr -> pr[1], scorelists) |> Iterators.flatten |> collect |> unique
    for nameval in names[1:n]
        score = filter(pr -> nameval in pr[1], scorelists)[1][2]
        push!(flatresults,(nameval,score))
    end
    flatresults
end


# ╔═╡ e57a1d64-d14a-44ea-92b5-bd7d73c61aed
"""Find top `n` scores in `row`, and return corresponding values from `labelslist`.
Parameters:
- `datalist`: a single row or column of scores (for terms or documents)
- `labelslist`: ordered list of values corresponding to columns of scores (string for term, or ID for document)
"""
function top_scores(datalist, labelslist; n = 10)
	raw = raw_pairs(datalist, labelslist; n = n)
	isolatescores(raw, n)
end

# ╔═╡ b2f4f562-63e7-4055-90d5-cc0d3f5c75ab
"""Compose a human-readable label for a topic by catting together
the top `count` term values.
"""
function labeltopic(rowdata, termlist; count = 4)
	pairs = top_scores(rowdata, termlist)
	join(map(pr -> pr[1], pairs)[1:count], "_")
end

# ╔═╡ 89d1bd74-3e0b-4ef7-b4ed-d0923c00845f
md"""> **Markdown display**"""

# ╔═╡ 2547227f-99f2-49c6-a8d6-c1dbdda24fd9
"""Compose horizontal bar plot of term scores for a topic."""
function ldabar(scores, termlist, numterms)
	scorepairs = top_scores(scores, termlist; n = numterms)
	xs = map(pr -> pr[2], scorepairs)
	ys = map(pr -> pr[1], scorepairs)
	bplot = bar(x = xs, y = ys, orientation = "h")
	bplot
end

# ╔═╡ f59dba8a-03d4-4a85-a994-de832e8ddf5f
"""Compose markdown string to separate table header and body for a table with `n` columns."""
function hdr(n)
	rowval = ["| topic "]
	for i in 1:n
		push!(rowval, "| $(i) ")
	end
	join(rowval) * "|" 
end

# ╔═╡ 2e0e0119-32b5-46f3-aea7-7a447878ce33
"""Make a Markdown table to display top ranked documents for a given topic.
"""
function topdocs_md(topictodocscores, psglist, doccount)
	lines = [hdr(doccount)]
	push!(lines, repeat("| --- ", doccount + 1) * "|")
	
	for i in 1:k
		bigdocs = top_docs(topictodocscores[i,:], psglist; n = doccount)
		push!(lines, "| topic $(i) |" * join(map(pr -> pr[1], bigdocs), " |"))
	end
	join(lines,"\n")
end

# ╔═╡ dbab6c6e-8016-487a-887a-255c2f25b02e
"""Make a Markdown table to display list of top terms for a topic.
"""
function topterms_md(topictotermscores, termlist, termcount)
	lines = [hdr(termcount)]
	push!(lines, repeat("| --- ", termcount + 1) * "|")
	
	for i in 1:k
		bigterms = top_scores(topictotermscores[i,:], termlist; n = termcount)
		push!(lines, "| topic $(i) |" * join(map(pr -> pr[1], bigterms), " |"))
	end
	join(lines,"\n")
end

# ╔═╡ 863fd7c4-5460-4de0-b422-fa38350f7545
md"""> **Load data**"""

# ╔═╡ 0439bf2f-69a1-4aa8-a71a-dd058ebf5bfe
"""Downloads a text corpus from URL `u`, removes all punctuation, and optionally makes case-insensitive (the default). Returns three fundamental structures
from the `TextAnalysis` package:

1. a text corpus
2. a "lexicon"
3. the document-term matrix
"""
function ta_structs_from_corpus(citecorp; lc = true, stoplist = [])

	
	corp = map(psg -> StringDocument(psg.text), citecorp.passages) |> Corpus
    
	prepare!(corp, strip_punctuation)
	remove_words!(corp, stoplist)

    update_inverse_index!(corp)
	update_lexicon!(corp)
	
	
	(corp,  lexicon(corp), DocumentTermMatrix(corp))
end

# ╔═╡ 9c3ce649-4b24-476b-9798-386b5712000b
md"""> **UI widgets, URLs and canonical references**"""

# ╔═╡ cdb90b88-a4f1-4669-a2fc-abfef3a78933
bancroft = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/gettysburg/bancroft.cex"

# ╔═╡ 359e8801-9361-43a1-a0de-dbebb572437c
hay = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/gettysburg/hay.cex"

# ╔═╡ cd4b1dc2-3b5f-4b27-9db8-7890c2ad7e07
bliss = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/gettysburg/bliss.cex"

# ╔═╡ 8eff85fd-02ce-46ec-ba59-3208e73400fb
hyginus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/grant-hyginus.cex"

# ╔═╡ b34d675c-9f1a-49da-a4e1-54c1c1d1dcf0
apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/main/texts/apollodorus.cex"

# ╔═╡ 623099bd-d8fa-452c-b9f2-52e2940a0fb8
menu = [[] => "Choose a text", [hyginus_url] => "Hyginus", [apollodorus_url] => "Apollodorus", [apollodorus_url, hyginus_url] => "Both mythographers", [bliss, hay] => "Two versions of the Gettsyburg address"]

# ╔═╡ fcef1df7-4cac-4be1-9e98-67b835d81fb8
@bind text_url Select(menu)

# ╔═╡ 4ae018f9-2e20-474b-a99a-964e5d3d6887
hygwork = "stoa1263.stoa001"

# ╔═╡ 22cc0a3f-bbd6-483e-b407-ef56c8dba75f
apwork = "tlg0548.tlg001"

# ╔═╡ 7be14d53-9eaa-482f-b9f8-870154ab7c52
"""Strip work abbreviations off of brief string references."""
function stripref(s)
	s1 = replace(s, "Ap. " => "" )
	s2 = replace(s1, "Hyg. " => "")
	s3 = replace(s2, "Bliss " => "")
	s4 = replace(s3, "Hay " => "")
end

# ╔═╡ d0a12142-20fa-42ac-b220-cf7bca4a5be4
md"""> **Combining citable corpora**"""

# ╔═╡ 54bb7773-bd62-4cc0-9e19-35fc088a1a1f
"""
Create a single composite CitableTextCorpus` from two sources.
"""
function combine(c1::CitableTextCorpus, c2::CitableTextCorpus)
    CitableTextCorpus(vcat(c1.passages, c2.passages))
end




# ╔═╡ a1db21b6-6d6f-4dcd-a0e2-f538d3a25a13

"""
Create a single composite CitableTextCorpus` from an array of source corpora by recursively adding corpora.
"""
function combine(src_array, composite = nothing)
    if src_array === nothing || isempty(src_array)
        composite
    else 
        trim = src_array[1]
        popfirst!(src_array) 
        if isnothing(composite)
            combine(src_array, trim)
        else
            newcomposite = combine(trim, composite)
            combine(src_array, newcomposite)
        end
    end
end

# ╔═╡ fd23b519-3d5f-4a88-931c-a3118fbc256e
c = if isempty(text_url) 
	nothing 
else
	corpora = []
	for u in text_url
		if case_insensitive
			dl = fromcex(u, CitableTextCorpus, UrlReader)
			lccorp = map(psg -> CitablePassage(psg.urn, lowercase(psg.text)), dl.passages) |> CitableTextCorpus
			push!(corpora, lccorp)
		else
			push!(corpora, fromcex(u, CitableTextCorpus, UrlReader))
		end
	end
	combine(corpora)
end

# ╔═╡ c6b5a24b-3f29-49e2-b64b-8761854ec503
if isnothing(c) 
	
else
md"""
*Number of stop-word candidates to review* $(@bind top_n confirm(Slider(10:300, default = 100, show_value = true)))
"""


end

# ╔═╡ 3fede1f1-4bf3-48e0-82ec-203fd936199e
lextokens = isnothing(c) ? [] :  filter(t -> t.tokentype == LexicalToken(), Orthography.tokenize(c, simpleAscii()))

# ╔═╡ 68dc297d-ccd0-4dd1-a652-f19cfcd3c111
counts = countmap(map( t -> t.passage.text, lextokens)) |> OrderedDict

# ╔═╡ 1623909b-1c27-4cac-8cbe-4287ed3e30e8
sorteddict = sort(counts, rev=true, byvalue = true)

# ╔═╡ 5827632f-bd27-4658-a42b-d8fb7ff3e8bb
sorted = keys(sorteddict) |> collect

# ╔═╡ 543080bf-fa45-42ba-89db-1ba06f2c0f41
	most_freq = isempty(sorted) ? [] : sorted[1:top_n]

# ╔═╡ 60af1314-1b94-43af-954e-f1f984582144
if isnothing(c)
else
	@bind keepers MultiCheckBox(most_freq)
end


# ╔═╡ d87e8ba9-2ff2-4bd5-b696-77af0e9b0303
stopwords = filter(w -> ! (w in keepers), most_freq)

# ╔═╡ df880285-50a9-4a18-9203-0971b3e45924
md"""*Length of stopword list: $(length(stopwords)) words*"""

# ╔═╡ 42ae6aed-d949-47fa-8aa2-ae35eb79c29e
(ta_corpus, lex,  dtmatrix) =   if isnothing(c)
	(nothing, nothing, nothing)
else
	ta_structs_from_corpus(c; lc = case_insensitive, stoplist = stopwords)
end

# ╔═╡ 2350681e-861a-4f51-b4ca-1d0e29311b1f
# ╠═╡ show_logs = false
ϕ, θ  = isnothing(dtmatrix) ? (nothing, nothing) : lda(dtmatrix, k, iters, α, β)

# ╔═╡ 1fbd8ebc-adaa-4d42-b65f-291faac7633e
isnothing(dtmatrix) ? nothing : topterms_md(ϕ, dtmatrix.terms, toptermcount) |> Markdown.parse

# ╔═╡ e8ef7ca6-5910-421d-9892-c3d999937875
docys = if isnothing(dtmatrix)
	[]
else
	ycol = []
	for i in 1:k
		push!(ycol, labeltopic(ϕ[i,:], dtmatrix.terms))
	end
	ycol
end

# ╔═╡ cb07ecaa-f7f1-4495-a51b-9308d7b5ddf5
topicmenu = if isnothing(dtmatrix)
	["No text choosen yet"]
else
	tmenuitems = Pair{Int, String}[]
	for i in 1:k
		lbl = labeltopic(ϕ[i, :],  dtmatrix.terms)
		push!(tmenuitems,  i => lbl)
	end
	tmenuitems

end

# ╔═╡ 5fc19dbc-3f3b-41fb-b560-c67c04a3190b
@bind topicdetail Select(topicmenu)

# ╔═╡ 084082de-30f5-43a6-9a78-a4e7d2ec99e7
if isnothing(ϕ)
else
	layout = Layout(
		title = "Top $(toptermcount) terms for topic $(topicdetail)",
		xaxis_title = "Term score",
		yaxis_title = "Term",
		height = 300
	)
	barview = ldabar(ϕ[topicdetail,:], dtmatrix.terms, toptermcount)
	Plot(barview, layout)
end

# ╔═╡ a7917f32-8d08-4d3e-a34d-4cedbb5b9649
reff = if isnothing(c)  
	[]  
else
	workabbr = ""
	briefreff = []
	for psg in c.passages
	
		if contains(workcomponent(psg.urn), hygwork)
			workabbr = "Hyg. "
		elseif contains(workcomponent(psg.urn), apwork)
			workabbr = "Ap. "
		elseif contains(workcomponent(psg.urn), "bliss")
			workabbr = "Bliss "
		elseif contains(workcomponent(psg.urn), "hay")
			workabbr = "Hay "
		end
		push!(briefreff, workabbr * passagecomponent(psg.urn))
	end
	briefreff
end

# ╔═╡ 952ff6a6-b67b-4e0b-b80d-93d10a1d9a86
isnothing(dtmatrix) ? nothing : topterms_md(θ, reff, topdocscount) |> Markdown.parse

# ╔═╡ 45c8ba32-fda0-41e4-9c76-528d191fc298
if isnothing(ϕ)
else
	doclayout = Layout(
		title = "Top document scores for topic $(topicdetail)",
		yaxis_title = "Canonical reference",
		xaxis_title = "Document score",
		height = 300
	)
	docbarview = ldabar(θ[topicdetail,:], reff, topdocscount)
	Plot(docbarview, doclayout)
end

# ╔═╡ c9e0e222-200f-400e-9831-780133df3253
@bind psgref Select(vcat([""], reff))

# ╔═╡ d6c59846-88d1-48d8-9405-67bac12c5eeb
if ! isempty(psgref)
	stripped = stripref(psgref)
	psgtext = filter(psg -> passagecomponent(psg.urn) == stripped, c.passages)[1].text 
	"*Text of passage*:\n\n>**$(psgref)**: " * psgtext |> Markdown.parse
end

# ╔═╡ d82bbca8-e3bc-45fe-b473-fb86e7995650
docidx = findfirst(r -> r == psgref, reff)

# ╔═╡ 280de380-2dd0-4a88-b042-9767921a67d6
docxs = isnothing(θ) | isempty(psgref) ? [] : θ[:,docidx]

# ╔═╡ 57779e81-b2c9-4067-a675-4de47646556d
if isnothing(ϕ)
else
	#Plot(bar(y=docys, x = docxs), Layout(title = "Topic scores for passage (document) $(psgref)", height = 600, yaxis_title = "Topic number", xaxis_title = "Score for topic" ))

	Plot(bar(y=docys, x = docxs, orientation = "h"), Layout(title = "Topic scores for passage (document) $(psgref)", height = 400))
end

# ╔═╡ 0ef282af-f9a3-43c4-85c4-5e6478d0906b
md"""> **Dimensionality reduction**"""

# ╔═╡ 599af10b-51ee-40a2-a69d-5338e596a3a7
reduced = isnothing(θ) ? nothing : umap(θ, 3)

# ╔═╡ 1dddb425-2577-43f9-b4c8-9b5dd2dd912e
"""Create a 3D scatter plot for documents in the topic-document  matrix."""
function plottopics(data3d; ht = 500)
	lyt = Layout(title = "Documents in topics space reduced to 3 dimensions",
	height  = ht)
	plot3 = scatter(x = data3d[1,:], y = data3d[2,:], z = data3d[3,:], mode = "markers", type = "scatter3d")
	Plot(plot3, lyt)
end

# ╔═╡ 2aa13650-2854-4f12-b150-1551fc276594
if isnothing(reduced) 
	nothing 
else
	# check limits on minimal data...
	plottopics(reduced, ht = 450)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CitableBase = "d6f014bd-995c-41bd-9893-703339864534"
CitableCorpus = "cf5ac11a-93ef-4a1a-97a3-f6af101603b5"
CitableText = "41e66566-473b-49d4-85b7-da83b66615d8"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
Orthography = "0b4c9448-09b0-4e78-95ea-3eb3328be36d"
PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
TextAnalysis = "a2db99b7-8b79-58f8-94bf-bbc811eef33d"
UMAP = "c4f8c510-2410-5be4-91d7-4fbaeb39457e"

[compat]
CitableBase = "~10.3.0"
CitableCorpus = "~0.13.4"
CitableText = "~0.16.0"
OrderedCollections = "~1.6.2"
Orthography = "~0.21.2"
PlotlyJS = "~0.18.11"
PlutoUI = "~0.7.52"
StatsBase = "~0.33.21"
TextAnalysis = "~0.7.5"
UMAP = "~0.1.10"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "ee6e98e4abbfc8a4bcce6e282e0f82b954b68a6c"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f83ec24f76d4c8f525099b2ac475fc098138ec31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.11"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Blink]]
deps = ["Base64", "Distributed", "HTTP", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Pkg", "Reexport", "Sockets", "WebIO"]
git-tree-sha1 = "b1c61fd7e757c7e5ca6521ef41df8d929f41e3af"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.8"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CitableBase]]
deps = ["DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "f6d5a0fa5a98895d06a805e09505988496da56ea"
uuid = "d6f014bd-995c-41bd-9893-703339864534"
version = "10.3.0"

[[deps.CitableCorpus]]
deps = ["CitableBase", "CitableText", "CiteEXchange", "DocStringExtensions", "Documenter", "HTTP", "Tables", "Test"]
git-tree-sha1 = "4a330dfda89fd43fe9f70827fb143695be64c42f"
uuid = "cf5ac11a-93ef-4a1a-97a3-f6af101603b5"
version = "0.13.4"

[[deps.CitableText]]
deps = ["CitableBase", "DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "79b2268cf41f03087e9fc9cd71f7e7cf9397cc90"
uuid = "41e66566-473b-49d4-85b7-da83b66615d8"
version = "0.16.0"

[[deps.CiteEXchange]]
deps = ["CSV", "CitableBase", "DocStringExtensions", "Documenter", "HTTP", "Test"]
git-tree-sha1 = "8637a7520d7692d68cdebec69740d84e50da5750"
uuid = "e2e9ead3-1b6c-4e96-b95f-43e6ab899178"
version = "0.10.1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "8a62af3e248a8c4bad6b32cbbe663ae02275e32c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "5372dbbf8f0bdb8c700db5367132925c0771ef7e"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c53fc348ca4d40d7b371e71fd52251839080cbc9"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.4"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataDeps]]
deps = ["HTTP", "Libdl", "Reexport", "SHA", "p7zip_jll"]
git-tree-sha1 = "6e8d74545d34528c30ccd3fa0f3c00f8ed49584c"
uuid = "124859b0-ceae-595e-8997-d05f6a7a8dfe"
version = "0.7.11"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DeepDiffs]]
git-tree-sha1 = "9824894295b62a6a4ab6adf1c7bf337b3a9ca34c"
uuid = "ab62b9b5-e342-54a8-a765-a90f495de1a6"
version = "1.2.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Dictionaries]]
deps = ["Indexing", "Random", "Serialization"]
git-tree-sha1 = "e82c3c97b5b4ec111f3c1b55228cebc7510525a2"
uuid = "85a47980-9c8c-11e8-2b9f-f7ca1fa99fb4"
version = "0.3.25"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "5225c965635d8c21168e32a12954675e7bea1151"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.10"

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

    [deps.Distances.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "3d5873f811f582873bb9871fc9c451784d5dc8c7"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.102"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "Base64", "Dates", "DocStringExtensions", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
git-tree-sha1 = "39fd748a73dce4c05a9655475e437170d8fb1b67"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "0.27.25"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "a20eaa3ad64254c61eeb5f230d9306e937405434"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.6.1"
weakdeps = ["SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "c6e4a1fbe73b31a3dea94b1da449503b8830c306"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.21.1"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

[[deps.HTML_Entities]]
deps = ["StrTables"]
git-tree-sha1 = "c4144ed3bc5f67f595622ad03c0e39fa6c70ccc7"
uuid = "7693890a-d069-55fe-a829-b4a6d304f0ee"
version = "1.0.1"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "5eab648309e2e060198b45820af1a37182de3cce"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.0"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

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

[[deps.Indexing]]
git-tree-sha1 = "ce1566720fd6b19ff3411404d4b977acd4814f9f"
uuid = "313cdc1a-70c2-5d6a-ae34-0150d3930a38"
version = "1.1.1"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43032da5832754f58d14a91ffbe86d5f176acda9"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.2.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Languages]]
deps = ["InteractiveUtils", "JSON", "RelocatableFolders"]
git-tree-sha1 = "85b0221304a723f3fc5221f33b471675e5f64e74"
uuid = "8ef0a80b-9436-5d2c-a485-80b904378c43"
version = "0.4.4"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

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

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LsqFit]]
deps = ["Distributions", "ForwardDiff", "LinearAlgebra", "NLSolversBase", "OptimBase", "Random", "StatsBase"]
git-tree-sha1 = "00f475f85c50584b12268675072663dfed5594b2"
uuid = "2fda8390-95c7-5789-9bda-21331edee243"
version = "0.13.0"

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

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

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

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "821e918c170ead5298ff84bffee41dd28929a681"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.17"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "MbedTLS", "Pkg", "Sockets"]
git-tree-sha1 = "0bdaa479939d2a1f85e2f93e38fbccfcb73175a5"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "1.0.1"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighborDescent]]
deps = ["DataStructures", "Distances", "Graphs", "Random", "Reexport", "SparseArrays"]
git-tree-sha1 = "b7d4bd2ab58f0c3a001fd6eedc2e0aac8e278152"
uuid = "dd2c4c9e-a32f-5b2f-b342-08c2f244fce8"
version = "0.3.6"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ceeda72c9fd6bbebc4f4f598560789145a8b6c4c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.11+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OptimBase]]
deps = ["NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "9cb1fee807b599b5f803809e85c81b582d2009d6"
uuid = "87e2bd06-a317-5318-96d9-3ecbac512eee"
version = "2.0.2"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Orthography]]
deps = ["CitableBase", "CitableCorpus", "CitableText", "Compat", "DocStringExtensions", "Documenter", "OrderedCollections", "StatsBase", "Test", "TestSetExtensions", "TypedTables", "Unicode"]
git-tree-sha1 = "2c7ad8379d41a57687b95d8e21a48a7145c6b77a"
uuid = "0b4c9448-09b0-4e78-95ea-3eb3328be36d"
version = "0.21.2"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "66b2fcd977db5329aa35cac121e5b94dd6472198"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.28"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "3db9e7724e299684bf0ca8f245c0265c4bdd8dc6"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.11"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "e47cd150dbe0443c3a3651bc5b9cbd5576ab75b7"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.52"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9ebcd48c498668c7fa0e97a9cae873fbee7bfee1"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.1"

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

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "04bdff0b09c65ff3e06a05e3eb7b120223da3d39"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.Snowball]]
deps = ["Languages", "Snowball_jll", "WordTokenizers"]
git-tree-sha1 = "d38c1ff8a2fca7b1c65a51457dabebef28052399"
uuid = "fb8f903a-0164-4e73-9ffe-431110250c3b"
version = "0.1.0"

[[deps.Snowball_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ff3a185a583dca7265cbfcaae1da16aa3b6a962"
uuid = "88f46535-a3c0-54f4-998e-4320a1339f51"
version = "2.2.0+0"

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

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.SplitApplyCombine]]
deps = ["Dictionaries", "Indexing"]
git-tree-sha1 = "48f393b0231516850e39f6c756970e7ca8b77045"
uuid = "03a91e81-4c3e-53e1-a0a4-9c0c8f19dd66"
version = "1.2.2"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore"]
git-tree-sha1 = "0adf069a2a490c47273727e029371b31d44b72b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.6.5"
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

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StrTables]]
deps = ["Dates"]
git-tree-sha1 = "5998faae8c6308acc25c25896562a1e66a3bb038"
uuid = "9700d1a9-a7c8-5760-9816-a99fda30bb8f"
version = "1.0.1"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "a1f34829d5ac0ef499f6d84428bd6b4c71f02ead"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TestSetExtensions]]
deps = ["DeepDiffs", "Distributed", "Test"]
git-tree-sha1 = "3a2919a78b04c29a1a57b05e1618e473162b15d0"
uuid = "98d24dd4-01ad-11ea-1b02-c9a08f80db04"
version = "2.0.0"

[[deps.TextAnalysis]]
deps = ["DataStructures", "DelimitedFiles", "JSON", "Languages", "LinearAlgebra", "Printf", "ProgressMeter", "Random", "Serialization", "Snowball", "SparseArrays", "Statistics", "StatsBase", "Tables", "WordTokenizers"]
git-tree-sha1 = "c9d2672253ef9196769e2931efb57fd768d24158"
uuid = "a2db99b7-8b79-58f8-94bf-bbc811eef33d"
version = "0.7.5"

[[deps.TranscodingStreams]]
git-tree-sha1 = "7c9196c8c83802d7b8ca7a6551a0236edd3bf731"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.0"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.TypedTables]]
deps = ["Adapt", "Dictionaries", "Indexing", "SplitApplyCombine", "Tables", "Unicode"]
git-tree-sha1 = "d911ae4e642cf7d56b1165d29ef0a96ba3444ca9"
uuid = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"
version = "1.4.3"

[[deps.UMAP]]
deps = ["Arpack", "Distances", "LinearAlgebra", "LsqFit", "NearestNeighborDescent", "Random", "SparseArrays"]
git-tree-sha1 = "accad220f075445f68caa6488be728957a5d82d6"
uuid = "c4f8c510-2410-5be4-91d7-4fbaeb39457e"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "0eef0765186f7452e52236fa42ca8c9b3c11c6e3"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.21"

[[deps.WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "4162e95e05e79922e44b9952ccbc262832e4ad07"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.6.0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WordTokenizers]]
deps = ["DataDeps", "HTML_Entities", "StrTables", "Unicode"]
git-tree-sha1 = "01dd4068c638da2431269f49a5964bf42ff6c9d2"
uuid = "796a5d58-b03d-544a-977e-18100b691f6e"
version = "0.5.6"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

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
# ╟─ffb548e0-71b5-4ead-9033-9c44ca70b22a
# ╟─c0543064-597c-4104-b26a-333437ddf4d8
# ╟─0c6337e6-4de7-4e76-9589-42bc170a931a
# ╟─6d24ec36-6d02-11ee-24af-7f32effe1a76
# ╟─082b0f1f-12b2-4f09-be8f-4e2cbf35d714
# ╟─f0bd2768-68bd-4535-b90e-34359b3030f9
# ╟─e2ea0057-9a4c-4ddf-985a-e107fb3b0b38
# ╟─fcef1df7-4cac-4be1-9e98-67b835d81fb8
# ╟─0e6f70dc-2da6-43f1-9ded-66dcaa92877d
# ╟─c6b5a24b-3f29-49e2-b64b-8761854ec503
# ╟─60af1314-1b94-43af-954e-f1f984582144
# ╟─df880285-50a9-4a18-9203-0971b3e45924
# ╟─dceb616c-e86d-40f9-815b-d8acbf2744f0
# ╟─423c2f39-5e1a-4751-989f-b68003d061d4
# ╟─94672682-2e7e-4f70-b335-01f09f603add
# ╟─3044d17c-b365-402a-a276-f3d4ae807cb5
# ╟─99b012eb-6f17-403e-b541-c1497ee1e7e5
# ╟─2733adb5-8dfd-4df9-8e28-5aa6dae9c175
# ╠═2350681e-861a-4f51-b4ca-1d0e29311b1f
# ╠═8d5f6c03-a776-4304-9b5f-dfd9c235edbd
# ╠═4b742534-045e-43ce-96c1-9ad1587fba80
# ╠═1fbd8ebc-adaa-4d42-b65f-291faac7633e
# ╟─1bce7141-c7db-4a86-ac1a-36bff54edc86
# ╟─5fc19dbc-3f3b-41fb-b560-c67c04a3190b
# ╟─084082de-30f5-43a6-9a78-a4e7d2ec99e7
# ╠═7d740f6c-9430-4367-90a6-32933c3b4cd7
# ╟─2aa13650-2854-4f12-b150-1551fc276594
# ╠═0aad525c-1a6d-4a33-a046-1704fb0cbc36
# ╟─952ff6a6-b67b-4e0b-b80d-93d10a1d9a86
# ╟─45c8ba32-fda0-41e4-9c76-528d191fc298
# ╠═0e1fc056-c946-4c53-a046-69c6edec3044
# ╟─ec514c67-d35a-42aa-b2c0-cd56ba105c51
# ╟─c9e0e222-200f-400e-9831-780133df3253
# ╟─57779e81-b2c9-4067-a675-4de47646556d
# ╟─d6c59846-88d1-48d8-9405-67bac12c5eeb
# ╟─8a2f14b8-6fb3-49f3-b161-e06ffe32108a
# ╟─7214e92f-9bfa-42c2-b970-c1799f072d65
# ╟─fc12e5a6-6451-4b1e-8300-6d115c94cf66
# ╟─d82bbca8-e3bc-45fe-b473-fb86e7995650
# ╟─280de380-2dd0-4a88-b042-9767921a67d6
# ╟─e8ef7ca6-5910-421d-9892-c3d999937875
# ╟─f50104d7-1c06-4813-bc86-1a6d4167d309
# ╠═d87e8ba9-2ff2-4bd5-b696-77af0e9b0303
# ╠═543080bf-fa45-42ba-89db-1ba06f2c0f41
# ╟─b2f4f562-63e7-4055-90d5-cc0d3f5c75ab
# ╟─e57a1d64-d14a-44ea-92b5-bd7d73c61aed
# ╠═7c3d0dfc-6bf2-4b1a-848e-ecb07a298048
# ╟─ab7df6f8-2f79-4ee2-bf94-dcba9a1cfe3a
# ╟─2ee1af26-c722-4874-a497-3dcd2d9d39fd
# ╟─89d1bd74-3e0b-4ef7-b4ed-d0923c00845f
# ╟─2547227f-99f2-49c6-a8d6-c1dbdda24fd9
# ╟─2e0e0119-32b5-46f3-aea7-7a447878ce33
# ╟─dbab6c6e-8016-487a-887a-255c2f25b02e
# ╟─f59dba8a-03d4-4a85-a994-de832e8ddf5f
# ╟─863fd7c4-5460-4de0-b422-fa38350f7545
# ╟─42ae6aed-d949-47fa-8aa2-ae35eb79c29e
# ╠═3fede1f1-4bf3-48e0-82ec-203fd936199e
# ╠═fd23b519-3d5f-4a88-931c-a3118fbc256e
# ╟─a7917f32-8d08-4d3e-a34d-4cedbb5b9649
# ╠═68dc297d-ccd0-4dd1-a652-f19cfcd3c111
# ╠═1623909b-1c27-4cac-8cbe-4287ed3e30e8
# ╠═5827632f-bd27-4658-a42b-d8fb7ff3e8bb
# ╟─0439bf2f-69a1-4aa8-a71a-dd058ebf5bfe
# ╠═9c3ce649-4b24-476b-9798-386b5712000b
# ╠═623099bd-d8fa-452c-b9f2-52e2940a0fb8
# ╟─cb07ecaa-f7f1-4495-a51b-9308d7b5ddf5
# ╠═cdb90b88-a4f1-4669-a2fc-abfef3a78933
# ╠═359e8801-9361-43a1-a0de-dbebb572437c
# ╠═cd4b1dc2-3b5f-4b27-9db8-7890c2ad7e07
# ╠═8eff85fd-02ce-46ec-ba59-3208e73400fb
# ╠═b34d675c-9f1a-49da-a4e1-54c1c1d1dcf0
# ╠═4ae018f9-2e20-474b-a99a-964e5d3d6887
# ╠═22cc0a3f-bbd6-483e-b407-ef56c8dba75f
# ╟─7be14d53-9eaa-482f-b9f8-870154ab7c52
# ╟─d0a12142-20fa-42ac-b220-cf7bca4a5be4
# ╠═54bb7773-bd62-4cc0-9e19-35fc088a1a1f
# ╠═a1db21b6-6d6f-4dcd-a0e2-f538d3a25a13
# ╟─0ef282af-f9a3-43c4-85c4-5e6478d0906b
# ╟─599af10b-51ee-40a2-a69d-5338e596a3a7
# ╟─1dddb425-2577-43f9-b4c8-9b5dd2dd912e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
