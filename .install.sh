#!/bin/bash

cp -r ./* ~/

mkdir -p ~/Documents/PDFs

wget https://csh.rit.edu/~bigdata/pdf.zip
unzip pdf.zip -d ~/Documents/PDFs
