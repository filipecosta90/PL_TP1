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
flex owl_graph.l
make 
./owl_graph < test1.xml > ex1.gv
dot ex1.gv -Tpng > ex1.png
echo "##########################"
echo ">>>>>>>> ex1 in ex1.png"
echo "         opening file"
echo "##########################"
open ex1.png
echo "done"
