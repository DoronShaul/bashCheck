#!/bin/bash

CURRDIR=$1            #the given directory.
PROGRAM=$2            #the given program.
MEMCHECK=0
THREADRACE=0
COMPILATION=0

if [ ! -f $CURRDIR/Makefile ]; then MEMCHECK=1      #if there is no makefile in this folder, return 1 in everything (all failed).
	THREADRACE=1
	COMPILATION=1
fi

if [ $COMPILATION == 0 ]; then        #if there is a makefile in this folder, run it.
	make -f Makefile

	if [ $? != 0 ]; then COMPILATION=1      #if the compilation failed.
	fi

	if [ $COMPILATION == 0 ]; then          #if the compilation succeed, checks for memory leaked.
		valgrind --error-exitcode=1 --leak-check=full ./$PROGRAM

		if [ $? != 0 ]; then MEMCHECK=1       #if there is a memory leaked.
		fi

		valgrind --error-exitcode=1 --tool=helgrind ./$PROGRAM       #run thread race test.

		if [ $? != 0 ]; then THREADRACE=1     #if there is a thread race problem.
		fi
	fi
fi

echo ""
echo ""
echo ""

echo "COMPILATION       MEMORY LEAKS       THREAD RACE"
echo "    $COMPILATION                  $MEMCHECK                  $THREADRACE"     

