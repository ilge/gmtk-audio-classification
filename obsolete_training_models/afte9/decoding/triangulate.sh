#! /bin/sh

for str in *.str; do
    [ -f ${str}.trifile ] && rm ${str}.trifile
    gmtkTriangulate -forceLeftRight R  -strF $str $*
done
