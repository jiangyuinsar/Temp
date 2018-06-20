#!/bin/bash

img_list=$1

while read image ; do
  echo "cd ${image}/"; 
  cd ${image}/
  echo "tar -xzvf *.tar.gz"; 
  tar -xzvf *.tar.gz
  echo "cd .."; 
  cd ..
done < $img_list
