pandoc \
metabarcodinganalysiswithClaident.ja.md \
-o metabarcodinganalysiswithClaident.ja.json \
-f markdown \
-t json \
--filter=pandoc-citeproc \
--highlight-style=zenburn \
-N \
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
-N \
--pdf-engine=lualatex \
-H template.tex

pandoc \
metabarcodinganalysiswithClaident.ja.json \
-o metabarcodinganalysiswithClaident.ja.docx \
-f json \
-t docx \
--highlight-style=zenburn \
-N

rm metabarcodinganalysiswithClaident.ja.json

#pandoc metabarcodinganalysiswithClaident.ja.md -o metabarcodinganalysiswithClaident.ja.pdf --filter=pandoc-citeproc --highlight-style=zenburn -N --bibliography=metabarcodinganalysiswithClaident.ja.yaml --csl=citationstyle.csl --pdf-engine=lualatex -H template.tex
#pandoc metabarcodinganalysiswithClaident.ja.md -o metabarcodinganalysiswithClaident.ja.docx --filter=pandoc-citeproc --highlight-style=zenburn -N --bibliography=metabarcodinganalysiswithClaident.ja.yaml --csl=citationstyle.csl
