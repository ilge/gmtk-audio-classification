#! /bin/sh

json2stream 20 0 | \
gmtkOnline \
  -os1 - -nf1 20 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable 8comp-frame.gmp\
  -viterbi -mVitValsFile - | \
vit2json
