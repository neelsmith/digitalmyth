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

# ╔═╡ 1f84b8d6-4f2d-4fe9-bdfc-e7dcc3d70aaa
begin
	using PlutoUI, PlutoTeachingTools
end

# ╔═╡ 11e83ae9-6869-4541-a52d-cf253a760536
using Downloads

# ╔═╡ da5ebca9-965c-4d54-b3d9-70f43e049652
using CitableBase

# ╔═╡ 5b22c312-d668-4301-8e15-0649c04a2335
using StatsBase

# ╔═╡ 6eefe1c9-b3de-4a4a-aae3-461e7919cc36
using OrderedCollections

# ╔═╡ 713b7920-6d87-47cb-b097-d4deb08b5a58
using PlotlyJS

# ╔═╡ 7368f682-06e3-4f21-85be-740179763de2
TableOfContents()

# ╔═╡ 6ed35212-af84-11ec-2c60-cd3e7a4ec044
md"""
# Pluto notebook 3: exploring n-grams
"""

# ╔═╡ 5631d29a-a810-46db-bd8e-09722527b57a
md""" ## Before you start: authors
"""

# ╔═╡ 588eb909-2f02-4c13-9a62-a63be78f44b1
team = ""

# ╔═╡ 1c3ab571-4adb-4e0c-8ac4-1156b40b2149
if isempty(team)
	still_nothing(md"Assign to the variable `team` a single string with a list of all members of your group.")
end

# ╔═╡ 904d2e7e-0439-4de1-8178-8ce1daca1a44
md"""> ## Overview of assignment
>
>This Pluto notebook will guide you through computing n-gram frequencies in English translations of Apollodorus and Hyginus.  We'll prepare a tidy text to analyze, break it up into n-grams, count the frequenceis of the n-grams, and plot a bar chart of the counts.
>
"""

# ╔═╡ 9f944b0d-a630-4dda-af2c-351d897c1994
md"""## Prepare data for analysis"""

# ╔═╡ 3a958d40-97f7-4143-809b-50d8ebb911c1
md"""> **Instructions**: We'll work again with texts of Apollodorus and Hyginus.  
> We'll need to download and read the texts, then tidy them up to prepare them for analysis.
>
> We'll write a function for each of those two steps:
>
> 1. read string data from a URL
> 2. tidy up the string for analysis
>
> The notebook has already set up for you a menu where users can select a URL for one of the texts, which is assigned to the variable `text_url`.
"""

# ╔═╡ 46cf8696-684d-411a-a6aa-b6b79679b55d
md"""### Read string data from a URL"""

# ╔═╡ afa6c677-6850-4fcf-9ded-513c4e76e27a
md"""
Begin by writing a function that downloads a text and reads the complete contents as a String value.  You've done this before: reuse your earlier function by replacing `nothing` in the body of the `read_url` function with appropriate Julia code.
"""

# ╔═╡ 6d58c1dc-f26c-464b-8c53-0e6f4e877b4a
md"""Recall that we'll need to use the `Downloads` package:"""

# ╔═╡ 67683cc9-0e2a-4a7b-8f04-b1350b60cf97
"""Download a URL `u` and read its contents as a String value.
Be tidy and remove any temporary files you create!
"""
function read_url(u)
	nothing
end

# ╔═╡ b4b2396f-af4b-45bf-a92c-080fbe336b2d
md"""### Tidy up data we've read"""

# ╔═╡ a85a7304-2a81-4021-aa9e-83bc3c129e78
"""Remove punctuation characters from string `s`
and convert the result to all lower case.
"""
function tidytext(s)
	nothing
end

# ╔═╡ 1377097e-c414-48be-b696-b017dfd39cd5
begin
	testtidy = tidytext("Hey! This, right here, is not complicated.")
	if isnothing(testtidy)
		still_missing(md"In the body of the `tidytext` function, replace `nothing` with appropriate Julia code.")
		
	elseif length(testtidy) != 38
		keep_working(md"I did not find the number of characters I expected in your function's output.")


	else
		caseok = testtidy == lowercase(testtidy)
		
		local punctok = true
		for c in testtidy
			if ispunct(c)
				punctok = false
			end
		end

		
		if ! punctok
			still_missing(md"I'm still finding punctuation characters in the output of your `tidytext` function.")
			
		elseif ! caseok
			still_missing(md"I'm still finding punctuation characters in the output of your function.")	
		else	
			correct(md"Excellent! Your function is correctly tidying up test tidy.")
		end
	end
end

# ╔═╡ 3f685ace-5e2d-445f-8b49-d69298c98dfe
md"""## Count n-grams"""

