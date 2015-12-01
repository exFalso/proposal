TARGET=Proposal

all: build/$(TARGET).pdf

clean:
	rm -rf build

build/$(TARGET).tex: src/$(TARGET).tex src/$(TARGET).bib
	mkdir -p build
	cp -r src/* build/

build/$(TARGET).pdf: build/$(TARGET).tex
	cd build \
	&& export TEXINPUTS=.:../resources \
	&& latex $(TARGET).tex \
	&& bibtex $(TARGET).aux \
	&& latex $(TARGET).tex \
	&& pdflatex $(TARGET).tex \

open: build/$(TARGET).pdf
	evince build/$(TARGET).pdf &

watch: open
	@while inotifywait -e close_write src > /dev/null ; \
		do (\
			make & true ; \
		) ; \
		done
