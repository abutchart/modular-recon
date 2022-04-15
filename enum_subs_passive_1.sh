#!/bin/bash

if [[ $1 == *.txt ]]; then
	cat $1 | subfinder -silent
else
	echo $1 | subfinder -silent
fi