# ╔═╡ a2b3a047-df87-4e03-a2c9-c445bcb52d5c
md""">**Instructions**
>
> Next we want to count n-grams in our tidied-up text.  We'll take advantage of functions from external packages to:
>
> 1. find n-grams from a list of words (the `slidingwindow` function)
> 2. create a dictionary counting how often each n-gram occurs (the `countmap` function)
> 3. and finally create an ordered dictionary (`OrderedDict`)



"""

# ╔═╡ 1f8363a5-ec4f-439d-a88b-e772a7039545
md"""To let the notebook user choose a size for `n`, we'll use a slider to assign a value to the variable `n`:"""

# ╔═╡ a8147f92-218b-4ec2-92c5-b889c1d96194
md"""*n-gram size*: $(@bind n Slider(1:15; default=3, show_value=true))"""

# ╔═╡ e6f261f1-88fd-406c-936c-d627772f3dab
md"""Check that the slider works as expected:  try sliding it to different values, and watch how the variable `n` changes in the next cell."""

# ╔═╡ b19c8354-e2d9-4af1-9162-3514ecd40420
n

# ╔═╡ 16a49e39-d634-44c4-b1e9-745650baf967
md"""### Partitioning the text into n-grams"""

# ╔═╡ 1919af32-03a0-4dad-b821-f15629639650
md"""To turn our tidied-up text into n-grams, we'll first use the `split` function to turn it into a list of words.

Again, we'll be cautious in the next cell, and make sure that we already created a value before we try to split it up.
"""

# ╔═╡ a216aa00-c65a-422a-ab22-03dd8f7b565a
md"""Conceptually, what we want to do is "slide a window" over the list.  If we're looking for 3-grams, we'll look first at items 1-3, then at items 2-4, then items 3-5, etc.

The `CitableBase` package has a function, `slidingwindow` that does exactly that! Look at the following examples.
"""

# ╔═╡ d70c9e6b-92a4-4ebf-86fe-01f991358f03
md"""We can use `slidingwindow` on any kind of Vector. Here's Vector of characters."""

# ╔═╡ 4598e66a-cb12-429d-aa9a-2d48a924e889
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g']

# ╔═╡ 235090e1-b1de-4303-a4f0-ada9cf1a5a0c
md"""By default, `slidingwindow` uses a window that is 2 elements wide, but you can  set that size to anything you like with an optional `n` paramter.  Compare:"""

# ╔═╡ 02191e15-ec2f-44d8-9dc4-e7ff9fc4d3bc
slidingwindow(letters)

# ╔═╡ f3cde397-fef4-464f-9a22-5c7e32afd4fd
slidingwindow(letters, n = 3)

# ╔═╡ 439be2c9-303b-418b-8c86-9711b83fc7ab
md"""In the following cell, replace `nothing` with an invocation of `slidingwindow`.  Include the optional `n` parameter to set the window size; use the variable `n` that is assigned by the slider earlier in this notebook!

"""

# ╔═╡ 56320370-a221-482a-8a38-398e566e4e93
windowlist = []

# ╔═╡ 7d33c73e-93c4-4606-a6a3-05fe4419a87e
begin
	
	if isempty(windowlist)
		still_missing(md"Replace the empty brackets on the right side of the assignment statment with an invocation of `slidingwindow`.")
	elseif ! isa(windowlist, Vector)
		keep_working(md"`windowlist` should be a Vector, but it's not. Check your work")
	else
		correct(md"OK:  you've created a Vector with some values in it.")

	end
end

# ╔═╡ b569f847-cbd5-4f88-a313-38a56cd6490e
md"""### Counting frequencies"""

# ╔═╡ 92a8f7c6-9c14-441f-aa9b-2e64f55ae893
md"""We now have a list of n-grams for our selected text. We can easily count their frequencies with another function from an external package:  `countmap` in the `StatsBase` package.  Recall from class preparation that `countmap` creates a dictionary of keys and values.

"""

# ╔═╡ 55492d75-125c-4e4a-b63c-24ded33391f9
md"""To illustrate, let's split a string into words and count them:"""

# ╔═╡ 6d66bd5d-0994-4f8a-bcf2-4387867f03af
samplewords = split("The best time of the day is any time of the day.")

# ╔═╡ abd2ba26-dd5c-49d0-8be1-c15a8f9052d6
countmap(samplewords)

# ╔═╡ 736f775b-d146-421a-9dd8-b2e2a61cd3b9
md"""Our ngrams are currently structured as lists of strings.  Counting and working with them will be simpler if we convert them to strings.  If we represent a list of words ["now", "is", "the"] as a single string "now_is_the", we can still easily see the ngram structure and have simple strings to work with instead of lists.

Remeber that the Julia `join` function converts lists to a single String.
"""

