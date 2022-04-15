#!/bin/bash

if [[ $1 == *.txt ]]; then
	# -u : only show unique urls
	cat $1 | hakrawler -u
else
	echo $1 | hakrawler -u
fi

