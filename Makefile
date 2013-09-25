.PHONY: clean

basename = torque_statistics

all: pdf

pdf: $(basename).pdf

$(basename).pdf: $(basename).tex
	pdflatex $<
	pdflatex $<

$(basename).tex:
	perl $(basename).pl

clean:
	rm -f *.aux *.log *.toc *.out $(basename).tex $(basename).pdf
