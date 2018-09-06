#!/bin/sh

# download city data

/usr/bin/wget -qO- http://download.geonames.org/export/dump/cities15000.zip | /bin/zcat > /tmp/cities15000.txt
/usr/bin/wget -q -O /tmp/admin1.txt http://download.geonames.org/export/dump/admin1CodesASCII.txt
/usr/bin/wget -qO- http://download.geonames.org/export/dump/countryInfo.txt | grep -v ^# | awk 'BEGIN { FS = "\t" } { print $1 "\t" $5 }' > /tmp/countries.txt

# run sql commands

/usr/bin/mysql -u myuser -p'mypass' cities < /usr/local/sql/cities.sql

# clean exit

exit 0
