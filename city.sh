#!/bin/sh

# set vars

# population - 500, 1000, 5000, or 15000 

POPULATION="15000"
CITYFILE="/tmp/city.sql"
REGIONFILE="/tmp/region.sql"
CITYSQLFILE="/tmp/citysql.sql"

# db vars

USER="test"
DB="test"
HOST="localhost"

# download files

wget -qO- http://download.geonames.org/export/dump/cities$POPULATION.zip | zcat | awk 'BEGIN { FS="\t" } { gsub("\x27", "\x27\x27", $2); print "INSERT INTO city (geoname_id, title, country_code, region_code) VALUES (" $1 ", \x27" $2 "\x27, \x27" $9 "\x27, \x27" $11 "\x27);" }' > $CITYFILE
wget -qO- http://download.geonames.org/export/dump/admin1CodesASCII.txt | cat | awk 'BEGIN { FS="\t" } { gsub("\x27", "\x27\x27", $2); print "INSERT INTO region (geoname_id, title, code) VALUES (" $4 ", \x27" $2 "\x27, \x27" $1 "\x27);" }' > $REGIONFILE

# prepare sql

cat << EOF > $CITYSQLFILE
DROP TABLE IF EXISTS city;

--

CREATE TABLE city (
  geoname_id INT NOT NULL,
  title TEXT NOT NULL,
  title_region TEXT,
  country_code CHAR(2),
  region_code TEXT,
  PRIMARY KEY(geoname_id)
);

--

CREATE INDEX idx_city_title ON city(title);
CREATE INDEX idx_city_country_code ON city(country_code);
CREATE INDEX idx_city_region_code ON city(region_code);

--

DROP TABLE IF EXISTS region;

--

CREATE TABLE region (
  geoname_id INT NOT NULL,
  title TEXT NOT NULL,
  code TEXT NOT NULL,
  UNIQUE(code),
  PRIMARY KEY(geoname_id)
);

--

CREATE INDEX idx_region_code ON region(code);
EOF

# check if files exist

if [ ! -f "$CITYFILE" -o ! -f "$REGIONFILE" -o ! -f "$CITYSQLFILE" ] ; then
  echo "$0: Error: Data files don't exist." >&2
  exit 1
fi

# update region after file copy, and remove unneeded index

CITYSQL1="UPDATE city SET title_region = region.title FROM region WHERE CONCAT(country_code, '.', region_code) = code AND region.title != '';"
CITYSQL2="DROP INDEX idx_city_region_code;"
CITYSQL3="DROP TABLE region;"

# run the sql commands

psql -U $USER -d $DB -h $HOST -f "$CITYSQLFILE" -f "$CITYFILE" -f "$REGIONFILE" -c "$CITYSQL1" -c "$CITYSQL2" -c "$CITYSQL3" -q -W

# remove tmp files if they exist

rm -f $CITYFILE $REGIONFILE $CITYSQLFILE

# clean exit

exit 0
