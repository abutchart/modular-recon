#!/bin/bash

if [[ $1 == *.txt ]]; then
	cat $1 | awk -F/ '{print $3}'
else
	echo $1 | awk -F/ '{print $3}'
fi

