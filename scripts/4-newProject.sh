#!/bin/bash
if [ $# -eq 0 ]; then
    echo "ERR: No name specified"
else
	cp -r ../sff-love ../workspace/$1
	cp ../ui/build/ui.love ../workspace/$1/jamhammer.love
	echo "Project $1 created in $(pwd)/../workspace/$1."
fi

