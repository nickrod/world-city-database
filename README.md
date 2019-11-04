# About

This is an easy, automated, and future-proof way to collect and curate worldwide city data. It's very similar to [this project](https://github.com/JoshSmith/worldwide-city-database) but with the focus on complete automation. It's 2018 and finding curated city data shouldn't be this difficult.

I needed a way to collect worldwide city data so that users on my site can select and set their location. Nothing fancy, just city names, state or region, and country. The problem being solved here is that the [Maxmind](https://www.maxmind.com/en/free-world-cities-database) database previously used for this, is not being maintained anymore, so we need a better way to do this.

Thanks to [John Smith](https://github.com/joshsmith) for inspiring me, [this](https://dba.stackexchange.com/questions/145080/import-geonames-allcountries-txt-into-mysql-5-7-using-load-infile-error-1300) question which provided most of the technical details, and the geonames [database](http://download.geonames.org/export/dump/) that provides all the data for free.

# Usage

I am assuming PostgreSQL is your database:

```
# Modify population and db vars fields in city.sh

POPULATION=""
USER=""
DB=""
HOST=""

# Run the city.sh shell script

$ ./city.sh
```
Now like [Ronco](https://www.youtube.com/watch?v=GG43jyZ65R8), 'set it and forget it' by using a cron job. In this example it will run every six months:

`0 0 1 */6 * /usr/local/bin/city.sh`

# Notes

The 'title_combined' field is unique, and wll either be the title by itself or 'title, title_region' if there are duplicates. This means that 'title_combined' can be used as a unique identifier instead of using 'geoname_id'.
