# About

This is an easy, automated, and future-proof way to collect and curate worldwide city data. It's very similar to [this project](https://github.com/JoshSmith/worldwide-city-database) but with the focus on complete automation. It's 2018 and finding curated city data that can be stored locally shouldn't be this difficult.

# Usage

I am assuming PostgreSQL is your database:

```
# Modify population and db vars fields in city.sh

POPULATION="15000"
USER=""
DB=""
HOST=""

# Run the city.sh shell script

$ ./city.sh
```
Now like [Ronco](https://www.youtube.com/watch?v=GG43jyZ65R8), 'set it and forget it' by using a cron job. In this example it will run every six months:

`0 0 1 */6 * city.sh`

# Notes

The 'title_combined' field is unique, and wll either be the title by itself or 'title, title_region' if there are duplicates. This means that 'title_combined' can be used as a unique identifier instead of relying on 'geoname_id'.

This is designed to be used with a foreign key on 'geoname_id' using the 'location' table, without causing any foreign key constraint violations. This means it can be seamlessly updated without compromising db integrity.

The 'location' table is required, but can modified to your liking as long as the 'geoname_id' is references as a foreign key. 
