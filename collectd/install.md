
```
sudo apt-get update
sudo apt-get install collectd collectd-utils -y
```

This one will be for graphite-web and apache status page
```
sudo apt-get install apache2 -y
```

edit collectd.conf

install graphite-web, carbon

```
sudo apt-get install graphite-web graphite-carbon -y
```

Choose "No" here so that you will not destroy your stats. If you need to start fresh, you can always manually remove the files (kept in var/lib/graphite/whisper)

install and configure database for web application, carbon and whisper is for stats but web app require a database to keep its database

```
sudo apt-get install postgresql libpq-dev python-psycopg2 -y
```

use psql command line to create a user and database
```
sudo -u postgres psql
```
```
CREATE USER graphite WITH PASSWORD 'ab2015';
CREATE DATABASE graphite WITH OWNER graphite;
```

Edit /etc/graphite/local_settings.py

Change the below ones

SECRET_KEY = 'a_salty_string'

TIME_ZONE = 'America/New_York' -> choose one from http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
USE_REMOTE_USER_AUTHENTICATION = True -> We also want to configure authentication for saving graph data. When we sync the database, we'll be able to create a user account, but we need to enable authentication by uncommenting this line

Edit the DATABASES part

Create the database and the admin user for the web interface

```
sudo graphite-manage syncdb
```

Make the carbon cache bootable, so edit /etc/default/graphite-carbon -> CARBON_CACHE_ENABLED=true

Edit /etc/carbon/carbon.conf -> ENABLE_LOGROTATION = True


Edit /etc/carbon/storage-schemas.conf -> 60 represents the number of seconds per datapoint

retentions = 60:1440 -> 60 represents the number of seconds per datapoint, and 1440 represents the number of datapoints to store

edit storage-schemas.conf

This will match any metrics beginning with "test.". It will store the data it collects three times, in varying detail. The first archive definition (10s:10m) will create a data point every ten seconds. It will store the values for only ten minutes.

The second archive (1m:1h) will create a data point every minute. It will gather all of the data from the past minute (six points, since the previous archive creates a point every ten seconds) and aggregate it to create the point. By default, it does this by averaging the points, but we can adjust this later. It stores the data at this level of detail for one hour.

The last archive that will be created (10m:1d) will make a data point every 10 minutes, aggregating the data in the same way as the second archive. It will store the data for one day.

```
sudo cp /usr/share/doc/graphite-carbon/examples/storage-aggregation.conf.example /etc/carbon/storage-aggregation.conf
```

Open /etc/carbon/storage-aggregation.conf:

The XFilesFactor is an interesting parameter in that it allows you to specify the minimum percentage of values that Carbon should have to do the aggregation. By default, all values are set to 0.5, meaning that 50% of the more detailed data points must be available if an aggregated point is to be created.

This can be used to ensure that you're not creating data points that might misrepresent the actual situation. For instance, if 70% of your data is being dropped because of network problems, you might not want to create a point that only truthfully represents 30% of the data.

```
sudo service carbon-cache stop          ## wait a few seconds here
sudo service carbon-cache start
```

tail and ps control

Set the apache page for graphite and status page

```
apt-get install libapache2-mod-wsgi apache2 -y
```


```
sudo cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
a2ensite apache2-graphite
service apache2 reload
```

```
service collectd restart 
```

visit http://graphite.local.net

check cpu-o.user and mpstats
check mem usage

logs

collectd -> syslog
grahite -> web
carbon -> /var/log/carbon

for grafana

```
# cd /var/www/html
# wget http://grafanarel.s3.amazonaws.com/grafana-1.9.1.tar.gz
# tar xvzf  grafana-1.9.1.tar.gz
# mv grafana-1.9.1 grafana
# cd config.js.example config.js
```

Edit config.js
Create grafana.conf vshost

Install elasticsearch, edit the xml file of es, edit etc hosts file to reach the web sites
