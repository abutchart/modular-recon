#!/bin/bash

if [[ ! -d one_time ]]; then mkdir one_time; fi
if [[ ! -d one_time/$2 ]]; then mkdir one_time/$2; fi
if [[ ! -d one_time/$2/screens ]]; then mkdir one_time/$2/screens; fi

DIR=one_time/$2

echo "ENUMERATING SUBDOMAINS"
./enum_subs_passive_1.sh $1 | tee $DIR/subs.txt

echo "VALIDATING SUBDOMAINS"
./validate.sh $DIR/subs.txt | tee $DIR/subs_val.txt
./strip_protocol.sh $DIR/subs_val.txt > $DIR/subs_val_no_protocol.txt

echo "TAKING SCREENSHOTS"
./take_screenshots.sh $DIR/subs_val.txt $DIR/screens

echo "VULNERABILITY SCANNING"
./vuln_scan_1.sh $DIR/subs_val.txt | tee $DIR/vulns.txt
grep -E "\[unknown\]|\[low\]|\[medium\]|\[high\]|\[critical\]" vulns.txt > vulns_important.txt

echo "ENUMERATING FILES"
./enum_files_2.sh $DIR/subs_val.txt | tee $DIR/files.txt

