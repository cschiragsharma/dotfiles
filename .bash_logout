# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    # kill current ssh-agent
    . ~/.ssh_agent.sh
# FIXME: need to add some inteligence to this
#    ssh-add -d
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
	svn ci ~/.${USER}_home_svn -m "you forgot to commit changes again on $HOSTNAME"
fi


#vim: ft=sh