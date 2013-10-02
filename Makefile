.PHONY: clean test

basename = torque_statistics

all: test pdf

pdf: $(basename).pdf

$(basename).pdf: $(basename).tex
	pdflatex $<
	pdflatex $<

$(basename).tex:
	perl $(basename).pl --month=08 --year=2013

test:
	cover -delete
	export PERL5OPT=-MDevel::Cover;\
	for file in `ls -1 t/*.t`;\
	do\
	    perl $$file;\
	done
	cover

clean:
	rm -f *.aux *.log *.toc *.out $(basename).tex $(basename).pdf
