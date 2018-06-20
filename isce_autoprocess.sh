#!/bin/bash

ifglist=$1

echo "We are processing something $ifglist"

while read master slave ; do
  echo "cd ${master}_${slave}_ERS1_L0_WINSAR_170_2889/"; 
  cd ${master}_${slave}_ERS1_L0_WINSAR_170_2889/
  echo "insarApp.py insarApp.xml --steps"; 
  insarApp.py insarApp.xml --steps
  echo "cd .."; 
  cd ..
done < $ifglist
