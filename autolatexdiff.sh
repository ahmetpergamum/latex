#!/bin/bash

# script that archive latex and track changes with latexdiff

SOURCEDIR="/home/admin1/Thesis/thesis/master"
DATE=$(date +%Y-%m-%d)
DESTDIR="/home/admin1/Thesis/thesis/archive/master-$DATE"
DIFFDIR=${1:-/home/admin1/Thesis/thesis/archive/master20180921}


# copy the .tex and .bib files only to the archive directory

mkdir -p $DESTDIR

cp  $SOURCEDIR/*.{tex,bib} $DESTDIR


sed -i  "s/bibliography.*thesis/bibliography\{thesis\-$DATE/" $DESTDIR/thesis.tex

cd $DESTDIR
rename "s/thesis*/thesis\-$DATE/" *.{tex,bib}


# create archived pdf files

cd $DESTDIR

pdflatex thesis-$DATE.tex &&
pdflatex thesis-$DATE.tex &&
bibtex thesis-$DATE
pdflatex thesis-$DATE.tex &&
pdflatex thesis-$DATE.tex


# latexdiff archived pdf files with desired previous one

latexdiff --flatten $DIFFDIR/thesis*.tex $DESTDIR/thesis*.tex > $DESTDIR/diff-$DATE.tex &&

# create diff pdf files

cd $DESTDIR

pdflatex diff-$DATE.tex &&
pdflatex diff-$DATE.tex &&

xdg-open diff-$DATE.pdf
