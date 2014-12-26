#Show all messages from this boot: 
sudo journalctl -b

# show all messages from a date
sudo journalctl --since="2014-12-26 12:00:00"

#Show all messages since 20 minutes ago: 
sudo journalctl --since "20 min ago"

# same as tail -f
sudo journalctl -f -u ssh

# Show all messages by a specific process
sudo journalctl _PID=1


