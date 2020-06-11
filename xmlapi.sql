-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 23, 2020 at 08:52 PM
-- Server version: 5.7.26
-- PHP Version: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `xmlapi`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `outage_insert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `outage_insert` (IN `prm_rus_utility_id` VARCHAR(255), IN `prm_coopid` VARCHAR(255), IN `prm_total_served` VARCHAR(255), IN `prm_total_out` VARCHAR(255), IN `prm_region_type` VARCHAR(255), OUT `OID` INT)  BEGIN
	insert into outage (rus_utility_id,coopid,total_served,total_out,region_type,createdate) values (prm_rus_utility_id, prm_coopid, prm_total_served, prm_total_out, prm_region_type, UNIX_TIMESTAMP());
	set OID = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `outage_region_insert`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `outage_region_insert` (IN `prm_outage_id` INT, IN `prm_region_id` VARCHAR(255), IN `prm_county_FIPSId` VARCHAR(255), IN `prm_state_FIPSId` VARCHAR(255), IN `prm_county_name` VARCHAR(255), IN `prm_county_served` VARCHAR(255), IN `prm_county_out` VARCHAR(255))  BEGIN
	INSERT INTO `xmlapi`.`outage_region`
(`outage_id`,
`region_id`,
`county_FIPSId`,
`state_FIPSId`,
`county_name`,
`county_served`,
`county_out`)
VALUES
(prm_outage_id,
prm_region_id,
prm_county_FIPSId,
prm_state_FIPSId,
prm_county_name,
prm_county_served,
prm_county_out);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `outage`
--

DROP TABLE IF EXISTS `outage`;
CREATE TABLE IF NOT EXISTS `outage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rus_utility_id` varchar(255) NOT NULL,
  `coopid` varchar(255) NOT NULL,
  `total_served` varchar(255) NOT NULL,
  `total_out` varchar(255) NOT NULL,
  `region_type` varchar(255) NOT NULL,
  `createdate` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `outage_region`
--

DROP TABLE IF EXISTS `outage_region`;
CREATE TABLE IF NOT EXISTS `outage_region` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outage_id` int(11) DEFAULT NULL,
  `region_id` varchar(255) DEFAULT NULL,
  `county_FIPSId` varchar(255) DEFAULT NULL,
  `state_FIPSId` varchar(255) DEFAULT NULL,
  `county_name` varchar(255) DEFAULT NULL,
  `county_served` varchar(255) DEFAULT NULL,
  `county_out` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
