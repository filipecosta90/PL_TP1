#!bin/sh

echo "/*
********************************************************************************
*Copyright(C) 2016 Filipe Oliveira, Universidade do Minho
*   All Rights Reserved.
*
********************************************************************************
*   Content : 2a) bibtex category counter (phDThesis, Misc, InProceeding,
*             etc.), that occur in a document
*           : 2b) bibtex file normalizer and pretty-printer
*           : 2c) bibtex co-authoring graph builder for a given normalized 
*             author name 
********************************************************************************/"

make clean
flex bib_norm_1.l
make a1
./bib_norm_1 < lp.bib > ex2a.html
echo "##########################"
echo ">>>>>>>> ex2a in ex2a.html"
echo "         opening file"
echo "##########################"
open ex2a.html

make clean
flex bib_norm_2.l
make a2
./bib_norm_2 < lp.bib > ex2b.bib
echo "##########################"
echo ">>>>>>>> ex2b in ex2b.bib"
echo "##########################"

make clean
flex bib_norm_3.l
make a3
./bib_norm_3 "P. Henriques" < lp.bib > ex2c.gv
dot ex2c.gv -Tpng > ex2c.png
echo "##########################"
echo ">>>>>>>> ex2c in ex2c.png"
echo "         opening file"
echo "##########################"
open ex2c.png
echo "done"
