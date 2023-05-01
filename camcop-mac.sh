#!/bin/bash

PROGPATH=$(dirname $_)
cd $PROGPATH

echo -n -e "\033]0;CamCop\007"
FILE=./pushover.json

echo -e '\nCamCop (macOS) now running on machine:user <<'$(hostname)':'$(whoami)'>>\n'

if test -f "$FILE"; then
	echo -e '\tLaunch time: '$(date +"%T")
	echo -e '\nScanning...\n'
	exec log stream |
		/usr/bin/grep -E --line-buffered 'AVCaptureSession_Tundra (start|stop|_stop)' | 
		while read -r event; do
			echo *==========*==========*==========*==========*
			echo -e 'Camera Event Occured:  '$(date +"%T")'\n'
			echo $event
			python camevent.py $event
			echo *==========*==========*==========*==========*
			echo -e '\nScanning...\n'
		done
else
	echo
	echo Pushover Keys file \<pushover.json\> not found.
	echo Please refer to setup instructions for creating this file.
	echo
	read -p "Press anything to quit CamCop."
	osascript -e 'tell application "Terminal" to close (every window whose name contains "CamCop")' & exit
fi