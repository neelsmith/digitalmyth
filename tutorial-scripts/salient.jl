using TextAnalysis
using Downloads

apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/apollodorus-topos.txt"


function ta_structs_from_ul(u)
	tmp = Downloads.download(u)
	corp = map(s -> StringDocument(s), readlines(tmp)) |> Corpus
    rm(tmp)

    update_inverse_index!(corp)
	update_lexicon!(corp)
	
	(corp,  lexicon(corp), DocumentTermMatrix(corp))
end


(c, lex, dtmatrix) = ta_structs_from_ul(apollodorus_url)



