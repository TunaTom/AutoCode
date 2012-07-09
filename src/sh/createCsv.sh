#!/bin/bash
# (c) 2012 by Tom Vollerthun. 
#
# This file is part of autocode.
# autocode is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# autocode is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with autocode.  If not, see <http://www.gnu.org/licenses/>.

# Diese Datei ist Teil von autocode.

# autocode ist Freie Software: Sie können es unter den Bedingungen
# der GNU General Public License, wie von der Free Software Foundation,
# Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren
# veröffentlichten Version, weiterverbreiten und/oder modifizieren.

# autocode wird in der Hoffnung, dass es nützlich sein wird, aber
# OHNE JEDE GEWÄHELEISTUNG, bereitgestellt; sogar ohne die implizite
# Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
# Siehe die GNU General Public License für weitere Details.

# Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
# Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.

SKRIPTS=`dirname ${0}`
. ${SKRIPTS}/settings.sh

TEST=${1}

CREATE_CSV=${SKRIPTS}/createCsv.sh

OUTPUTFILE=${WORKDIR}/endziel.csv

MANUAL_STEP=03

function getAllCodes() {
	sed 's/\(.*\)|.*/\1/g' ${WORKDIR}/*_manualCode.txt | sort | uniq | tr "\n" " " | tr "\r\n" " "	
}

function getCodeCount() {
	echo ${1} | wc -w | sed 's/ *\(.*\) */\1/'
}

function getCodeCountPlusOne() {
    CODE_COUNT=`getCodeCount "${1}"`
	echo "$(( CODE_COUNT + 1 ))"
}

function getAllParties() {
	ls ${WORKDIR}/*manual*.txt | sed -n "s#${WORKDIR}/${MANUAL_STEP}_\([^_]*\).*#\1#p" | sort | uniq | tr "\n" " "
}

function writeHeader() {
	ALL_CODES="${1}"
	CODES_PLUS_ONE=`getCodeCountPlusOne "${ALL_CODES}"`

	echo "Writing header" >&2
	
	echo -n "'ID;Partei;"
	for CODE in ${ALL_CODES}; do
		echo -n "${CODE};"
	done
	echo -n "Sum total;"
	for CODE in ${ALL_CODES} total; do
		echo -n "=\"per \"&ZS(-${CODES_PLUS_ONE});"
	done
	echo
}

function countOccurences() {
	grep -c ${1} ${2}/*${3}*manual*.txt | while read x
	do
		let sum=$sum+${x#*:}
		echo "$sum"
	done | tail -1
}

function writeLine() {
	ALL_CODES=${1}
	PARTY=${2}
	
	CODES_COUNT=`getCodeCount "${ALL_CODES}"`
	CODES_PLUS_ONE=`getCodeCountPlusOne "${ALL_CODES}"`
	
	echo -n ";${PARTY};"
	for CODE in ${ALL_CODES}; do
		echo "Sum the occurences of $CODE in all manual txt-files for $PARTY" >&2
		SUM=`countOccurences ${CODE} ${WORKDIR} ${PARTY}`
		echo -n "${SUM};"
	done
	echo -n "=SUMME(ZS(-${CODES_COUNT}):ZS(-1));"
	
	CURRENT_COL=1
	for CODE in ${ALL_CODES} total; do
		echo -n "=ZS(-${CODES_PLUS_ONE})/ZS(-${CURRENT_COL});"
		CURRENT_COL=$(( CURRENT_COL + 1 ))
	done
	echo
}

function writeAllLines() {
	ALL_CODES="`getAllCodes`"
	writeHeader "${ALL_CODES}"
	
	for PARTY in `getAllParties`; do
		echo "Writing line for ${PARTY}" >&2
		writeLine "${ALL_CODES}" ${PARTY}
	done
}

if [ -z "${TEST}" ]; then
	exec 1>${OUTPUTFILE}
fi

writeAllLines
