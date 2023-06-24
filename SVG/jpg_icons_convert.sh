#!/bin/sh

for i in $(ls ./*.svg)
do
#    file=$(echo "${i}" | sed -e 's/_.*.svg//g')
    file=$(echo ${i%.svg})
#    echo $file
    icona1=$file".jpg"
    convert $i $icona1
done
