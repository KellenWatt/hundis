#!/bin/bash
# Typing different out the numerous compilation commands for various languages 
# is tedious, so why do it? "compile" determines the dominant language file 
# type, then runs the associated compiler/interpreter. Also, if a makefile 
# exists in the current directory, that will be used instead of the 
# determination algorithm. If the result is ambiguous, a specific compiler 
# can be provided, which is then invoked.
#
# Languages left out for now:
#     Julia, Swift, Lua, R
# -These languages are not readily compilable and provide no reasonable syntax 
# checking or have too elaborate a project structure to be considered usable for 
# the purposes of this script. 
# -If/when these languages become compilable and/or get decent syntax checking 
# without execution, a compilation interface will be added below. 
# -Until these languages gain support, using some form of makefile is the 
# recommended alternative.

# used for combining multiple interpreted files together into one, while maintaining
# some form of dependency checking i.e. keeping main at the bottom, and assuming the
# rest of the files are libraries of some sort.

# TODO: Refactor the compile instructions to external files in specific directory. 
# should allow for much more maintainable code.

exclude(){
    exc=( "rails" )
    for e in $exc; do
        if [[ $1 =~ $e ]]; then
            echo "This directory cannot be individually compiled, due to its filepath containing \"$e\"." >&2
            exit 1
        fi
    done
}

combine(){
    main=""
    for file in ${@:2} ; do
        if [[ $(awk 'NR==2 {print $0}' $file) == "#main" ]] ; then
            main=$file
        else
            if [[ $(head -n 1 $file | cut -d '/' -f 1) == '#!' ]] ; then
                awk 'NR>2 {print $0}' $file >> $1
            else
                cat $file >> $1
            fi
        fi
    done
    if [[ "$main" != "" ]] ; then    
        if [[ $(head -n 1 $main | cut -d '/' -f 1) == '#!' ]] ; then
            awk 'NR>3 || NR==2 {print $0}' $main >> $1
        else
            cat $main >> $1
        fi
    fi
}

# Go compiles with different commands, this determines appropriate command
gocompile(){
    type=$(head -n1 $1 | awk 'NR==1 {print $2}')
    if [[ "$type" == "main" ]] ; then
        # if the file is an executable main
        go build
    else
        # if the file is a library
        go install
    fi
}

# this sort of works... it inserts the files alphabetically
rbmake(){
    name=${PWD##*/}
    ruby -c $* > /dev/null
    if [[ $? -eq 0 ]] ; then
        echo -e "#!$(which ruby)\n" > $name
        combine $name $*
        chmod +x $name
    fi
}

# Does not support python 3
# Same issue as ruby function
pymake(){
    name=${PWD##*/}
    python -m py_compile *.py
    if [[ $? -eq 0 ]] ; then
        rm *.pyc
        echo -e "#!$(which python)\n" > $name
        combine $name $*
        chmod +x $name
    fi
}

py3make(){
    name=${PWD##*/}
    python3 -m py_compile *.py3
    if [[ $? -eq 0 ]] ; then
        rm -rf __pycache__
        echo -e "#!$(which python3)\n" > $name
        combine $name $*
        chmod +x $name
    fi 
}

asm(){
    name=${PWD##*/}
    for each in $* ; do
        nasm -f elf64 $each
    done
    ld -o $name *.o
    rm *.o
}

# convenience function, strictly to keep it out of compi, below
cppcomp(){
    g++ -std=c++11 -Wall -W -s -pedantic-errors $*
}

langs=( "c++"       "java"   "go"        "python" "C#"   "asm"   "D"   "ruby"   "lisp"     "python3" )
exten=( "cpp h hpp" "java"   "go"        "py"     "cs"   "s"     "d"   "rb"     "lisp"     "py3"     )
cfile=( "*.cpp"     "*.java" "*.go"      "*.py"   "*.cs" "*.s"   "*.d" "*.rb"   "*.lisp"   "*.py3"   )
compi=( "cppcomp"   "javac"  "gocompile" "pymake" "mcs"  "asm"   "gdc" "rbmake" "clisp -q -c" "py3make" )
count=( 0           0        0           0        0      0       0     0        0          0         )

# The number of languages is pre-computed for efficiency (not that it really matters much)
LANGS=${#compi[@]}

# Prevent compilation of invalid code, such as individual Ruby on Rails files.
exclude $PWD

if [[ $# -ne 0 ]] ; then
    #if specific compiler given
    compdex=-1
    for ((i=0; i<$LANGS; i++)) do
        if [[ $1 == ${compi[$i]} || $1 == ${langs[$i]} ]] ; then
            compdex=$i
            break
        fi
    done
    if [[ $compdex -eq -1 ]] ; then
        echo "Error: No such compiler"
        exit 1
    fi
    ${compi[$compdex]} ${cfile[$compdex]}
    exit $?
elif [[ -e makefile || -e Makefile ]] ; then
    # if there is a makefile
    make
    exit $?
else
    # generic compiler determination
    # determine number of usable files per filetype
    for ((i=0; i<$LANGS; i++)) do
        for file in ${exten[$i]} ; do
            for num in $(ls *.${file} 2> /dev/null) ; do
                ((count[$i]++))
            done
        done
    done
    # could probably merge below loop with above. Probably too tedious
    # determine language with most supported files
    maxdex=0
    for ((i=0; i<$LANGS; i++)) do
        if [[ ${count[$i]} -gt ${count[$maxdex]} ]] ; then
            maxdex=$i
        fi
    done
    # if maxdex hasn't changed, then nothing higher than count[0]
    # if count[0] == 0, then there are no supported files
    if [[ $maxdex == 0 && ${count[$maxdex]} == 0 ]] ; then
        echo "Error: No accepted languages or makefiles exist in this directory"
        exit 2
    fi
    # determine if there is an ambiguous compilation
    # i.e. two languages have the same non-zero number of files.
    for ((i=0; i<$LANGS; i++)) do
        if [[ ${count[$i]} -eq ${count[$maxdex]} && $maxdex -ne $i ]] ; then
            echo "Error: Ambiguous compilation"
            exit 3
        fi
    done
    # Finally, run the determined compiler with the determined files.
    ${compi[$maxdex]} ${cfile[$maxdex]}
    exit $?
fi

