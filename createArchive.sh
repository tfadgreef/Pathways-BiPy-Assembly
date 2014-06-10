#!/bin/bash 

git log --oneline --decorate --pretty="%cD: %B" > changelog

tar cvzf PPODESUITE_$(date +"%d-%m-%y").tar.gz src/ examples/ *.m doc/src/Main.pdf doc/tut/Tutorial.pdf version changelog

rm -r newest
mkdir newest

cp PPODESUITE_$(date +"%d-%m-%y").tar.gz newest/PPODESUITE.tar.gz
cp changelog newest/changelog.txt
cp version newest/version.txt
