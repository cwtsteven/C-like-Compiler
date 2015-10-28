#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
printf "\n------- Code Generation Test -------\n"
for file in testing/valid/*.txt; do
	filename="${file##*/}%%.*"
	./Main.native -fopoff $file
	printf "case ${filename%%.*}: "
	if (cc "${file%%.*}.s" &> /dev/null) && (./a.out &> /dev/null) then 
		printf "\tpassed.\n"
	else
		printf "\t\tfailed.\n"
	fi
done
rm ./a.out
./TestBench.native
exit 0