pandoc \
metabarcodinganalysiswithClaident.md \
-o metabarcodinganalysiswithClaident.json \
-f markdown \
-t json \
--filter=pandoc-citeproc \
--highlight-style=zenburn \
-N \
--bibliography=metabarcodinganalysiswithClaident.yaml \
--csl=citationstyle.csl

perl \
-i \
filter.pl \
metabarcodinganalysiswithClaident.json

pandoc \
metabarcodinganalysiswithClaident.json \
-o metabarcodinganalysiswithClaident.pdf \
-f json \
-t pdf \
--highlight-style=zenburn \
-N \
--pdf-engine=lualatex \
-H template.tex

pandoc \
metabarcodinganalysiswithClaident.json \
-o metabarcodinganalysiswithClaident.docx \
-f json \
-t docx \
--highlight-style=zenburn \
-N


#pandoc metabarcodinganalysiswithClaident.md -o metabarcodinganalysiswithClaident.pdf --filter=pandoc-citeproc --highlight-style=zenburn -N --bibliography=metabarcodinganalysiswithClaident.yaml --csl=citationstyle.csl --pdf-engine=lualatex -H template.tex
#pandoc metabarcodinganalysiswithClaident.md -o metabarcodinganalysiswithClaident.docx --filter=pandoc-citeproc --highlight-style=zenburn -N --bibliography=metabarcodinganalysiswithClaident.yaml --csl=citationstyle.csl
