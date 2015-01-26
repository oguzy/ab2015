## Installation

At the server side

```
apt-get install -y nagios3 nagios-nrpe-plugin
```

Choose Internet Site and for FQDN use something like mail.example.com
Write an admin passwd for nagios admin site

```
vim /etc/postfix/main.cf
```

and add the below lines

```
relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/postfix/cacert.pem
smtp_use_tls = yes
```

check main.cf sample, control the mydestination part

```
vim /etc/postfix/sasl_passwd
```

Add the following line

```
[smtp.gmail.com]:587    myfancymailtest@gmail.com:PASSWORD
```

Fix permissions and update postfix config

```
sudo chmod 400 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
```

validate cert

```
cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem
```
```
sudo /etc/init.d/postfix reload
```

Test: echo "Test mail from postfix" | mail -s "Test Postfix" myfancymailtest@gmail.com

if you need to change the nagiosadmin password later

```
htpasswd -c /etc/nagios3/htpasswd.users nagiosadmin
service nagios3 restart && service apache2 restart
```

Nagios need some configuration

```
usermod -a -G nagios www-data
chmod -R g+x /var/lib/nagios3/
sed -i 's/check_external_commands=0/check_external_commands=1/g' /etc/nagios3/nagios.cfg
```

Check ipaddr_of_nagios_server/nagios3

# Explanation
/etc/nagio3/commands.cfg
contacts_nagios2.cfg
generic-host_nagios2.cfg
hostgroups_nagios2.cfg ve localhost.cfg add testserver
services_nagios2.cfg: /usr/lib/nagios/plugins/ run check_http -H localhost
timeperiods_nagios2.cfg extinfo_nagios2.cfg   generic-service_nagios2.cfg  localhost_nagios2.cfg
testserver.cfg

### Client Side

```
apt-get install -y nagios-plugins nagios-nrpe-server
```
Edit /etc/nagios/nrpe.cfg

```
log_facility=daemon
pid_file=/var/run/nagios/nrpe.pid
server_port=5666
nrpe_user=nagios
nrpe_group=nagios
allowed_hosts=198.211.117.129
dont_blame_nrpe=1
debug=0
command_timeout=60
connection_timeout=300
include=/etc/nagios/nrpe_local.cfg
include_dir=/etc/nagios/nrpe.d/

command[check_users]=/usr/lib/nagios/plugins/check_users -w 5 -c 10
command[check_load]=/usr/lib/nagios/plugins/check_load -w 15,10,5 -c 30,25,20
command[check_sda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda
command[check_zombie_procs]=/usr/lib/nagios/plugins/check_procs -w 5 -c 10 -s Z
command[check_total_procs]=/usr/lib/nagios/plugins/check_procs -w 150 -c 200
``` 

Add the host to the nagios3, cp testserver.cfg to /etc/nagios3/conf.d/

Some commands are from /usr/lib/nagios/plugins/ some are hard coded

Sample contact, host and service with a server configuration is added. 

nagios.cfg -> debug_level
commands.cfg -> from address, new custom command for nrpe
cgi.cfg -> refresh_rate

/etc/nagios-plugins/config/check_nrpe.cfg
