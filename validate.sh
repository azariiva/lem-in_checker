#!/bin/sh

IPATH="$HOME/goinfre/test.txt"
OPATH="$HOME/goinfre/out.txt"
LPATH="$HOME/goinfre/log.txt"

ILINK="$(dirname "$0")/test-link"
OLINK="$(dirname "$0")/out-link"
LLINK="$(dirname "$0")/log-link"
LEMPATH="$HOME/lem-in"

if [ ! -f "$LEMPATH/lem-in" ]
then
	echo "lem-in binary not found"
	exit
fi
if [ -z $1 ]
then
	echo "usage: ./validate.sh [option]"
else
	./generator $1 > $IPATH
	if [ -s $IPATH ]
	then
		rm -f $ILINK $OLINK $LLINK
		$LEMPATH/lem-in < $IPATH > $OPATH
		ln -s $IPATH $ILINK
		ln -s $OPATH $OLINK
		ln -s $LPATH $LLINK
		a=$(wc -l $IPATH | awk '{printf "%s\n", $1}')
		b=$(wc -l $OPATH | awk '{print $1}')
		OUR=$(expr $b - $a - 1)
		PERF=$(sed '2q;d' $IPATH | tr -dc '0-9')
		echo "Result: $OUR/$PERF"
		python3 checker.py < $OPATH
	fi
fi