# ╔═╡ 44a1935f-89a8-411e-8141-16db70caaf87
join(["a", "b", "c"] )

# ╔═╡ 3af156e4-7f9a-4cec-8725-7a3fd6faf9e0
md"""And remember as well that you can include an optional second parameter with string to use in joining the elements."""

# ╔═╡ 0a22fb78-a789-4517-8604-207c5516f929
join(["a", "b", "c"], "_" )

# ╔═╡ 0d261812-6b35-4305-b07e-497e63f833bd
md"""Let's try the same thing with the first n-gram in our list"""


# ╔═╡ fb5affcb-3670-4e6f-bada-0c3f8d30b89a
if isempty(windowlist)
else
	join(windowlist[1], "_")
end

# ╔═╡ b1757a53-2121-4afa-a52d-88c5eecf65df
md"""Of course we really want to apply that `join` function to *every* element of `windowlist`. At this point, that might sound like a `map` idea to you! In the following cell, replace `nothing` with an invocation of `join`.
"""

# ╔═╡ 35ba0994-3700-4913-be6d-603bfcf6ecff
ngramstrings = map(window -> nothing,  windowlist)

# ╔═╡ d0d88d54-8a0d-402e-9bc5-3427e1cbdc5f
if isempty(ngramstrings)
	still_missing(md"You need to have some data in `windowlist` before you can convert that data to strings.")
elseif isnothing(ngramstrings[1])
	still_missing(md"""DO IT""")
else
	correct(md"OK:  you've created a Vector with some values in it.")

end


# ╔═╡ ca777505-e414-428a-b2ea-37d990b87184
md"""
So now we're in a position to create a dictionary counting those ngrams.
"""

# ╔═╡ 71be0695-d3bb-4b62-b15f-49b79c2fe4b2
ngramcounts = countmap(ngramstrings)

# ╔═╡ 9ecef615-4a09-4eaa-a954-cec7469a44bf
md"""As we saw in class, dictionaries in Julia have no order, but for our purposes it would be convenient to be able to sort a dictionary of ngrams by their frequencies.  The `OrderedCollections` package lets us create an *ordered* dictionary from a generic Julia dictionary.
"""

# ╔═╡ 07dfbfb4-2ce6-4d37-afd2-95b074b8b76f
 orderedngrams = ngramcounts |> OrderedDict

# ╔═╡ ac75a654-67fe-4c08-a81a-f7a0925e61f7
md"""Finally, we want to take advantage of the fact that we can sort ordered dictionaries. By default, Julia's sort function sorts an ordered dictionary on its key value -- in our case, that would be alphabetically sorted by the n-gram string.  But we want to sort by the corresponding value.  We can set that by setting an optional `byvalue` parameter to true.

Additionally, `sort` will sort our numeric counts in ascending order from smallest to largest by default.  We can reverse that by setting an optional `rev` parameter to true.
"""

# ╔═╡ abcfa7d1-60dd-49c1-9052-2f5079886f9e
sortedngs = sort(orderedngrams, rev=true, byvalue=true)

# ╔═╡ 5ce13b44-c088-449a-8bad-2be5f3992acb
md"""## Plot results"""

# ╔═╡ bc2b3015-44e1-4b0b-b99b-44790574be46
md"""> **Instructions**: Our final step will be to visualize our n-gram frequencies as a *histogram* by plotting the sorted frequencies as a bar chart. To do that we will:
>
> 1. Extract the keys and values from our frequencies dictionary into separate Vectors to serve as the `x` values and `y` values, respectively, of our bar chart.
> 2. Write a function to plot the bar chart, with parameters allowing the user to interactively adjust the height and width of the plot.
>
"""

# ╔═╡ 1a8762d5-7a63-40b6-bfd1-093a6ec24df8
md"""### Isolating Vectors of `x` and `y` values"""

# ╔═╡ f038fc61-228b-4801-b2d9-711ea7b59998
md"""To extract keys and values from a dictionary, Julia provides functions with the obvious names `keys` and `values`.  The values they extract are not organized as Vectors, however, and that's what we want to use to plot our chart.  Julia's `collect` function will gather the content into a Vector for us.  Here's an example.
"""

# ╔═╡ a5992d8c-1476-40ab-b08c-cc56742b1515
md"""Here's a dictionary counting words in our sample list (above)."""

# ╔═╡ 5256a4b7-b6fa-483f-a409-f904d204df75
samplecounts = countmap(samplewords)

# ╔═╡ 9fc299c9-dd6f-4a25-a3b9-5dc16e740e89
md"""The `keys` pulls out all the keys in the dictionary, and organizes them as a `KeySet`."""

# ╔═╡ 5ec92fdd-5108-42f3-9030-00e075878123
keys(samplecounts)

