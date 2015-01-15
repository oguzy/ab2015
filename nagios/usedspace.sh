#!/bin/bash
#used_space=`df -h / | grep -v Filesystem | awk '{print $5}' | sed 's/%//g'`
used_space=`df -h / | grep -v Filesystem | awk '{print $5}' | cut -d "%" -f1 -`
if ((1<=$used_space && $used_space<=84))
then
	echo "OK - $used_space% of disk space used."
	exit 0
elif ((85=$used_space))
then
	echo "WARNING - $used_space% of disk space used."
	exit 1
elif ((86<=$used_space && $used_space<=100))
then
	echo "CRITICAL - $used_space% of disk space used."
	exit 2
else
	echo "UNKNOWN - $used_space% of disk space used."
	exit 3
fi

# exit codes
#0 	OK
#1 	WARNING
#2 	CRITICAL
#3 	UNKNOWN
