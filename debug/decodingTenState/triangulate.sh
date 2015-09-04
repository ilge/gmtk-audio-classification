#! /bin/sh

for str in *.str; do
    [ -f ${str}.trifile ] && rm ${str}.trifile
    gmtkTriangulate -force R  -strF $str $*
done
