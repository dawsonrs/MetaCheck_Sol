#!/bin/ksh

##  script to monitor the health of Solaris volume Manager
##
##  this will produce a log file which will need to be housekept
##  the script metalogrotate.ksh has been written to do this
##
##  "problem" is a common string between this script and metalogrotate.ksh
##  This allows for a log watcher to alert on this common string
##
##  Robert Dawson
##  Fujitsu Services
##  23/06/2010
##
##  v0.1
##

##
##  Some housekeeping
##

#  file to log all output to
OUTFILE=/var/log/metacheck.log

#  status flag
STATUS=GOOD 

#  before we begin, ensure the log file exists and enter a datestamp for today
[ -f "$OUTFILE" ] || touch "$OUTFILE"
date > "$OUTFILE"

##
##  Monitor the health of the metastate replica databases
##

# uppercase flags will indicate problems.  Test for these.
db_problem=`metadb | sed 1d | awk -F\t '{if ($1 ~ /[A-Z]/) print $1,$6;}'`
if [ -n "$db_problem" ]
then
	echo "metadb problem: $db_problem" >> "$OUTFILE"
	echo "For more detail, run metadb command" >> "$OUTFILE"
	STATUS=BAD
fi
[ "$STATUS" = GOOD ] && echo "MetaDB checks passed" >>"$OUTFILE"

##
##  Monitor the health of metadevices
##

##  possible states here are:
##	Okay
##	Resyncing
##	Needs maintenance
##	Erred
##	Last erred
##	Unavailable

#  define temporary file for working with
metastat_f=/tmp/metastat_f

#  if it does not exist, create it
[ -f "$metastat_f" ] || touch "$metastat_f"

#  if it is not empty, then empty it
[ -n "$metastat_f" ] && > "$metastat_f"

#  test for each of the possible error states and populate the temp file if errors exist
#  the below will return the matching line plus 1 above and below
#  this ensures the state and also the device affected are captured
metastat | sed -n -e '/State: Resyncing/{x;1!p;g;$!N;p;D;}' -e h >> "$metastat_f"
metastat | sed -n -e '/State: Needs maintenance/{x;1!p;g;$!N;p;D;}' -e h >> "$metastat_f"
metastat | sed -n -e '/State: Erred/{x;1!p;g;$!N;p;D;}' -e h >> "$metastat_f"
metastat | sed -n -e '/State: Last erred/{x;1!p;g;$!N;p;D;}' -e h >> "$metastat_f"
metastat | sed -n -e '/State: Unavailable/{x;1!p;g;$!N;p;D;}' -e h >> "$metastat_f"

#  now, if the file is non-empty, report a problem
if [ -s "$metastat_f" ]
then
	echo "metastat problem: " >>"$OUTFILE"
	cat "$metastat_f" >>"$OUTFILE"
	echo "For more detail, run metastat command" >>"$OUTFILE"
	STATUS=BAD
fi
[ "$STATUS" = GOOD ] && echo "Metastat checks passed" >>"$OUTFILE"

# delete the temporary file now that we are finished with it
rm "$metastat_f"

#  now a test to output a message if the status is fine
[ "$STATUS" = GOOD ] && echo "All SVM checks passed" >>"$OUTFILE"

exit 0
