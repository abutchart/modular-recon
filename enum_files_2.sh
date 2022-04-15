#!/bin/bash

if [[ $1 == *.txt ]]; then
	# -u : only show unique urls
	cat $1 | hakrawler -u
	cat $1 | while read line; do
		echo $line
		ffuf -u $line/FUZZ -w /usr/share/wordlists/wfuzz/general/common.txt -v
	done
else
	echo $1 | hakrawler -u
	ffuf -u $1/FUZZ -w /usr/share/wordlists/wfuzz/general/common.txt -v
fi