# ╔═╡ 830f060a-6559-4c91-962c-e122242103b1
md"""With the `collect` function, we can gather them into a Vector. (Notice that the display of values in the next cell lists string values beween square brackets, the normal notation for a Vector.)"""

# ╔═╡ 5ee22ed3-0575-4842-ae82-479d11ac088e
keys(samplecounts) |> collect

# ╔═╡ d0b3c3b4-1eda-456a-966a-fb8f417a8aff
md"""The `values` function works analogously."""

# ╔═╡ 7b87ce8c-06f1-49d5-a69d-7b66730d4dfb
values(samplecounts) |> collect

# ╔═╡ 70f78c5f-5274-40bc-8e24-134ad329859c
md"""In the following cell, replace the square brackets with an expression to collect all the *keys* of your word frequency dictionary."""

# ╔═╡ 4303b736-9301-4b07-bf1e-26d8700ac318
xvals = []

# ╔═╡ 8a88cf85-96a0-4ec0-8792-4a9d519b38ce
if isempty(xvals)
	still_missing(md"You need to build the dictionary of frequency counts and assign a Vector of its keys to `xvals`.")
else
	correct(md"OK:  you've created a Vector with some values in it.")
end

# ╔═╡ 888ff334-773f-4e2a-9d51-3b888ec7805d
md"""In the following cell, replace the square brackets with an expression to collect all the *values* of your word frequency dictionary."""

# ╔═╡ 390d1378-b915-48b4-a558-f434e4f6e913
yvals = []

# ╔═╡ d47f1e0f-1300-4316-a32c-4927cf3b5a9a
if isempty(yvals)
	still_missing(md"You need to build the dictionary of frequency counts and assign a Vector of its values to `yvals`.")
else
	correct(md"OK:  you've created a Vector with some values in it.")
end

# ╔═╡ 3a4a78f6-5a32-4ccf-a5f7-d9a8a0871e5c
md"""### Plotting the frequencies"""

# ╔═╡ da248d27-ad9b-4808-88a3-471cae0a72ad
md"""Our final step is to plot `xvals` and `yvals` as a bar chart.  Julia has several good plotting package; for this notebook, we'll use `PlotlyJS` which is especially handy for interactive environments like Pluto notebooks and editing sessions in Visual Studio Code.
"""

# ╔═╡ 8712f3cc-fbef-4ef5-adde-aa807fe0af51
md"""We'll create a `Plots` object.  The simplest option is simply to provide a Vector of `x` values and a Vector of `y` values. For this graph, however, the result is difficult to read.

"""

# ╔═╡ 4299e723-0ff1-4597-84c5-eb6d39dff736
 if isempty(xvals) | isempty(yvals)
 else
 	Plot(xvals, yvals)
 end

# ╔═╡ 0804074e-91ac-47cb-88de-a56f3c9a90e6
md"""
The first improvement we'll make is to limit the number of ngrams we graph: since, in accordance with Zipf's Law, the frequencies quickly flatten out to single instances, instead of plotting *all* of the ngrams, we'll plot only the first, most frequent ones.  

The next cell creates a slider that assigns a value to variable named `maxdisplay`.  
"""

# ╔═╡ d56c84c1-4256-431f-9dce-e1f134d7d583
md"""*Number of n-grams to display*: $(@bind maxdisplay Slider(50 : 10 : 500; default=100, show_value=true))"""

# ╔═╡ 098be01b-6fa9-4aba-bf69-fe952e360588
maxdisplay

# ╔═╡ df9998ed-5ec1-4fd7-bc47-3f628d7ead57
md"""Now, in the next cell, instead of providing the full Vector of x and y values, provide only the the entries from 1 up to `maxdisplay` values.  In the following cell, replace `nothing` with an invocation of `Plot` that works on the first elements of both x and y Vectors. 

> ⚠️ Make sure you provide identical length Vectors for both x and y.
"""

# ╔═╡ c872e2de-87ed-47f3-91ab-8a727aac4db5
 if isempty(xvals) | isempty(yvals)
 else
 	nothing # Plot(some shorter x vector?, some shorter y vector?)
 end

# ╔═╡ 06d0fd50-0173-4bd8-b8e5-f30e89d56c5c
md"""For more control over the appearance of our graph, we'll take a slightly different approach.  In `PlotlyJS`, we can create separate objects for the *plot* (in our case, a bar chart), and the *layout* of the graph.  Here is an example.
"""

# ╔═╡ 2165d5ec-c3c6-4ac5-b9b0-9d678329a1e9
md"""The `bar` function creates a bar chart.  We can give it the same Vectors of x and y data that we used with `Plot` above, but with the `bar` function, we need to use named parameters.
"""

