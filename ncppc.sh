#!/bin/bash

#Must be an absolute dir
SHEETFOLDER="/home/samk/Programacion/ncppc"

help(){
	# display usage if no parameters given
    echo "Usage: ncppc [options]"
    echo "Options:"
    echo -e "\t -f\tdestination folder"
    echo -e "\t -c\tclass name [obligatory]"
    echo -e "\t -v\tverbose output"
    echo -e "\t -i\twrite to files"
    echo -e "\t -h\tshows this help"
}

#If no commands, then inform user
if [ -z "$1" ]; then
    help
    exit
fi

#Variables
FOLDER=""
NAME=""
VERBOSE=false
WRITE=false
FNAMES=(".h" ".cpp")
SHEETS=("SHEET.h" "SHEET.cpp")

#The options
while getopts "f:c:vih" opt; do
  case $opt in
    f)
      FOLDER=$OPTARG
      ;;
    c)
	  NAME=$OPTARG
      ;;
    v)
	  VERBOSE=true
	  ;;
	i)
	  WRITE=true
	  ;;
	h)
	  help
	  exit
	  ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

#Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

#Check if any name was given
if [ -z "$NAME" ]; then
	echo "${red}ERROR!! No name was given. Use option \"-n\", followed by the class name.${reset}"
	exit 1
else
	for i in 1 2 ; do
		FNAMES[$i-1]=${NAME,,}${FNAMES[$i-1]}
	done
fi

#Lets configure the sheets
if [ ! -z $SHEETFOLDER ]; then
	for i in 1 2 ; do
		SHEETS[$i-1]=${SHEETFOLDER}"/"${SHEETS[$i-1]}
	done
fi

#Chek the output folder
if $VERBOSE; then
	if [ -z "$FOLDER" ]; then
		echo "The output folder will be this one."
	else
		echo "Output folder: "$FOLDER
	fi
fi

#Append folder if it's available
if [ ! -z "$FOLDER" ]; then
	if [ ! -d "$FOLDER" ]; then
		if $VERBOSE; then
			echo "The folder doesn't exist, creating it."
		fi
  		mkdir -p $FOLDER
	fi
	for i in 1 2 ; do
		FNAMES[$i-1]=${FOLDER}"/"${FNAMES[$i-1]}
	done
fi

#If verbose show the files
if $VERBOSE ; then
	echo "File names:"		
	for fn in ${FNAMES[@]}; do
		echo "	"$fn
	done
fi

#Function to print stuff
printstuff(){
	if $VERBOSE; then
		echo -e $1
	fi
}

#Lets put the output file
if $WRITE; then
	printstuff "Writing to files"
	printstuff "Header file (${FNAMES[0]})"
	sed -e s/SHEET_H/${NAME^^}"_H"/g ${SHEETS[0]} | sed -e s/SHEET/$NAME/g > ${FNAMES[0]}
	printstuff "Source file (${FNAMES[1]})"
	sed -e s/SHEED/${NAME,,}/g ${SHEETS[1]} > ${FNAMES[1]}
else
	if $VERBOSE; then
		echo "Writing to files"
		echo -e "\n====Header file (${FNAMES[0]})===="
		sed -e s/SHEET_H/${NAME^^}"_H"/g ${SHEETS[0]} | sed -e s/SHEET/$NAME/g
		echo "==================="
		echo -e "\n====Source file (${FNAMES[1]})===="
		sed -e s/SHEET/${NAME,,}/g ${SHEETS[1]}		
		echo "==================="
	fi
fi
