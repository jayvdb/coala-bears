#!/usr/bin/bash

echo PATH=$PATH

_SAVEIFS=$IFS
IFS="
"
_DATACMD='reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
_DATACMD="cat reg.data"

VARS=$(reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" | sed "s/[[:space:]][[:space:]]\+/\t/g" | tail --lines=+3 | cut -d "	" -f2)
VALS=$(reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" | sed "s/[[:space:]][[:space:]]\+/\t/g" | tail --lines=+3 | cut -d "	" -f4)
#echo $VARS
#echo $VALS
ARR1=($VARS)
ARR2=($VALS)

COUNT=${#ARR1[*]}
COUNT2=${#ARR2[*]}
echo $COUNT $COUNT2
IFS=$_SAVEIFS

#read -ra ARR <<< "$VARS"
pad='                             '
for (( IDX=0 ; IDX<COUNT; IDX++ )) do
	#echo -n "${ARR1[$IDX]}"
	PAD=$(printf '%20s' ${ARR1[$IDX]})
	label=${ARR1[$IDX]}
	if [ "$label" = "USERNAME" ]; then
	  continue
	fi
	current="${!label}"
	echo "$label !! $current"
	if [ -z "$current" ]; then
	  upper_label=${label^^}
      echo "$upper_label !! $current"
	  upper_current="${!upper_label}"
	  if [ -n "$upper_current" ]; then
        label=${upper_label}
        current="${upper_current}"
      fi
    fi
	raw="${ARR2[$IDX]}"
	if [ -n "$current" ]; then
      if [ "$current" = "$raw" ]; then
        echo "${label} not changed"
        continue
      fi
    fi
    val="$raw"
	unixslashes="${val//\\/\/}"
	printfable="${unixslashes//\%/%%}"
	echo "$label ^^ $raw"

	if [ -z "$current" ]; then
	  declare "$label"="$raw"
	  new="${!label}"
	  echo "set new $label to $new"
	elif [ "$current" != "$val" ]; then
      echo "updating $label was $current"
      declare "${label}"="$val"
	  new="${!label}"
	  echo "updating $label now $new"
	fi
	echo "----"
  done
