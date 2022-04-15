#!/bin/bash

if [[ $1 == *.txt ]]; then
	cat $1 | subfinder -silent
	amass enum -passive -nocolor -df $1
else
	echo $1 | subfinder -silent
	amass enum -passive -nocolor -d $1
fi
