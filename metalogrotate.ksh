#!/bin/ksh

##  script to rotate the metacheck.ksh log files
##  this will move the current file to .1, .1 to .2, etc
##  there will be 4 historical files in total
##
##  "problem" is a common string between this script and metacheck.ksh
##  This allows for a log watcher to alert on this common string
##
##  Robert Dawson
##  Fujitsu Services
##  23/06/2010
##
##  v0.1
##

#  file to be rotated
LOGFILE=/var/log/metacheck.log

if [ -f $LOGFILE.3 ]
then
        cp $LOGFILE.3 $LOGFILE.4
        [ $? -eq 0 ] || { echo "`date`: problem rotating logfile 3 to 4" >> $LOGFILE; exit 4; }
else
        echo "`date`: info only - $LOGFILE.3 does not exist yet" >> $LOGFILE
fi

if [ -f $LOGFILE.2 ]
then
        cp $LOGFILE.2 $LOGFILE.3
        [ $? -eq 0 ] || { echo "`date`: problem rotating logfile 2 to 3" >> $LOGFILE; exit 3; }
else
        echo "`date`: info only - $LOGFILE.2 does not exist yet" >> $LOGFILE
fi

if [ -f $LOGFILE.1 ]
then
        cp $LOGFILE.1 $LOGFILE.2
        [ $? -eq 0 ] || { echo "`date`: problem rotating logfile 1 to 2" >> $LOGFILE; exit 2; }
else
        echo "`date`: info only - $LOGFILE.1 does not exist yet" >> $LOGFILE
fi

if [ -f $LOGFILE ]
then
        cp $LOGFILE $LOGFILE.1
        [ $? -eq 0 ] || { echo "`date`: problem rotating logfile 1" >> $LOGFILE; exit 1; }
else
        echo "`date`: info only - $LOGFILE does not exist yet" >> $LOGFILE
fi

exit 0
