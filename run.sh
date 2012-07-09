currentDir=${0%run.sh}
PATH="$PATH:${currentDir}/bin"

${currentDir}/src/sh/${@}
