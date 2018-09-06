-- MySQL dump 10.13  Distrib 5.7.16, for Linux (x86_64)
--
-- Host: localhost    Database: cities
-- ------------------------------------------------------
-- Server version	5.7.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin1`
--

DROP TABLE IF EXISTS `admin1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin1` (
  `code` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `asciiname` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `geonameid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`geonameid`),
  KEY `idx_geonameid` (`geonameid`),
  KEY `idx_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cities` (
  `geonameid` int(10) unsigned NOT NULL,
  `name` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `population` decimal(11,0) DEFAULT NULL,
  `combined` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `region_name` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_name` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_code` char(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin1_code` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`geonameid`),
  KEY `idx_geonameid` (`geonameid`),
  KEY `idx_name` (`name`),
  KEY `idx_admin1_code` (`admin1_code`),
  KEY `idx_population` (`population`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cities_raw`
--

DROP TABLE IF EXISTS `cities_raw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cities_raw` (
  `geonameid` mediumint(8) unsigned NOT NULL COMMENT 'integer id of record in geonames database',
  `name` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'name of geographical point (utf8) varchar(200)',
  `asciiname` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'name of geographical point in plain ascii characters, varchar(200)',
  `alternatenames` text CHARACTER SET utf8mb4 COMMENT 'alternatenames, comma separated, ascii names automatically transliterated, convenience attribute from alternatename table, varchar(10000)',
  `latitude` decimal(7,5) DEFAULT NULL COMMENT 'latitude in decimal degrees (wgs84)',
  `longitude` decimal(8,5) DEFAULT NULL COMMENT 'longitude in decimal degrees (wgs84)',
  `feature_class` char(1) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'see http://www.geonames.org/export/codes.html, char(1)',
  `feature_code` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'see http://www.geonames.org/export/codes.html, varchar(10)',
  `country_code` char(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ISO-3166 2-letter country code, 2 characters',
  `cc2` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'alternate country codes, comma separated, ISO-3166 2-letter country code, 200 characters',
  `admin1_code` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code; varchar(20)',
  `admin2_code` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'code for the second administrative division, a county in the US, see file admin2Codes.txt; varchar(80) ',
  `admin3_code` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'code for third level administrative division, varchar(20)',
  `admin4_code` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'code for fourth level administrative division, varchar(20)',
  `population` decimal(11,0) DEFAULT NULL COMMENT 'bigint (8 byte int) ',
  `elevation` smallint(6) DEFAULT NULL COMMENT 'in meters, integer',
  `dem` smallint(6) DEFAULT NULL COMMENT 'digital elevation model, srtm3 or gtopo30, average elevation of 3''''x3'''' (ca 90mx90m) or 30''''x30'''' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.',
  `timezone` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'the timezone id (see file timeZone.txt) varchar(40)',
  `modification_date` date DEFAULT NULL COMMENT 'date of last modification in yyyy-MM-dd format',
  PRIMARY KEY (`geonameid`),
  KEY `idx_name` (`name`),
  KEY `idx_asciiname` (`asciiname`),
  KEY `idx_admin1_code` (`admin1_code`),
  KEY `idx_admin2_code` (`admin2_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `code` char(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-06 14:34:39
