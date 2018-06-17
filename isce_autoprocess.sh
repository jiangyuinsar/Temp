#!/bin/bash

ifglist=$1

while read master slave
do 
  echo "cd ${master}_${slave}_ERS2_L0_WINSAR_485_2853/"; 
  cd ${master}_${slave}_ERS2_L0_WINSAR_485_2853/
  echo "insarApp.py insarApp.xml --steps"; 
  insarApp.py insarApp.xml --steps
  echo "cd .."; 
  cd ..
done < $ifglist