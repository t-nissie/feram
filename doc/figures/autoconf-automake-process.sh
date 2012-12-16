#!/bin/sh
# autoconf-automake-process.dot.prem4 and autoconf-automake-process.sh
# are written by Jdthood. Original files are distributed from
# http://commons.wikimedia.org/wiki/File:Autoconf-automake-process.svg .
##
N="autoconf-automake-process"
m4 \
  --define=LABEL_executable="executable" \
  --define=LABEL_input_file="input file" \
  --define=LABEL_output_file="output file" \
  --define=LABEL_process="process" \
  --define=LABEL_influences="influences" \
  --define=LABEL_creates="creates" \
  "${N}.dot.prem4" > "${N}.dot"
dot \
  -Tsvg \
  -Nfontname=FreeSans \
  < "${N}.dot" \
  > "${N}.svg"
m4 \
  --define=LABEL_executable="exécutable" \
  --define=LABEL_input_file="fichier d'entrée" \
  --define=LABEL_output_file="fichier de sortie" \
  --define=LABEL_process="procès" \
  --define=LABEL_influences="influencer" \
  --define=LABEL_creates="créer" \
  "${N}.dot.prem4" > "${N}-fr.dot"
dot \
  -Tsvg \
  -Nfontname=FreeSans \
  < "${N}-fr.dot" \
  > "${N}-fr.svg"
