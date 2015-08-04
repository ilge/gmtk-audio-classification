#! /bin/sh

json2stream 5 0 | \
gmtkOnline \
  -os1 - -nf1 5 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable 4comp_20.gmp\
  -numSmooth 10 -vitRunLength \
  -viterbi -mVitValsFile - | \
vit2json
