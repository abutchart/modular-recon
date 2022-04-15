#!/bin/bash

if [[ $1 == *.txt ]]; then
	nuclei -l $1 -silent -no-color 
else
	nuclei -u $1 -silent -no-color 
fi

