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
TARGETDIR="${1}"
. ${SKRIPTS}/settings.sh

function manualCode() {
	OLDIFS=${IFS}

	echo > ${MANUALCODE_FILE}

	IFS="|"
	while read CODE SATZ; do
		echo "${SATZ}"
		read -e -p "Code: [${CODE}]" CORRECT_CODE </dev/tty
		CORRECT_CODE=${CORRECT_CODE:-${CODE}}
		if [ "${CODE}" != "${CORRECT_CODE}" ]; then
			echo "  Changing code from ${CODE} to ${CORRECT_CODE}"
		fi
		echo "${CORRECT_CODE}|${SATZ}" >> ${MANUALCODE_FILE}
	done < ${INPUT_FILE}

	IFS=${OLDIFS}
}

for INPUT_FILE in ${WORKDIR}/02_*_autocode.txt; do
	INPUT_FILE_NAME=`basename ${INPUT_FILE}`
	BASENAME=${INPUT_FILE_NAME%*_autocode.txt}
	BASENAME=${BASENAME#02_*}

	MANUALCODE_FILE=${WORKDIR}/03_${BASENAME}_manualCode.txt

	manualCode
done