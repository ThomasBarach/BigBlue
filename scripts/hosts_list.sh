#!/bin/bash

# Create host files form a csv file

input = $1

while IFS = ',' read -r f1 f2
do
  ./host.sh $f1 $f2
done < "$input"
