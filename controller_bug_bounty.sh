#!/bin/bash
#TODO: Diff checking mechanism, Discord bot notification system

DIR=bug_bounty
DATE=$(date +%d-%m-%y)
if [[ ! -d $DIR ]]; then mkdir $DIR; fi
if [[ ! -d $DIR/data ]]; then mkdir $DIR/data; fi

# pre-scraped bug bounty targets
curl https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/domains.txt > $DIR/targets.txt
curl https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/wildcards.txt > $DIR/raw_wildcards.txt

# wildcards.txt -> get subdomains, add all valid ones to targets
# targets.txt -> list of targets to do all non-subdomain-related stuff with
cat /dev/null > $DIR/wildcards.txt

TLDS=(net com org jp it br de cn fr au ru mx pl nl edu ar ca uk se tr in xyz)

cat $DIR/raw_wildcards.txt | while read line; do
	# some programs format wildcards like (*).example.com
	TMP=$(echo $line | tr -d '()')
	# if target ends with *
	if [[ $TMP == *\* ]]; then
		# iterate through TLDs, output example.com, example.net, example.org, etc.
		for tld in "${TLDS[@]}"; do
			echo "${TMP%?}$tld" >> $DIR/wildcards.txt
		done
	else
		echo $TMP >> $DIR/wildcards.txt	
	fi
done

cat /dev/null > $DIR/formatted_wildcards_special_domains.txt
cat /dev/null > $DIR/formatted_wildcards_special_mask.txt
cat /dev/null > $DIR/formatted_wildcards.txt

cat $DIR/wildcards.txt | while read line; do
	# if there are no * characters add to targets list
	if [[ ! $line == *\** ]]; then 
		echo $line >> $DIR/targets.txt;
	else
		# if there are two or more * characters or the first character is not *
		# (this accounts for all "weird" wildcard variants e.g. api.*.example.com, *.api.*.example.com)
		if [[ $line =~ \*.*\* || $line != \** ]]; then
			# get the domain
			# api.*.example.com -> example.com
			TMP=$(echo $line | awk -F '*.' '{print $NF}')
			# remove stuff like example-*.com, not sure how to deal with this format
			if [[ $TMP == *\.* ]]; then
				echo $TMP >> $DIR/formatted_wildcards_special_domains.txt
				echo $line >> $DIR/formatted_wildcards_special_mask.txt
			fi
		# otherwise the wildcard is formatted like *.example.com
		else
			# remove leading * or *. (some are formatted like *example.com)
			TMP=${line#\*}
			TMP=${TMP#\.}
			echo $TMP >> $DIR/formatted_wildcards.txt
		fi
	fi

done

cat $DIR/formatted_wildcards_special_domains.txt | sort | uniq > $DIR/tmp.txt
cat $DIR/tmp.txt > $DIR/formatted_wildcards_special_domains.txt
rm $DIR/tmp.txt

./enum_subs_passive_1.sh $DIR/formatted_wildcards.txt | tee -a $DIR/targets.txt
./enum_subs_passive_1.sh $DIR/formatted_wildcards_special_domains.txt | tee $DIR/subdomains_special.txt

cat $DIR/formatted_wildcards_special_mask.txt | while read line; do
	# "^$line$" matches only the mask and nothing else 
	grep -E "^$line$" $DIR/subdomains_special.txt | tee -a $DIR/targets.txt
done

./validate.sh $DIR/targets.txt | tee $DIR/validated_targets.txt
shuf $DIR/validated_targets.txt > $DIR/validated_targets_shuffled.txt
python3 remove_duplicate_ips.py $DIR/validated_targets_shuffled.txt | tee $DIR/validated_targets_no_duplicates.txt
./strip_protocol.sh $DIR/validated_targets_no_duplicates.txt | tee $DIR/validated_targets_no_protocol.txt
if [[ ! -d $DIR/screens ]]; then mkdir $DIR/screens; fi
./take_screenshots.sh $DIR/validated_targets_no_duplicates.txt $DIR/screens
./vuln_scan_1.sh $DIR/validated_targets_no_duplicates.txt | tee $DIR/vulns.txt
./enum_files_1.sh $DIR/validated_targets_no_duplicates.txt | tee $DIR/files.txt
grep -E "\[unknown\]|\[low\]|\[medium\]|\[high\]|\[critical\]" $DIR/vulns.txt > $DIR/important_vulns.txt

# get list of domains to group subdomains into. api.null.foo.example.com -> example.com
cat $DIR/validated_targets_no_duplicates.txt | awk -F '.' '{print $(NF-1)"."$NF}' | sort | uniq > $DIR/domains.txt

cat $DIR/domains.txt | while read domain; do
	if [[ ! -d $DIR/data/$domain ]]; then mkdir $DIR/data/$domain; fi
	if [[ ! -d $DIR/data/$domain/screens ]]; then mkdir $DIR/data/$domain/screens; fi
	if [[ ! -d $DIR/data/$domain/source ]]; then mkdir $DIR/data/$domain/source; fi

	grep $domain $DIR/validated_targets_no_duplicates.txt > $DIR/data/$domain/validated_targets_no_duplicates.txt
	grep $domain $DIR/validated_targets_no_protocol.txt > $DIR/data/$domain/validated_targets_no_protocol.txt
	grep $domain $DIR/vulns.txt > $DIR/data/$domain/vulns.txt
	grep -E "\[unknown\]|\[low\]|\[medium\]|\[high\]|\[critical\]" $DIR/data/$domain/vulns.txt > $DIR/data/$domain/important_vulns.txt
	grep $domain $DIR/files.txt > $DIR/data/$domain/files.txt

	cp $DIR/screens/screens/*$domain.png $DIR/data/$domain/screens
	cp $DIR/screens/source/*$domain.txt $DIR/data/$domain/source

	cat $DIR/data/$domain/validated_targets_no_protocol.txt | while read subdomain; do
		if [[ ! -d $DIR/data/$domain/subdomains ]]; then mkdir $DIR/data/$domain/subdomains; fi
		if [[ ! -d $DIR/data/$domain/subdomains/$subdomain ]]; then mkdir $DIR/data/$domain/subdomains/$subdomain; fi
		if [[ ! -d $DIR/data/$domain/subdomains/$subdomain/$DATE ]]; then mkdir $DIR/data/$domain/subdomains/$subdomain/$DATE; fi

		grep $subdomain $DIR/data/$domain/vulns.txt > $DIR/data/$domain/subdomains/$subdomain/$DATE/vulns.txt
		grep $subdomain $DIR/data/$domain/important_vulns.txt > $DIR/data/$domain/subdomains/$subdomain/$DATE/important_vulns.txt
		grep $subdomain $DIR/data/$domain/files.txt > $DIR/data/$domain/subdomains/$subdomain/$DATE/files.txt
		cp $DIR/data/$domain/screens/*$subdomain.png $DIR/data/$domain/subdomains/$subdomain/$DATE
		cp $DIR/data/$domain/source/*$subdomain.txt $DIR/data/$domain/subdomains/$subdomain/$DATE
	done
done
