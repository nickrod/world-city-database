# About

This is an easy, automated, and future-proof way to collect and curate worldwide city data. It's very similar to https://github.com/JoshSmith/worldwide-city-database but with the focus on complete automation. It's 2018 and finding curated city data shouldn't be this difficult.

I needed a way to collect worldwide city data so that users on my site can select and set their location. Nothing fancy, just city names, state or region, and country. The problem being solved here is that the [Maxmind](https://www.maxmind.com/en/free-world-cities-database) database previously used for this, is not being maintained anymore, so we need a better way to do this.

Thanks to https://github.com/joshsmith for inspiring me, this question which provided most of the details, https://dba.stackexchange.com/questions/145080/import-geonames-allcountries-txt-into-mysql-5-7-using-load-infile-error-1300, and the geonames database that provides all the data for free, http://download.geonames.org/export/dump/

# Usage

I am assuming MySQL is your database, first start by creating the 'cities' database and importing the city_tables.sql file:

```
# create the database

mysql> CREATE DATABASE cities;

# import the tables

$ mysql -u myuser -p'mypass' cities < city_tables.sql

# now test that everything works by running the cities.sh shell script

$ ./cities.sh
```
Now like Ronco, 'set it and forget it' by using a cron job. In this example it will run every six months:

`0 0 1 */6 * /usr/local/bin/cities.sh`

# Notes

In the cities.sh script I am choosing to download cities with a population of 15,000 or more. You can change this by choosing the appropriate file in http://download.geonames.org/export/dump/ and making the changes to the script. There are also options for 1000 or 5000, depending on the level of detail you need.
