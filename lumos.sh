#!/bin/bash

#========================
#       FUNCTIONS
#========================
displayHelp() {
	msg=" Help page lumos(1) line %lt (press h for help or q to quit)"
	less -P "${msg}" "${scriptHelp}"
}

#========================
#       VARIABLES
#========================
scriptVersion="0.02"
scriptDir="$(dirname $0)"
scriptHelp="${scriptDir}/help.txt"
isNearMouse=0
newLux=50
moduloTest=1

#========================
#        GETOPTS
#========================
OPTIND=1    # A POSIX variable; Reset in case getopts has been used previously in the shell.
while getopts "h?m" opt; do
    case "$opt" in
    h|\?)
        displayHelp
        exit 0
        ;;
    m)  isNearMouse=1
        ;;
    esac
done

#========================
#       MAIN BLOCK
#========================
if [ $isNearMouse == 1 ] ; then
	xmessage -title "lumos v${scriptVersion}" -buttons 10%:10,20%:20,30%:30,40%:40,50%:50,60%:60,70%:70,80%:80,90%:90,100%:100 -default 50% -nearmouse "Select the desired backlight level."
	newLux=$?
else
	xmessage -title "lumos v${scriptVersion}" -buttons 10%:10,20%:20,30%:30,40%:40,50%:50,60%:60,70%:70,80%:80,90%:90,100%:100 -default 50% -center "Select the desired backlight level."
	newLux=$?
fi

moduloTest=$(expr $newLux % 10)

if [ $newLux == 1 ] ; then
	# xmessage returned 1, meaning the user closed the window or an error occured.
	exit 0
fi

if [ $newLux -lt 10 ] ; then
	echo "ERROR: xmessage returned a value too low to be an acceptable backlight percentage. [1]"
	exit 1
fi

if [ $newLux -gt 100 ] ; then
	echo "ERROR: xmessage returned a value too high to be an acceptable backlight percentage. [2]"
	exit 2
fi

if [ ! $moduloTest == 0 ] ; then
	echo "ERROR: xmessage returned a value that cannot be devided by 10 without a remainder. [3]"
	exit 3
fi

# user clicked a percentage button, everything worked.
xbacklight -set $newLux
exit 0