# ╔═╡ e5f7b364-c68a-4faf-9e25-f2ce8407277a
barplotted = bar(x = xvals, y = yvals)

# ╔═╡ fe70e872-cf12-429b-9ef6-98f9e887af7f
md"""We can include many optional parameters to create a  `Layout`. The `title` parameter, for example, adds a title string to the final plot.

"""

# ╔═╡ 6bb815c2-a52a-4cbb-9768-65a49724a190
graphlayout = Layout(title = "n-gram frequencies")

# ╔═╡ 1b093351-18e4-41dd-96c6-c44d64aa59fe
md"""The following cell shows how you `Plot` can also be used with two parameters, for the plot object and the layout object we created."""

# ╔═╡ 4ce2cc1d-e354-40e4-9837-3eea197f8747
if isempty(xvals) || isempty(yvals)
else
	Plot(barplotted, graphlayout)
end

# ╔═╡ d8aa8853-8687-4b19-be1c-eb18a79989a5
md"""One easy improvement to the appearance of your graph is to allow users to adjust the size.  The following two sliders create variables named `h` and `w` that we can use for the height and width of the graph's display.

Adjust the sliders, and see how the values of `h` and `w` change.
"""

# ╔═╡ 89eedbf8-6a5a-4828-9384-6277bd1ef1a8
md"""*Plot height (pixels)*: $(@bind h Slider(200 : 10 : 800; default=500, show_value=true))"""

# ╔═╡ ab4d39bf-91c8-4c49-9864-87d480b419f9
md"""*Plot width (pixels)*: $(@bind w Slider(100 : 10 : 1200; default=500, show_value=true))"""

# ╔═╡ facedc34-5d42-41d7-83c5-41b73a35d84f
(h,w)

# ╔═╡ de311bd4-0cda-45f7-9b30-39878dac8d00
md"""You can also include parameters to `Layout` named `height` and `width` that specify the height and width of your plot.  In the following cell, include those parameters as well as the `title` parameter; use `h` and `w` for their values.
"""

# ╔═╡ e60a81de-fd9b-417f-8c1e-a337d124fc36
betterlayout = Layout()

# ╔═╡ 809db002-acba-4773-bb9f-83fc8b7ba71d
Plot(barplotted, betterlayout)

# ╔═╡ d972f781-886d-46dd-90bb-1a607d6e078b
md"""
Experiment with different values for `h` and `w`, and notice how changing the proportion of the display can exaggerate or minimize the visualize impact of the data.

Suggest optimal values for height and weight here:
"""

# ╔═╡ b86c7648-36d0-4a81-a287-d53726797231
optimal_h = 0

# ╔═╡ 3394e128-0642-4bce-adbc-3c9c82981cc2
optimal_w = 0

# ╔═╡ e705a6d0-6a6a-4ef7-b324-2638d9b7d0da
md"""## What does it mean?"""

# ╔═╡ cd8ffca2-e2d7-4c45-8025-bc0d88255595
md""">**Instructions** Your group should add an interpretation of one or more observations you made about one or both texts using the `n-gram` explorer you have written. 

The  final cell in this notebook defines a string valoue named `interpretations`. The assignment statement uses a Julia triple-quoted string, and includes some formatting using markdown. Please document your group's thoughts by replacing the question marks `??` cell with the following content:
 
- what size n-gram resulted in a meaningful observation or observatins? 
- what text does your observation apply to?  (Apollodorus, Hyginus, or both?)
- summarize one or more observations you made using your n-gram explorer
- what interpretation(s) can you offer for the observations you selected?
"""


# ╔═╡ 2cfeabbf-f030-4062-96c0-fd5289f75501
interpretations = """

**Size of n-gram**: ??

**Text you analyzed**:  ??

**Observation(s)**: ???

**Interpretation(s)**: ??

"""

# ╔═╡ 3450635d-7a28-40cd-b78d-d353c25fce5e
interpretations |> Markdown.parse

# ╔═╡ a98b7fe3-feb6-45ff-9367-6e4c32a685b3
 if isempty(xvals) | isempty(yvals)
 else
 	Plot(xvals[1:maxdisplay], yvals[1:maxdisplay])
 end

# ╔═╡ 9f027a28-f712-45d7-8462-20cce79b595e
html"""
<br/><br/><br/><br/><br/><br/><br/><br/>
"""

# ╔═╡ d4bcb39f-23bf-4b2a-ac16-23292eccba2f
html"""
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ 42e009fc-5412-4da6-bc52-5065110edb9a
md"""> #### *Stuff you don't need to look at to complete this assignment*"""

# ╔═╡ ccfeab02-2bce-4aae-800f-a8660a069927
hyginus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/grant-hyginus.txt"

