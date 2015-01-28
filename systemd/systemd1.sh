# displays the all units and their status
systemctl

# same with above
systemctl list-units

# ssh unit file is loaded, active at statup and running now
systemctl list-units | grep ssh

systemctl --failed

# boot time statistics
sudo systemd-analyze

# list all runnint unit and their initialization time
sudo systemd-analyze blame

# question
systemd-analyze plot > `hostname`.svg

# Units can be, for example, services (.service), mount points (.mount), devices (.device) or sockets (.socket). 
# normally the suffix shoule be defined, if not .service is the default thing 
# ssh and ssh.service are same

systemctl status ssh

# we will see the ssh is stopped, but we still have connection
systemctl stop ssh

# checking the status also says the same thing
systemctl status ssh

# checking the log message of a unit
sudo journalctl -u ssh

# tail -f
sudo journalctl -f -u ssh

# the sshd is still running, that is because of the ESTABLISHED connection
sudo ps -efl | grep ssh

# logout and you will see sshd will be dead
# there is a process running for each connection

sudo systemctl start ssh

# some other useful commands for systemctl
# enabling the unit at boot time
systemctl enable ssh
# disabling the unit at boot time
systemctl disable ssh

# it is possible to use systemctl command to reboot or shutdown the machine
systemctl reboot

systemctl shutdown 

systemctl suspend / hibernate / hybrid-sleep
