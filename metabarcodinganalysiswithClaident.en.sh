pandoc \
metabarcodinganalysiswithClaident.en.md \
-o metabarcodinganalysiswithClaident.en.json \
-f markdown \
-t json \
--filter=pandoc-citeproc \
--highlight-style=zenburn \
-N \
--bibliography=metabarcodinganalysiswithClaident.en.yaml \
--csl=citationstyle.csl

perl \
-i \
filter.pl \
metabarcodinganalysiswithClaident.en.json

pandoc \
metabarcodinganalysiswithClaident.en.json \
-o metabarcodinganalysiswithClaident.en.pdf \
-f json \
-t pdf \
--highlight-style=zenburn \
-N \
--pdf-engine=lualatex \
-H template.tex

pandoc \
metabarcodinganalysiswithClaident.en.json \
-o metabarcodinganalysiswithClaident.en.docx \
-f json \
-t docx \
--highlight-style=zenburn \
-N

rm metabarcodinganalysiswithClaident.en.json

#pandoc metabarcodinganalysiswithClaident.en.md -o metabarcodinganalysiswithClaident.en.pdf --filter=pandoc-citeproc --highlight-style=zenburn -N --bibliography=metabarcodinganalysiswithClaident.en.yaml --csl=citationstyle.csl --pdf-engine=lualatex -H template.tex
#pandoc metabarcodinganalysiswithClaident.en.md -o metabarcodinganalysiswithClaident.en.docx --filter=pandoc-citeproc --highlight-style=zenburn -N --bibliography=metabarcodinganalysiswithClaident.en.yaml --csl=citationstyle.csl
