
# Build jekyll site

First, `cp offline/_config.yml docs`, then `cd docs;bundle exec jekyll serve`. (See work vault in obsidian for details of setting up jekyll). Once jekyll is running, you can restore the on-line `_config.yml` using `git checkout`.


# Building course schedule page

One time: in Julia, add `CourseCalendar` to the current `Project.toml` from its gh repo URL, and instantiate.

After that, just `julia compilecal.jl`.


## Generating a PDF syllabus

`sh pdfsyllabus.sh`

The output will be `printable/syllabus.pdf`