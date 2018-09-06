-- delete all data

DELETE FROM `cities_raw`;
DELETE FROM `cities`;
DELETE FROM `countries`;
DELETE FROM `admin1`;

-- load new data

LOAD DATA LOCAL INFILE '/tmp/cities15000.txt' INTO TABLE `cities_raw` CHARACTER SET utf8mb4 FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 0 LINES (geonameid, name, asciiname, alternatenames, @latitude, @longitude, feature_class, feature_code, @country_code, cc2, @admin1_code, admin2_code, admin3_code, admin4_code, @population, @elevation, @dem, timezone, @modification_date) SET latitude = IF(@latitude="", NULL, @latitude), longitude = IF(@longitude="", NULL, @longitude), population = IF(@population="", NULL, @population), elevation = IF(@elevation="", NULL, @elevation), dem = IF(@dem="", NULL, @dem), admin1_code = IF(@admin1_code="", NULL, CONCAT(@country_code, '.', @admin1_code)), country_code = @country_code;
LOAD DATA LOCAL INFILE '/tmp/admin1.txt' INTO TABLE `admin1` CHARACTER SET utf8mb4 FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 0 LINES;
LOAD DATA LOCAL INFILE '/tmp/countries.txt' INTO TABLE `countries` CHARACTER SET utf8mb4 FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 0 LINES;

-- insert cities table

INSERT INTO cities (geonameid, name, population, combined, region_name, country_code, admin1_code) (SELECT cities_raw.geonameid, cities_raw.asciiname, cities_raw.population, CONCAT(cities_raw.asciiname, ', ', IF(admin1_code IS NULL OR admin1.asciiname IS NULL, NULL, admin1.asciiname)) AS combined, admin1.asciiname, country_code, admin1_code FROM cities_raw LEFT JOIN admin1 ON cities_raw.admin1_code = admin1.code);

-- update cities table

UPDATE cities, (SELECT name, code FROM countries) country SET cities.country_name = country.name WHERE cities.country_code = country.code;

-- update cities table, check for null combined column

UPDATE cities SET combined = CONCAT(name, ', ', country_name) WHERE combined IS NULL;
