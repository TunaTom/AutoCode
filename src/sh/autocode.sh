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
TEST="${1}"
. ${SKRIPTS}/settings.sh

mkdir -p ${WORKDIR}

NEGATIVE_FILE=${INPUTDIR}/negativ.txt
POSITIVE_FILE=${INPUTDIR}/positiv.txt
DEFAULT_CODE_FILE=${INPUTDIR}/sonstiges.txt

STRUCT=${SKRIPTS}/struct.sh
CAT_AS_OR=${SKRIPTS}/catAsOr.sh

function correlateCodes() {
	STRUCT_PROGRAMM="${1}"
	POSITIVLISTE="${2}"
	NEGATIV_EXPRESSION="${3}"
	OTHER_CODING="${4}"

	## iterate the programm 
	while read SATZ; do
		##iterate the pos-list and match each sentence against the signal
		USE_CODE=""
		while read CODE SIGNAL; do
			echo "${SATZ}" | grep -E -i -v -e "${NEGATIV_EXPRESSION}" | grep -E -i -e "${SIGNAL}" 2>&1 > /dev/null
			if [ "$?" == "0" ]; then
				USE_CODE="${CODE}"
				break
			fi
		done < ${POSITIVLISTE}
		USE_CODE=${USE_CODE:-${OTHER_CODING}}
		echo "${USE_CODE}|${SATZ}"
	done < ${STRUCT_PROGRAMM}
}

for INPUT_FILE in ${TARGETDIR}/*.txt; do
	INPUT_FILE_NAME=`basename ${INPUT_FILE}`
    echo "Working on ${INPUT_FILE_NAME}" >&2
	BASENAME=${INPUT_FILE_NAME%*.txt}
	STRUCT_FILE=${WORKDIR}/01_${BASENAME}_struct.txt
	
	${STRUCT} ${INPUT_FILE} > ${STRUCT_FILE}
	echo "  struct file done" >&2
	NEGATIVE_EXPRESSION=`${CAT_AS_OR} ${NEGATIVE_FILE}`
	DEFAULT_CODE=`cat ${DEFAULT_CODE_FILE}`
	
	if [ -z "${TEST}" ]; then
		AUTOCODE_FILE=${WORKDIR}/02_${BASENAME}_autocode.txt
		exec 1>${AUTOCODE_FILE}
	fi

	echo "  correlating codes" >&2
	correlateCodes ${STRUCT_FILE} ${POSITIVE_FILE} "${NEGATIVE_EXPRESSION}" ${DEFAULT_CODE}
done