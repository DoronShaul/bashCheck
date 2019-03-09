#!/bin/bash

CURRDIR=$1
PROGRAM=$2
MEMCHECK=0
THREADRACE=0
COMPILATION=0

if [ ! -f $CURRDIR/Makefile ]; then MEMCHECK=1
	THREADRACE=1
	COMPILATION=1
fi

if [ $COMPILATION == 0 ]; then 
	make -f Makefile

	if [ $? != 0 ]; then COMPILATION=1
	fi

	if [ $COMPILATION == 0 ]; then
		valgrind --error-exitcode=1 --leak-check=full ./$PROGRAM

		if [ $? != 0 ]; then MEMCHECK=1
		fi

		valgrind --error-exitcode=1 --tool=helgrind ./$PROGRAM

		if [ $? != 0 ]; then THREADRACE=1
		fi
	fi
fi

echo ""
echo ""
echo ""

echo "COMPILATION       MEMORY LEAKS       THREAD RACE"
echo "    $COMPILATION                  $MEMCHECK                  $THREADRACE"     

