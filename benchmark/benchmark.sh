#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

printf "\n------- Compile Time -------\n"
printf "C:\t"
cd ./c
ctime=$(/usr/bin/time gcc -S ./test.c && cc test.s)
cd ..
printf "Java:\t"
javatime=$(/usr/bin/time javac ./java/Test.java)
printf "Mine:\t"
cd ./mine
mtime=$(/usr/bin/time ../../Main.native -fopoff ./test.txt && cc test.s)
cd ..
printf "\n"

printf "\n------- Run Time -------\n"
printf "C:\t"
ctime=$(/usr/bin/time ./c/a.out)
printf "Java:\t"
cd ./java
javatime=$(/usr/bin/time java Test)
cd ..
printf "Mine:\t"
mtime=$(/usr/bin/time ./mine/a.out)
printf "\n"

exit 0