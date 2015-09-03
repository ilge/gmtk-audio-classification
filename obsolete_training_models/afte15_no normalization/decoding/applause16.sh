#! /bin/sh

json2stream 25 0 | \
gmtkOnline \
  -os1 - -nf1 25 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable 4comp-frame.gmp\
  -numSmooth 1 -viterbi -mVitValsFile - | \
vit2json
