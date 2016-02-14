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
#=======================================================================
# USAGE: setupDemo.sh --help (or -h)      --> display this help message
#        setupDemo.sh --install (or -i)   --> install all demo artifacts
#        setupDemo.sh --uninstall (or -u) --> remove all demo artifacts and restore  
#=======================================================================
