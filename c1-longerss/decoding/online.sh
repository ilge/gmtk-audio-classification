#! /bin/sh

json2stream 10 0 | \
gmtkOnline \
  -os1 - -nf1 10 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable $1\
  -numSmooth 5 -viterbi -mVitValsFile - | \
vit2json
