#! /bin/sh

json2stream 36 0 | \
gmtkOnline \
  -os1 - -nf1 36 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable 16comp-frame.gmp\
  -numSmooth 1 -viterbi -mVitValsFile - | \
vit2json
