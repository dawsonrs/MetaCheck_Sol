# MetaCheck_Sol
Solaris Volume Manager (SVM) health check script

##  script to monitor the health of Solaris volume Manager
##  script to housekeep the log file produced by the script above
##
##  metacheck.ksh will produce a log file which will need to be housekept
##  metalogrotate.ksh has been written to do this
##
##  "problem" is a common string between this script and metalogrotate.ksh
##  This allows for a log watcher to alert on this common string

How to run: 
one-off:
execute metacheck.ksh without arguments by hand locally on any server or use whatever automation tooling is available.
scheduled:
cron metacheck.ksh and metalogrotate.ksh as appropriate (no arguments needed)
