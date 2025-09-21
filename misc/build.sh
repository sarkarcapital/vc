pandoc litepaper.md -o litepaper.pdf \
  --pdf-engine=xelatex \
  -V mainfont="Arial" \
  -V geometry:margin=1in
