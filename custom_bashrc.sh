#! /bin/bash

######################################################
# VARIABLES
######################################################

# Home directory upon opening a shell
DIR_HOME=/home/${USERNAME}/local_proj

# Remote directory used for mounts (VMs)
DIR_MOUNT=/mnt/hgfs/D

# Enables (1) and disables (0) debug logging
DBG=1

######################################################
# ALIASES
######################################################
alias xremote="cd ${DIR_MOUNT} && xls"
alias xhome="cd ${DIR_HOME} && xls"

######################################################
# FUNCTIONS
######################################################
function xls() {
  clear && ls -lrtA $1
}

function xcd() {
  if [ $# -lt 2 ]; then
    cd $1
  fi
  xls
}

function xdirSize() {
  du -sh $*
}

function xdbgEcho() {
  if [ $# -ne 0 ]; then
    if [ $DBG -eq 1 ]; then
      echo "[DBG]" $*
    fi
  fi
}

######################################################
# DEFAULT CALLS
######################################################
xhome

xdbgEcho "$DIR_MOUNT"
xdbgEcho "$DIR_HOME"

