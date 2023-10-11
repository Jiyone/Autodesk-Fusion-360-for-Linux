#!/bin/bash

# This script compares the local Fusion 360 installation file with the one on the Autodesk server and if the two are different, then an update task should be executed later!

Local_Fusion360_Installer=$(wc -c < $HOME/.fusion360/resources/downloads/Fusion\ 360\ Admin\ Install.exe)
Remote_Fusion360_Installer=$(curl -sI https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Admin%20Install.exe | awk '/Content-Length/ {sub("\r",""); print $2}')
if [ $Local_Fusion360_Installer != $Remote_Fusion360_Installer ]; then
echo "Not the same size."
else
echo "Same size."
fi
