#!/bin/bash

if [[ $1 == *.txt ]]; then
	cat $1 | sort | uniq | httprobe -prefer-https
else
	echo $1 | httprobe -prefer-https
fi