# ╔═╡ aac68d98-b5d8-48c1-972a-3cc431b8e971
apollodorus_url = "https://raw.githubusercontent.com/neelsmith/digitalmyth/dev/texts/apollodorus-topos.txt"

# ╔═╡ 633eb320-30e8-457f-b30d-d648fd2558ef
begin
	teststringreading = read_url(apollodorus_url)

	if isnothing(teststringreading)
		still_missing(md"In the body of the `read_url` function, replace `nothing` with appropriate Julia code.")
	elseif ! (teststringreading isa String)
		keep_working(md"The value you return from `read_url` should be a String value, not $(typeof(teststringreading)).")
			
	elseif length(teststringreading) != 215177
		keep_working(md"Something's not right: your function created a String of the wrong length.")
		
	else
		correct(md"Great! Your function downloaded and read a document correctly!")
	end
end

# ╔═╡ a0080ee8-0d50-49b3-90d2-263a57a30024
menu = ["" => "Choose a text", hyginus_url => "Hyginus", apollodorus_url => "Apollodorus"]

# ╔═╡ 95d7c11a-1e9a-424c-b7dc-83f42453d31d
@bind text_url Select(menu)

# ╔═╡ 40aa1ba7-a06f-4a44-81fb-5be57184bef1
text_url

# ╔═╡ b68483f8-0f72-4907-922b-33dce51d888f
fulltext = if isempty(text_url)
	""
else
	read_url(text_url)
end

# ╔═╡ ee83b946-8351-4fc0-9d03-058a0769d429
tidier = tidytext(fulltext)

# ╔═╡ 49fddcec-4b9a-4a36-b7f8-250652ad6fba
wordlist = if isnothing(tidier)
	[]
else
	split(tidier)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CitableBase = "d6f014bd-995c-41bd-9893-703339864534"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlotlyJS = "f0f68f2c-4968-5e81-91da-67840de0976a"
PlutoTeachingTools = "661c6b06-c737-4d37-b85c-46df65de6f69"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
CitableBase = "~10.3.0"
OrderedCollections = "~1.6.2"
PlotlyJS = "~0.18.10"
PlutoTeachingTools = "~0.2.13"
PlutoUI = "~0.7.50"
StatsBase = "~0.34.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "bb906fa8770727281df14739abe47fa2206e7deb"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

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
git-tree-sha1 = "88616b94aa805689cf12f74b2509410135c00f43"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.6"

[[deps.CitableBase]]
deps = ["DocStringExtensions", "Documenter", "Test", "TestSetExtensions"]
git-tree-sha1 = "f6d5a0fa5a98895d06a805e09505988496da56ea"
uuid = "d6f014bd-995c-41bd-9893-703339864534"
version = "10.3.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "a1296f0fe01a4c3f9bf0dc2934efbf4416f5db31"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

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
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

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

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

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
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

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
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "81dc6aefcbe7421bd62cb6ca0e700779330acff8"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.25"

