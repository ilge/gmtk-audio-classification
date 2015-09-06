#! /bin/sh

json2stream 10 0 | \
gmtkOnline \
  -os1 - -nf1 10 -fmt1 ascii \
  -strFile applause_detector.str \
  -inputMasterFile applause_detector.mtr \
  -inputTrainable $2\
  -numSmooth $1 -viterbi F -mVitValsFile - | \
vit2json
