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

# autocode ist Freie Software: Sie k�nnen es unter den Bedingungen
# der GNU General Public License, wie von der Free Software Foundation,
# Version 3 der Lizenz oder (nach Ihrer Option) jeder sp�teren
# ver�ffentlichten Version, weiterverbreiten und/oder modifizieren.

# autocode wird in der Hoffnung, dass es n�tzlich sein wird, aber
# OHNE JEDE GEW�HELEISTUNG, bereitgestellt; sogar ohne die implizite
# Gew�hrleistung der MARKTF�HIGKEIT oder EIGNUNG F�R EINEN BESTIMMTEN ZWECK.
# Siehe die GNU General Public License f�r weitere Details.

# Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
# Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.


## Place each sentence in a single line - empty lines are removed.

## Remove all linebreaks (join all lines into one). This is for inputs where single sentences span multiple lines
## Find all .?!; , which are not preceded by a number and that are not at the end of the line.
## Append a linebreak.
## Replace multiple consecutive whitespaces with a single space.
## That way, sentences are placed in a line of their own, but p.e. "der 22. September" is not.
## Afterwards ignore lines that contain only whitespace
cat ${1} | tr '\r\n' ' ' | sed -e 's/\([^0-9][\.?!;]\)\w*[^$]/\1\n/g' -e 's/[ \t]\+/ /g' | grep -v "^\w*$"