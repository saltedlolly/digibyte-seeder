#  DigiByte Seeder Autostart Script
#------------------------
#  Place in the home directory
#  chmod +x /home/user/seedstartup.sh
#------------------------
#  crontab -e
#  @reboot /home/user/seedstartup.sh
#  **************_Script_**************

#!/bin/sh

SESSION="dgbseeder"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
if [ ! -d "digibyte-seeder/" ]; then
  echo "Error: digibyte-seeder directory not found. Place seedstartup.sh in your home directory!"
  exit 1
fi
if [ "$SESSIONEXISTS" = "" ]
then
    tmux new-session -d -s $SESSION
    tmux rename-window -t 0 'dgbseeder'
    tmux send-keys -t 'dgbseeder' '' C-m 'cd digibyte-seeder' C-m clear C-m './dnsseed -h seed.example.com -n server.example.com -m email.example.com -p 5353 -a 123.123.123.123' C-m
    tmux ls
else
  echo "Tmux session active! Open it with ´tmux a -t dgbseeder´"
fi

#  **************_Script_**************
