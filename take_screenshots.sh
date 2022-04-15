#!/bin/bash

if [[ $1 == *.txt ]]; then
	# -d : what directory to put output in
	# --no-prompt : remove that interactive prompt that pops up when the screenshots finish
	./EyeWitness/Python/EyeWitness.py -f $1 -d $2 --timeout 15 --max-retries 7 --no-prompt
else
	./EyeWitness/Python/EyeWitness.py --single $1 -d $2 --timeout 15 --max-retries 7 --no-prompt
fi
