# About

This is an easy, automated, and future-proof way to collect and curate worldwide city data. It's very similar to https://github.com/JoshSmith/worldwide-city-database but with the focus on complete automation.

I needed a way to collect worldwide city data so that users on my site can select and set their location. Nothing fancy, just city names, state or region, and country.

Thanks to https://github.com/joshsmith for getting me started, this question which provided most of the details, https://dba.stackexchange.com/questions/145080/import-geonames-allcountries-txt-into-mysql-5-7-using-load-infile-error-1300, and the geonames database that provides all the data for free, http://download.geonames.org/export/dump/

# Usage

I am assuming MySQL is your database, first start by creating the 'cities' database and importing the city_tables.sql file:

```
# create the database

mysql> CREATE DATABASE cities;

# import the tables

$ mysql -u myuser -p'mypass' cities < city_tables.sql
```
