using TextAnalysis

using StatsBase
using OrderedCollections

using CitableBase, CitableCorpus, CitableText
using Orthography





function ta_structs_from_corpus(citecorp; lc = true, stoplist = [])

	
	corp = map(psg -> StringDocument(psg.text), citecorp.passages) |> Corpus
    
	prepare!(corp, strip_punctuation)
	remove_words!(corp, stoplist)

    update_inverse_index!(corp)
	update_lexicon!(corp)
	
	
	(corp,  lexicon(corp), DocumentTermMatrix(corp))
end



text_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/grant-hyginus.cex"

citecorp = fromcex(text_url, CitableTextCorpus, UrlReader)



c = map(psg -> CitablePassage(psg.urn, lowercase(psg.text)), citecorp.passages) |> CitableTextCorpus

	
corp = map(psg -> StringDocument(psg.text), c.passages) |> Corpus

prepare!(corp, strip_punctuation)
update_inverse_index!(corp)	
update_lexicon!(corp)

ta_corpus = corp
lex = lexicon(ta_corpus)
dtmatrix = DocumentTermMatrix(ta_corpus) 


k = 12

phi, theta = lda(dtmatrix, k, 1000, 0.1, 0.1)


function top_terms(row, termlist; n = 10)
	sorted = sort(row, rev = true)
	termvalpairs = []
	for val in sorted[1:n] 
		rowidx = findfirst(col -> col == val, row)
		push!(termvalpairs, (termlist[rowidx], val))
	end
	termvalpairs
end


function hdr(n)
	rowval = ["| topic "]
	for i in 1:n
		push!(rowval, "| $(i) ")
	end
	join(rowval) * "|" 
end


"""Make a Markdown table to display list of top terms for a topic.
"""
function topterms_md(topictotermscores, termlist, termcount, k = k)
	lines = [hdr(termcount)]
	push!(lines, repeat("| --- ", termcount + 1) * "|")
	
	for i in 1:k
		bigterms = top_terms(topictotermscores[i,:], termlist; n = termcount)
		push!(lines, "| topic $(i) |" * join(map(pr -> pr[1], bigterms), " |"))
	end
	join(lines,"\n")
end

open("termtab.md", "w") do io
write(io, topterms_md(phi,dtmatrix.terms, 10))
end


function raw_pairs(row, termlist; n = 10)
	sorted = sort(row, rev = true)
	termvalpairs = []
	for val in sorted[1:n]	
		rowidx = findall(col -> col == val, row)
		push!(termvalpairs, (termlist[rowidx], val))
	end
    termvalpairs
end

raw = raw_pairs(phi[3,:], dtmatrix.terms)


function isolatescores(scorelists, n = 10)
    flatresults = []
    names = map(pr -> pr[1], scorelists) |> Iterators.flatten |> collect |> unique
    for nameval in names[1:n]
        @info("Look at $(nameval)")
        score = filter(pr -> nameval in pr[1], scorelists)[1][2]
        @info("Got $(score)")
        push!(flatresults,(nameval,score))
    end
    flatresults
   
end

isolatescores(raw)



println(join(raw, "\n"))