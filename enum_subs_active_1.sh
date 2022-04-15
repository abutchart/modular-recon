#!/bin/bash

if [[ $1 == *.txt ]]; then
	amass enum -brute -nocolor -df $1
else
	amass enum -brute -nocolor -d $1
fi
