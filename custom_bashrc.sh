#! /bin/bash

######################################################
# USER-CONFIGURED VARIABLES
######################################################
# Home directory upon opening a shell
DIR_HOME=/home/${USERNAME}/

# Remote directory used for mounts (VMs)
DIR_MOUNT=/mnt/hgfs/

# Log level (0:INF, 1:ERR)
LOG_LVL=1

# Path for git master branch (if not 'master' as default)
GMASTER=HEADS:refs/for/master

######################################################
# ALIASES
######################################################
alias xremote="xcd ${DIR_MOUNT}"
alias xhome="xcd ${DIR_HOME}"

alias xls="clear && ls -lrtA"
alias dirSize="du -sh"

# git aliases
# https://stackoverflow.com/questions/35979642/what-is-git-tag-how-to-create-tags-how-to-checkout-git-remote-tags
alias fetchTags="git fetch --all --tags --prune"
alias gpull="git pull && git submodule update --init --recursive"

######################################################
# FUNCTIONS & VARIABLES
######################################################
# Log levels
LL_INF=0
LL_ERR=1

function xecho
{
  if [ $# -eq 1 ]; then
    echo "[ERR] Usage: xecho <log_level> <dbg_statement_to_echo>"
    return 1
  fi

  local print_log_lvl=""
  case $1 in
    $LL_INF) print_log_lvl="[INF]"               ;;
    $LL_ERR) print_log_lvl="[ERR]"               ;;
    *)
            echo "[ERR] Unknown log level:" $1
            return 1                            ;;
  esac

  if [ $LOG_LVL -le $1 ]; then
    echo $print_log_lvl ${@:2}
  fi
}

function xcd
{
  if [ $# -gt 1 ]; then
    xecho $LL_ERR "Usage: xcd <path>"
    return 1
  fi

  cd $1
  xls
}

function compress
{
  if [[ $1 != *.tgz || $# -lt 2 ]]; then
    xecho $LL_ERR "Usage: compress <output.tgz> <path1/input1> <path2/input2> ..."
    return 1
  fi

  tar -czvf $*
  xecho $LL_INF "Compressing" $1 "complete"
}

# https://github.com/xvoland/Extract/blob/master/extract.sh
function extract
{
  if [ $# -eq 0 ]; then
    xecho $LL_ERR "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    xecho $LL_ERR "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  fi

  for n in $@
  do
    xecho $LL_INF "Extracting " $n
    if [ -f "$n" ] ; then
      case "${n%,}" in
        *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                     tar xvf "$n"       ;;
        *.lzma)      unlzma ./"$n"      ;;
        *.bz2)       bunzip2 ./"$n"     ;;
        *.rar)       unrar x -ad ./"$n" ;;
        *.gz)        gunzip ./"$n"      ;;
        *.zip)       unzip ./"$n"       ;;
        *.z)         uncompress ./"$n"  ;;
        *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                     7z x ./"$n"        ;;
        *.xz)        unxz ./"$n"        ;;
        *.exe)       cabextract ./"$n"  ;;
        *)
                     echo "extract: '$n' - unknown archive method"
                     return 1
                     ;;
      esac
    else
        xecho $LL_ERR "'$n' - file does not exist"
        return 1
    fi
    xecho $LL_INF "Extracting" $n "done"
  done
}

function gpush
{
  xecho $LL_INF "Pushing changes to remote server..."

  case $# in
    0) git push origin master             ;;
    1) git push origin $1                 ;;
    *)
        xecho $LL_ERR "Usage: gpush <repository>"
        return 1;                         ;;
  esac

  xecho $LL_INF "Git push complete"
}

######################################################
# DEFAULT CALLS
######################################################
xhome
xecho $LL_INF "Welcome" ${USERNAME} "!"
