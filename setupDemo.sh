#! /bin/sh

HELP=$(cat<<'EOH'
#=====================================================================
# This script will install all the necessary artifacts for:
#
# "Advanced LLDB and Console Debugging Demo" By Derek Selander
# (http link here)
#
# The following will be performed:
# 1. append new LLDB commands to your .lldbinit
#    cat LLDBInitCommands.txt >> ~/.lldbinit
# 2. create directory lldb in your HOME dir
#    mkdir ~/lldb 
# 3. copy thread_return.py script to ~/lldb dir
#    cp thread_return.py ~/lldb
#
EOH
:)
USAGE=$(cat<<'EOU'
#=======================================================================
# USAGE: setupDemo.sh --help (or -h)      --> display this help message
#        setupDemo.sh --install (or -i)   --> install all demo artifacts
#        setupDemo.sh --uninstall (or -u) --> remove all demo artifacts and restore  
#=======================================================================
EOU
:)

SETUP_DIR="$(pwd)"

function errorHandler {
    local ret="$1"
    local message="$2"
    if (( $ret )) 
    then
        echo "\nERROR: $message\n" 
        exit 101
    else
        echo "OK"
    fi
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "$HELP"
  echo "$USAGE"
  exit 101
fi

if [[ -z "$1" ]]; then
    echo "$USAGE"
    exit 102
else
    action="$1"
fi

if [[ "$action" != "-i" && "$action" != "--install" && "$action" != "-u" && "$action" != "--uninstall" ]]; then
    errorHandler 1 "unkonwn option \"$action\" received \n\n$USAGE"
    echo "$USAGE"
    exit 103
fi

if [[ "$action" == "-i" || "$action" == "--install" ]]
then
    step="Verifying if install has been performed before..."
    echo "----------------------------------------------"
    echo $step
    NR_START=$(cat ~/.lldbinit| egrep -e "^#==* START ==*$"|wc -l)
    NR_END=$(cat ~/.lldbinit| egrep -e "^#==* END ==*$"|wc -l)
    if (( $NR_START + $NR_END == 2 )); then
        echo "\nIt looks like install has been run already."
        echo "You are all set\n"
        exit 0
    else
        echo "NOPE, continuing..."
    fi

    step="Looking for .lldbinit ..."
    echo "----------------------------------------------"
    echo $step
    ls -1 ~/.lldbinit > /dev/null 2>&1
    if (( $? )); then  
        echo "can not find ~/.lldbinit. Creating it ..."
        (cat /dev/null > ~/.lldbinit) > /dev/null 2>&1
        errorHandler $? "could not create ~/.lldbinit"
    else
        echo "OK"
    fi

    step="Making a backup of .lldbinit ..."
    echo "----------------------------------------------"
    echo $step
    cp ~/.lldbinit ~/.lldbinit.setupDemo.BKP
    errorHandler $? "could not create backup of ~/.lldbinit"

    step="Appending new LLDB commands to .lldbinit ..."
    echo "----------------------------------------------"
    echo $step
    cat $SETUP_DIR/LLDBInitCommands.txt >> ~/.lldbinit
    errorHandler $? "could not append to ~/.lldbinit"

    step="Making  ~/lldb directory ..."
    echo "----------------------------------------------"
    echo $step
    mkdir ~/lldb > /dev/null 2>&1
    errorHandler $? "could not make ~/lldb directory"

    step="Copying thread_return.py to ~/lldb ..."
    echo "----------------------------------------------"
    echo $step
    PY_SCRIPT="thread_return.py"
    cp $SETUP_DIR/$PY_SCRIPT ~/lldb/$PY_SCRIPT > /dev/null 2>&1
    errorHandler $? "could not copy thread_run.py to ~/lldb directory"

CONGRATS_MESSAGE=$(cat<<'EOM'
\nCongratulations, you now have added several new lldb commands that can be used to aid you while debugging.

#============================================================================
cpo      - Forces an Objective-C context for printing 
           an object's description 'po object'
cp       - Forces an Objective-C context for printing 
           an object 'p object'
spo      - Forces a Swift context for printing an 
           object's description 'po object'
sp       - Forces a Swift context for printing an 
           object 'po object'
iheap    - A convenience command to import a script 
           to search for instances in memory
ireturn  - A breakpoint action command that will print 
           the return value of a breakpoint function for 64-bit assembly
ff       - Flush the screen and perform any updates.  Useful if 
           you want to see the change setAlpha: while paused in the debugger
#============================================================================
\n
EOM
:)
    echo "$CONGRATS_MESSAGE"
else
    step="Restoring .lldbinit from backup..."
    echo "----------------------------------------------"
    echo $step
    mv ~/.lldbinit.setupDemo.BKP ~/.lldbinit > /dev/null 2>&1
    errorHandler $? "could not restore ~/.lldbinit"

    step="Removing  ~/lldb directory ..."
    echo "----------------------------------------------"
    echo $step
    rm -rf ~/lldb > /dev/null 2>&1
    errorHandler $? "could not remove ~/lldb directory"

    echo "\nUninstall completed successfully\n"
fi

