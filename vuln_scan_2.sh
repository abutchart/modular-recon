#!/bin/bash

if [[ $1 == *.txt ]]; then
	nuclei -l $1 -silent -no-color 
	cat $1 | while read line; do
		nikto -h $line -nointeractive
	done
else
	nuclei -u $1 -silent -no-color 
	nikto -h $1 -nointeractive
fi

