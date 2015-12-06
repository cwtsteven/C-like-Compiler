#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
printf "\n------- Code Generation Test (w optimisation) -------\n"
for file in testing/valid/*.txt; do
	filename="${file##*/}"
	path_no_ext="${filename%%.*}"
	printf "case $path_no_ext: "
	if ./Main.native $file; then
		if ls "$path_no_ext.r" 1> /dev/null 2>&1; then
			expected=`cat ${path_no_ext%%a*}.r`
			cc "$path_no_ext.s" &> /dev/null0
			result=`./a.out`
			if [ "$expected" == "$result" ]; then 
				printf "\tpassed.\n"
			else
				printf "\t\tfailed.\n"
			fi
		else if (cc "${file%%.*}.s" &> /dev/null) && (./a.out &> /dev/null) then 
				printf "\tpassed.\n"
			else
				printf "\t\tfailed.\n"
			fi
		fi
	else
		printf "\t\t\tfailed.\n"
	fi
done

printf "\n------- Code Generation Test (w/o optimisation) -------\n"
for file in testing/valid/*.txt; do
	filename="${file##*/}"
	path_no_ext="${filename%%.*}"
	printf "case $path_no_ext: "
	if ./Main.native -fopoff $file; then
		if ls "$path_no_ext.r" 1> /dev/null 2>&1; then
			expected=`cat ${path_no_ext%%a*}.r`
			cc "$path_no_ext.s" &> /dev/null
			result=`./a.out`
			if [ "$expected" == "$result" ]; then 
				printf "\tpassed.\n"
			else
				printf "\t\tfailed.\n"
			fi
		else if (cc "${file%%.*}.s" &> /dev/null) && (./a.out &> /dev/null) then 
				printf "\tpassed.\n"
			else
				printf "\t\tfailed.\n"
			fi
		fi
	else
		printf "\t\t\tfailed.\n"
	fi
done
rm ./a.out
./TestBench.native
exit 0