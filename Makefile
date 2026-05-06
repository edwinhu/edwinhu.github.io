TYPST := typst
FEATURES := --features html
ROOT := --root .

.PHONY: all website cv software clean watch

all: website cv software

website: index.html
cv: cv/cv.pdf
software: software/index.html

index.html: typ/index.typ typ/lib.typ typ/templates/website-head.typ $(wildcard typ/content/*.typ)
	$(TYPST) compile $(FEATURES) --format html $(ROOT) typ/index.typ index.html

cv/cv.pdf: typ/cv.typ typ/lib.typ typ/templates/cv-template.typ $(wildcard typ/content/*.typ)
	$(TYPST) compile $(FEATURES) $(ROOT) typ/cv.typ cv/cv.pdf

software/index.html: typ/software.typ typ/lib.typ typ/templates/website-head.typ
	$(TYPST) compile $(FEATURES) --format html $(ROOT) typ/software.typ software/index.html

clean:
	rm -f index.html cv/cv.pdf software/index.html

watch:
	$(TYPST) watch $(FEATURES) --format html --no-serve $(ROOT) typ/index.typ index.html

serve:
	python3 -m http.server 3000

watch-cv:
	$(TYPST) watch $(FEATURES) $(ROOT) typ/cv.typ cv/cv.pdf

preview-cv:
	tinymist preview $(ROOT) typ/cv.typ
