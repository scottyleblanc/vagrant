# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# ----------------------------------------------------------------------------#
# Pick an editor
# ----------------------------------------------------------------------------#
EDITOR=vi ;export EDITOR
# ----------------------------------------------------------------------------#
#  Alias and Functions
# ----------------------------------------------------------------------------#
alias archive='tar -cvf $1 $2' # Tar all files in directory
alias big5='du -cs * | sort -rn | head -5' # Find top 5 big files
alias chgrp='chgrp --preserve-root' # Preserve root permissions
alias chmod='chmod --preserve-root' # Preserve root permissions
alias chown='chown --preserve-root' # Preserve root permissions
alias cpuinfo='less /proc/cpuinfo' # Get server cpu info
alias da='date "+%Y-%m-%d %A %T %Z"' # 2014-04-24 Thursday    10:31:47 ADT
alias df='df -Ph' # mount space human readable, POSIX format
alias dirs='ls -ld */' # Show only directories
alias dns='cat /etc/resolv.conf;echo; ( [ -f /etc/nsswitch.conf ] && cat /etc/nsswitch.conf)' # DNS Names
alias du='du -ch' # File Space Total Human Readable
alias f.='find . -type f -name $1' # Find files ignore directories
alias fastping='ping -c 100 -s.2'  # Faster Ping
## alias ft='find . -type f -printxargs | grep -i ' # Find text in all files
alias gh='cat ~/.bash_history | grep ' # Grep history file for command
alias grep='grep --color=auto' # colorize grep
alias hogs='du -sk * | sort -rn | head ' # Show biggest files in directory
alias lc='ls -lcr' # sort by change time
alias lk='ls -lSr' # sort by size
alias lm='ls -al | more' # pipe through 'more'
alias ln='ln -i' # Prompt when linking files
alias lr='ls -lR' # recursive ls
alias lt="ls -laFtu | more" # Modified time/dir,file,executable
alias lt='ls -ltr' # sort by date
alias lu='ls -lur' # sort by access time
alias lx='ls -lXB' # sort by extension
alias lsnew='ls -al --time-style=+%D | grep `date +%D`' # List Todays Files
alias meminfo='free -m -l -t' # Display memory information
alias newest='ls -dt * | head -9' # Show newest file
alias openports='netstat -nape --inet' # List All Open Ports
alias oraset='. /usr/local/bin/oraset' # set oracle environment
alias pg='ps -auxf | grep ' # Grep for Process - requires an argument
alias ports='netstat -tulanp' # List all TCP/UDP ports on server
alias prof='source ~/.bashrc' # Reload .bashrc
alias psg='ps -ef | grep ' # Grep for Process
alias sarcpu='sar -u 1 10' # cpu stats
alias sario='sar -b 1 10' # io stats
alias sarmem='sar -r 1 10' # mem stats
alias sarnet='sar -n DEV 1 10' # network statistics
alias sarrunq='sar -q 1 10' # run queue stats
# show top cpu consuming processes
alias topc='/usr/bin/watch '\''ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | head -n 6'\'''
# show top memory consuming processes
alias topm='/usr/bin/watch '\''ps -Ao user,uid,comm,pid,pmem,tty --sort=-pmem | head -n 6'\'''
# Find files that allow writing by others
alias unsafe='echo Vulnerable: ; find $HOME -perm -o+w -type f'
alias untar='tar -xvf $1' # UnTar all files in directory
alias which='alias | which --tty-only --read-alias --show-dot --show-tilde'
alias rmn='rman target / catalog=rmancatalog/rmancatalog@rman'
alias dg='dgmgrl sysdg/oracle_4U'
alias ta='tail -f /u01/app/oracle/diag/rdbms/cdb1_stby/cdb1/trace/alert_cdb1.log'
alias tdg='tail -f /u01/app/oracle/diag/rdbms/cdb1_stby/cdb1/trace/drccdb1.log'
function cps()
{
  if test ! -s "$2"
	then cp "$1" "$2"
  else echo "cps: Cannot copy $1: $2 exists"
	fi
}

function dostounix() # convert file from dos format to unix
{
	sed -i 's/\r//' $1
}

function envs() #  Display environment variables in sorted order
{
    if test -z "$1"
      then env | sort
      else env | sort  | grep -i $1
    fi
}

function fld() #  find large directories
{
  du -S .  sort -nr  head -10
}

function flf() #  find large files
{
  find . -ls  sort -nrk7  head -10
}

function la() # List all files including hidden
{
	ls -la "$@";
}

function netinfo () # NetInfo Function
{
   echo "--------------- Network Information ---------------"
   /sbin/ifconfig  awk /'inet addr/ {print $2}'
   /sbin/ifconfig  awk /'Bcast/ {print $3}'
   /sbin/ifconfig  awk /'inet addr/ {print $4}'
   /sbin/ifconfig  awk /'HWaddr/ {print $4,$5}'
   echo "---------------------------------------------------"
}

