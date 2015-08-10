#! /bin/sh

json2stream 5 0 | \
gmtkOnline \
  -os1 - -nf1 5 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable 64comp_10.gmp\
  -numSmooth 2 -vitRunLength \
  -viterbi -mVitValsFile - | \
vit2json
