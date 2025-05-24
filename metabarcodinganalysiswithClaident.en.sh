pandoc \
metabarcodinganalysiswithClaident.en.md \
-o metabarcodinganalysiswithClaident.en.json \
-f markdown \
-t json \
--filter=pandoc-citeproc \
--highlight-style=zenburn \
--number-sections \
--bibliography=metabarcodinganalysiswithClaident.en.yaml \
--csl=citationstyle.csl

perl \
-i \
-npe \
's/"documentclass":\{"t":"MetaInlines","c":\[\{"t":"Str","c":"bxjsarticle"\}\]\}/$&,"lang":\{"t":"MetaInlines","c":\[\{"t":"Str","c":"en"\}\]\}/' \
metabarcodinganalysiswithClaident.en.json

pandoc \
metabarcodinganalysiswithClaident.en.json \
-o metabarcodinganalysiswithClaident.en.pdf \
-f json \
-t pdf \
--highlight-style=zenburn \
--number-sections \
--toc \
--toc-depth 4 \
--pdf-engine=lualatex \
-H template.tex

pandoc \
metabarcodinganalysiswithClaident.en.json \
-o metabarcodinganalysiswithClaident.en.html \
-f json \
-t html \
--standalone \
--highlight-style=zenburn \
--number-sections \
--toc \
--toc-depth 4 \
--self-contained

rm metabarcodinganalysiswithClaident.en.json

#pandoc metabarcodinganalysiswithClaident.en.md -o metabarcodinganalysiswithClaident.en.pdf --filter=pandoc-citeproc --highlight-style=zenburn --number-sections --bibliography=metabarcodinganalysiswithClaident.en.yaml --csl=citationstyle.csl --pdf-engine=lualatex -H template.tex
#pandoc metabarcodinganalysiswithClaident.en.md -o metabarcodinganalysiswithClaident.en.docx --filter=pandoc-citeproc --highlight-style=zenburn --number-sections --bibliography=metabarcodinganalysiswithClaident.en.yaml --csl=citationstyle.csl
