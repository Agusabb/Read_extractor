#!/bin/bash

while getopts ":i:f:s:r:o:" options; do              
                                               
                                               
  case "${options}" in                          
    i)                                         
      origen=${OPTARG}                           
      ;;
    f)                                         
      file=${OPTARG}                           
      ;;
    s)                                         
      hebra=${OPTARG}                           
      ;;
    r)                                         
      reads=${OPTARG}                          
      ;;
    o)                                     
      output=${OPTARG}                          
      ;;
  esac
done

IFS=$","
set -f
for locus in $(cat $file)
do
  samtools view $origen $locus|cut -f 2,3,4,6,10,14|awk '$4 == "21M"'|sort -k 1|awk -v hebra2=$hebra '$1 == hebra2'|awk 'BEGIN{FS=OFS="\t"} b!=$3{for(j=0;j<i;j++){print a[j],i};delete a;b=$3;i=0;}{a[i++]=$0}END{for (j=0;j<i;j++){print a[j],i}}'|sort -k 6,6|sort -k 3 -n -u|awk -v reads2=$reads '$7 >= reads2 { print }' > $locus\_$hebra.tab
done
