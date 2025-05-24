pandoc \
metabarcodinganalysiswithClaident.ja.md \
-o metabarcodinganalysiswithClaident.ja.json \
-f markdown \
-t json \
--filter=pandoc-citeproc \
--highlight-style=zenburn \
--number-sections \
--bibliography=metabarcodinganalysiswithClaident.ja.yaml \
--csl=citationstyle.csl

perl \
-i \
filter.pl \
metabarcodinganalysiswithClaident.ja.json

pandoc \
metabarcodinganalysiswithClaident.ja.json \
-o metabarcodinganalysiswithClaident.ja.pdf \
-f json \
-t pdf \
--highlight-style=zenburn \
--number-sections \
--toc \
--toc-depth 4 \
--pdf-engine=lualatex \
-H template.tex

pandoc \
metabarcodinganalysiswithClaident.ja.json \
-o metabarcodinganalysiswithClaident.ja.html \
-f json \
-t html \
--standalone \
--highlight-style=zenburn \
--number-sections \
--toc \
--toc-depth 4 \
--self-contained

rm metabarcodinganalysiswithClaident.ja.json

#pandoc metabarcodinganalysiswithClaident.ja.md -o metabarcodinganalysiswithClaident.ja.pdf --filter=pandoc-citeproc --highlight-style=zenburn --number-sections --bibliography=metabarcodinganalysiswithClaident.ja.yaml --csl=citationstyle.csl --pdf-engine=lualatex -H template.tex
#pandoc metabarcodinganalysiswithClaident.ja.md -o metabarcodinganalysiswithClaident.ja.docx --filter=pandoc-citeproc --highlight-style=zenburn --number-sections --bibliography=metabarcodinganalysiswithClaident.ja.yaml --csl=citationstyle.csl