[[deps.Kaleido_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "43032da5832754f58d14a91ffbe86d5f176acda9"
uuid = "f7e6163d-2fa5-5f23-b69c-1db539e41963"
version = "0.2.1+0"

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
git-tree-sha1 = "0a1b7c2863e44523180fdb3146534e265a91870b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.23"

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
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

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
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

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
git-tree-sha1 = "87c371d27dbf2449a5685652ab322be163269df0"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.15"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "MbedTLS", "Pkg", "Sockets"]
git-tree-sha1 = "0bdaa479939d2a1f85e2f93e38fbccfcb73175a5"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "1.0.1"

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
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9ff31d101d987eb9d66bd8b176ac7c277beccd09"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.20+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "2e73fe17cac3c62ad1aebe70d44c963c3cfdc3e3"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.2"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "478ac6c952fddd4399e71d4779797c538d0ff2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.8"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlotlyJS]]
deps = ["Base64", "Blink", "DelimitedFiles", "JSExpr", "JSON", "Kaleido_jll", "Markdown", "Pkg", "PlotlyBase", "REPL", "Reexport", "Requires", "WebIO"]
git-tree-sha1 = "7452869933cd5af22f59557390674e8679ab2338"
uuid = "f0f68f2c-4968-5e81-91da-67840de0976a"
version = "0.18.10"

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
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

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

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

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
git-tree-sha1 = "ef28127915f4229c971eb43f3fc075dd3fe91880"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.2.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

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

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

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

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "0b829474fed270a4b0ab07117dce9b9a2fa7581a"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.12"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "976d0738247f155d0dcd77607edea644f069e1e9"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.20"

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
# ╟─1f84b8d6-4f2d-4fe9-bdfc-e7dcc3d70aaa
# ╟─7368f682-06e3-4f21-85be-740179763de2
# ╟─6ed35212-af84-11ec-2c60-cd3e7a4ec044
# ╟─5631d29a-a810-46db-bd8e-09722527b57a
# ╠═588eb909-2f02-4c13-9a62-a63be78f44b1
# ╟─1c3ab571-4adb-4e0c-8ac4-1156b40b2149
# ╟─904d2e7e-0439-4de1-8178-8ce1daca1a44
# ╟─9f944b0d-a630-4dda-af2c-351d897c1994
# ╟─3a958d40-97f7-4143-809b-50d8ebb911c1
# ╟─95d7c11a-1e9a-424c-b7dc-83f42453d31d
# ╠═40aa1ba7-a06f-4a44-81fb-5be57184bef1
# ╟─46cf8696-684d-411a-a6aa-b6b79679b55d
# ╟─afa6c677-6850-4fcf-9ded-513c4e76e27a
# ╟─6d58c1dc-f26c-464b-8c53-0e6f4e877b4a
# ╠═11e83ae9-6869-4541-a52d-cf253a760536
# ╠═67683cc9-0e2a-4a7b-8f04-b1350b60cf97
# ╟─633eb320-30e8-457f-b30d-d648fd2558ef
# ╠═b68483f8-0f72-4907-922b-33dce51d888f
# ╟─b4b2396f-af4b-45bf-a92c-080fbe336b2d
# ╠═a85a7304-2a81-4021-aa9e-83bc3c129e78
# ╟─1377097e-c414-48be-b696-b017dfd39cd5
# ╠═ee83b946-8351-4fc0-9d03-058a0769d429
# ╟─3f685ace-5e2d-445f-8b49-d69298c98dfe
# ╟─a2b3a047-df87-4e03-a2c9-c445bcb52d5c
# ╟─1f8363a5-ec4f-439d-a88b-e772a7039545
# ╟─a8147f92-218b-4ec2-92c5-b889c1d96194
# ╟─e6f261f1-88fd-406c-936c-d627772f3dab
# ╠═b19c8354-e2d9-4af1-9162-3514ecd40420
# ╟─16a49e39-d634-44c4-b1e9-745650baf967
# ╟─1919af32-03a0-4dad-b821-f15629639650
# ╠═49fddcec-4b9a-4a36-b7f8-250652ad6fba
# ╟─a216aa00-c65a-422a-ab22-03dd8f7b565a
# ╠═da5ebca9-965c-4d54-b3d9-70f43e049652
# ╟─d70c9e6b-92a4-4ebf-86fe-01f991358f03
# ╠═4598e66a-cb12-429d-aa9a-2d48a924e889
# ╟─235090e1-b1de-4303-a4f0-ada9cf1a5a0c
# ╠═02191e15-ec2f-44d8-9dc4-e7ff9fc4d3bc
# ╠═f3cde397-fef4-464f-9a22-5c7e32afd4fd
# ╟─439be2c9-303b-418b-8c86-9711b83fc7ab
# ╠═56320370-a221-482a-8a38-398e566e4e93
# ╟─7d33c73e-93c4-4606-a6a3-05fe4419a87e
# ╟─b569f847-cbd5-4f88-a313-38a56cd6490e
# ╟─92a8f7c6-9c14-441f-aa9b-2e64f55ae893
# ╠═5b22c312-d668-4301-8e15-0649c04a2335
# ╟─55492d75-125c-4e4a-b63c-24ded33391f9
# ╠═6d66bd5d-0994-4f8a-bcf2-4387867f03af
# ╠═abd2ba26-dd5c-49d0-8be1-c15a8f9052d6
# ╟─736f775b-d146-421a-9dd8-b2e2a61cd3b9
# ╠═44a1935f-89a8-411e-8141-16db70caaf87
# ╟─3af156e4-7f9a-4cec-8725-7a3fd6faf9e0
# ╠═0a22fb78-a789-4517-8604-207c5516f929
# ╟─0d261812-6b35-4305-b07e-497e63f833bd
# ╠═fb5affcb-3670-4e6f-bada-0c3f8d30b89a
# ╟─b1757a53-2121-4afa-a52d-88c5eecf65df
# ╠═35ba0994-3700-4913-be6d-603bfcf6ecff
# ╟─d0d88d54-8a0d-402e-9bc5-3427e1cbdc5f
# ╟─ca777505-e414-428a-b2ea-37d990b87184
# ╠═71be0695-d3bb-4b62-b15f-49b79c2fe4b2
# ╟─9ecef615-4a09-4eaa-a954-cec7469a44bf
# ╠═6eefe1c9-b3de-4a4a-aae3-461e7919cc36
# ╠═07dfbfb4-2ce6-4d37-afd2-95b074b8b76f
# ╟─ac75a654-67fe-4c08-a81a-f7a0925e61f7
# ╠═abcfa7d1-60dd-49c1-9052-2f5079886f9e
# ╟─5ce13b44-c088-449a-8bad-2be5f3992acb
# ╟─bc2b3015-44e1-4b0b-b99b-44790574be46
# ╟─1a8762d5-7a63-40b6-bfd1-093a6ec24df8
# ╟─f038fc61-228b-4801-b2d9-711ea7b59998
# ╟─a5992d8c-1476-40ab-b08c-cc56742b1515
# ╠═5256a4b7-b6fa-483f-a409-f904d204df75
# ╟─9fc299c9-dd6f-4a25-a3b9-5dc16e740e89
# ╠═5ec92fdd-5108-42f3-9030-00e075878123
# ╟─830f060a-6559-4c91-962c-e122242103b1
# ╠═5ee22ed3-0575-4842-ae82-479d11ac088e
# ╟─d0b3c3b4-1eda-456a-966a-fb8f417a8aff
# ╠═7b87ce8c-06f1-49d5-a69d-7b66730d4dfb
# ╟─70f78c5f-5274-40bc-8e24-134ad329859c
# ╠═4303b736-9301-4b07-bf1e-26d8700ac318
# ╟─8a88cf85-96a0-4ec0-8792-4a9d519b38ce
# ╟─888ff334-773f-4e2a-9d51-3b888ec7805d
# ╠═390d1378-b915-48b4-a558-f434e4f6e913
# ╟─d47f1e0f-1300-4316-a32c-4927cf3b5a9a
# ╟─3a4a78f6-5a32-4ccf-a5f7-d9a8a0871e5c
# ╟─da248d27-ad9b-4808-88a3-471cae0a72ad
# ╠═713b7920-6d87-47cb-b097-d4deb08b5a58
# ╟─8712f3cc-fbef-4ef5-adde-aa807fe0af51
# ╠═4299e723-0ff1-4597-84c5-eb6d39dff736
# ╟─0804074e-91ac-47cb-88de-a56f3c9a90e6
# ╟─d56c84c1-4256-431f-9dce-e1f134d7d583
# ╠═098be01b-6fa9-4aba-bf69-fe952e360588
# ╟─df9998ed-5ec1-4fd7-bc47-3f628d7ead57
# ╠═c872e2de-87ed-47f3-91ab-8a727aac4db5
# ╟─06d0fd50-0173-4bd8-b8e5-f30e89d56c5c
# ╟─2165d5ec-c3c6-4ac5-b9b0-9d678329a1e9
# ╠═e5f7b364-c68a-4faf-9e25-f2ce8407277a
# ╟─fe70e872-cf12-429b-9ef6-98f9e887af7f
# ╠═6bb815c2-a52a-4cbb-9768-65a49724a190
# ╟─1b093351-18e4-41dd-96c6-c44d64aa59fe
# ╠═4ce2cc1d-e354-40e4-9837-3eea197f8747
# ╟─d8aa8853-8687-4b19-be1c-eb18a79989a5
# ╟─89eedbf8-6a5a-4828-9384-6277bd1ef1a8
# ╟─ab4d39bf-91c8-4c49-9864-87d480b419f9
# ╠═facedc34-5d42-41d7-83c5-41b73a35d84f
# ╟─de311bd4-0cda-45f7-9b30-39878dac8d00
# ╠═e60a81de-fd9b-417f-8c1e-a337d124fc36
# ╠═809db002-acba-4773-bb9f-83fc8b7ba71d
# ╟─d972f781-886d-46dd-90bb-1a607d6e078b
# ╠═b86c7648-36d0-4a81-a287-d53726797231
# ╠═3394e128-0642-4bce-adbc-3c9c82981cc2
# ╟─e705a6d0-6a6a-4ef7-b324-2638d9b7d0da
# ╟─cd8ffca2-e2d7-4c45-8025-bc0d88255595
# ╟─3450635d-7a28-40cd-b78d-d353c25fce5e
# ╠═2cfeabbf-f030-4062-96c0-fd5289f75501
# ╟─a98b7fe3-feb6-45ff-9367-6e4c32a685b3
# ╟─9f027a28-f712-45d7-8462-20cce79b595e
# ╟─d4bcb39f-23bf-4b2a-ac16-23292eccba2f
# ╟─42e009fc-5412-4da6-bc52-5065110edb9a
# ╟─ccfeab02-2bce-4aae-800f-a8660a069927
# ╟─aac68d98-b5d8-48c1-972a-3cc431b8e971
# ╟─a0080ee8-0d50-49b3-90d2-263a57a30024
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
