#!/bin/bash 

tar cvzf PPODESUITE_$(date +"%d-%m-%y").tar.gz src/ examples/ *.m doc/src/Main.pdf doc/tut/Tutorial.pdf
