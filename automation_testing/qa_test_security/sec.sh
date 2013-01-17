#!/bin/sh

SECS=/usr/lib/ctcs/qa_test_security
cd $SECS
gcc uname26-kernel-info-leak.c
./a.out
if [ $? == 0 ]
then
echo "Safe now!"
exit 0
else
echo "Leaked"
exit 1
fi
