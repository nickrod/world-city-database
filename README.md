# About

This is an easy, automated, and future-proof way to collect and curate worldwide city data locally.

# Usage

Either PostgreSQL or MySQL can be used, but it must be specified on the command line, in the example below PostgreSQL is used:

```
# Modify population and db vars fields in city.sh

# population - 500, 1000, 5000, or 15000

POPULATION="15000"

# db vars

USER=""
DB=""
HOST="localhost"

# Run the city.sh shell script

$ ./city.sh psql

# Optionally create a cron job, in this example it will run every six months

0 0 1 */6 * city.sh psql
```

# Notes

The 'title_combined' field is unique, and will either be the title by itself or 'title, title_region' if there are duplicates. This means that 'title_combined' can be used as a unique identifier instead of relying on 'geoname_id'.

This is designed to be used with a foreign key on 'geoname_id' without causing any foreign key constraint violations, allowing the data to be seamlessly updated without compromising db integrity.
