# Description
This is a collection of simple scripts that can be used to semi-automatically analyze the 
programs of political parties.

Create a list of positive signal words and their corresponding code-number in this format:
```
CODE_A signal_a1|signal_a2
CODE_B signal_b1|signal_b2|signal_b3
```
Each code should occur only once.

Create a list of negative signal words, one word per line.
The input text files are read one after another and each sentence that matches one
entry of the positive list and no entry of the negative list, is correlated with the
CODE of the signal word. Else, the default code will be used.
After all text files have been processed, a manual step allowes the user
to correct the correlated CODE number manually.
Last, the codes are summed up and output into a csv-file that can be read into Excel
for further processing.

The following conventions must be adhered to, if you want easy and no-probs processing:
- name of positive list: codes/positiv.txt
- name of negative list: codes/negativ.txt
- name of fallback code file: codes/sonstiges.txt (must contain only one code)
- name of each text-file: <summedBy>_whatever_you_want.txt (summedBy is displayed in the Excel file)
- name of directory with text files: ParteiProgramme.

# Software and License
## bin-directory
The skripts totally depend on Free Software like bash, sort, sed or grep. The package contains a 
bin directory with the msysgit-incarnations of the necessary programs. All of these programs are 
distributed under the GPL, which means that whenever you distribute a binary version of that program,
you must make a source-code version available (inkl. the build scripts etc.), too. If you didn't change
the source (like I did), you can find it all here: http://code.google.com/p/msysgit/downloads/list

## all other directories (esp. src)
All files in the directory src are (c) 2012 by Tom Vollerthun.
These files are part of autocode.
autocode is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

autocode is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with autocode.  If not, see <http://www.gnu.org/licenses/>.

Diese Datei ist Teil von autocode.

autocode ist Freie Software: Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation,
Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren
veröffentlichten Version, weiterverbreiten und/oder modifizieren.

autocode wird in der Hoffnung, dass es nützlich sein wird, aber
OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
Siehe die GNU General Public License für weitere Details.

Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.