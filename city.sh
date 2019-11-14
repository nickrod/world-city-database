#!/bin/sh

# set vars

# population - 500, 1000, 5000, or 15000 

POPULATION="15000"

# db vars

USER=""
DB=""
HOST="localhost"

# validation

if [ $# -ne 1 -a "$1" != "mysql" -a "$1" != "psql" ] ; then
  echo "Usage: $0 [mysql|psql]" >&2
  exit 1
fi

######### Don't modify below this line #########

# tmp files

CITYFILE="/tmp/city.sql"
REGIONFILE="/tmp/region.sql"
CITYSQLFILE="/tmp/citysql.sql"

# begin transaction and set constraints

if [ "$1" = "psql" ] ; then
  echo "BEGIN;" > $CITYFILE
  echo "SET CONSTRAINTS ALL DEFERRED;" >> $CITYFILE
else
  echo "SET FOREIGN_KEY_CHECKS=0;" > $CITYFILE
fi

#

echo "TRUNCATE TABLE city;" >> $CITYFILE

# download files

wget -qO- http://download.geonames.org/export/dump/cities$POPULATION.zip | zcat | awk 'BEGIN { FS="\t" } { gsub("\x27", "\x27\x27", $2); print "INSERT INTO city (geoname_id, title, latitude, longitude, country_code, region_code) VALUES (" $1 ", \x27" $2 "\x27, " $5 ", " $6 ", \x27" $9 "\x27, \x27" $11 "\x27);" }' >> $CITYFILE
wget -qO- http://download.geonames.org/export/dump/admin1CodesASCII.txt | cat | awk 'BEGIN { FS="\t" } { gsub("\x27", "\x27\x27", $2); print "INSERT INTO region (geoname_id, title, code) VALUES (" $4 ", \x27" $2 "\x27, \x27" $1 "\x27);" }' > $REGIONFILE

# end transaction

if [ "$1" = "psql" ] ; then
  echo "COMMIT;" >> $CITYFILE
else
  echo "SET FOREIGN_KEY_CHECKS=1;" >> $CITYFILE
fi

# prepare sql

cat << EOF > $CITYSQLFILE
CREATE TABLE IF NOT EXISTS region (
  geoname_id INT NOT NULL,
  title TEXT NOT NULL,
  code VARCHAR(200) NOT NULL,
  UNIQUE(code),
  PRIMARY KEY(geoname_id)
);

--

CREATE INDEX IF NOT EXISTS idx_region_code ON region(code);

--

CREATE TABLE IF NOT EXISTS city (
  geoname_id INT NOT NULL,
  title TEXT NOT NULL,
  title_region TEXT,
  title_combined VARCHAR(200),
  latitude DECIMAL(7,5),
  longitude DECIMAL(8,5),
  country_code CHAR(2),
  region_code TEXT,
  UNIQUE(title_combined),
  PRIMARY KEY(geoname_id)
);

--

CREATE INDEX IF NOT EXISTS idx_city_title ON city(title);
CREATE INDEX IF NOT EXISTS idx_city_title_region ON city(title_region);
CREATE INDEX IF NOT EXISTS idx_city_title_combined ON city(title_combined);
CREATE INDEX IF NOT EXISTS idx_city_latitude ON city(latitude);
CREATE INDEX IF NOT EXISTS idx_city_longitude ON city(longitude);
CREATE INDEX IF NOT EXISTS idx_city_country_code ON city(country_code);
CREATE INDEX IF NOT EXISTS idx_city_region_code ON city(region_code);

--

TRUNCATE TABLE region;
EOF

# check if files exist

if [ ! -f "$CITYFILE" -o ! -f "$REGIONFILE" -o ! -f "$CITYSQLFILE" ] ; then
  echo "$0: Error: Data files don't exist." >&2
  exit 1
fi

# update region after file copy, and remove unneeded index

CITYSQL1="UPDATE city SET title_region = region.title FROM region WHERE CONCAT(country_code, '.', region_code) = code AND region.title != '';"
CITYSQL2="DELETE FROM city c1 USING city c2 WHERE c1.geoname_id < c2.geoname_id AND c1.title = c2.title AND c1.title_region = c2.title_region AND c1.country_code = c2.country_code;"
CITYSQL3="UPDATE city SET title_combined = CONCAT(city.title, ' ', city.title_region, ' ', city.country_code) FROM city c2 WHERE city.geoname_id != c2.geoname_id AND city.title = c2.title AND city.title_region = c2.title_region AND city.title_combined IS NULL;"
CITYSQL4="UPDATE city SET title_combined = CONCAT(city.title, ' ', city.country_code) FROM city c2 WHERE city.geoname_id != c2.geoname_id AND city.title = c2.title AND city.country_code != c2.country_code AND city.title_region IS NULL AND city.title_combined IS NULL;"
CITYSQL5="UPDATE city SET title_combined = CONCAT(city.title, ' ', city.title_region) FROM city c2 WHERE city.geoname_id != c2.geoname_id AND city.title = c2.title AND city.title_region != c2.title_region AND city.title_combined IS NULL;"

# run the sql commands

if [ "$1" = "psql" ] ; then
  psql -U "$USER" -d "$DB" -h "$HOST" -f "$CITYSQLFILE" -f "$CITYFILE" -f "$REGIONFILE" -c "$CITYSQL1" -c "$CITYSQL2" -c "$CITYSQL3" -c "$CITYSQL4" -c "$CITYSQL5" -q
else
  mysql -u "$USER" -D "$DB" -h "$HOST" -e "source $CITYSQLFILE;" -e "source $CITYFILE;" -e "source $REGIONFILE;" -e "$CITYSQL1" -e "$CITYSQL2" -e "$CITYSQL3" -e "$CITYSQL4" -e "$CITYSQL5"
fi

# remove tmp files if they exist

rm -f $CITYFILE $REGIONFILE $CITYSQLFILE

# clean exit

exit 0
