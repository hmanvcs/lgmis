-- Adminer 3.3.3 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = 'SYSTEM';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `commoditypricedetails`;
CREATE TABLE `commoditypricedetails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `pricecategoryid` int(11) unsigned NOT NULL,
  `retailprice` int(11) unsigned DEFAULT NULL,
  `wholesaleprice` int(11) unsigned DEFAULT NULL,
  `submissionid` int(11) unsigned NOT NULL,
  `notes` varchar(1000) NOT NULL DEFAULT '',
  `datecollected` date DEFAULT NULL,
  `sourceid` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_commoditypricedetails_datecollected` (`datecollected`),
  KEY `fk_commoditypricedetails_commodity` (`commodityid`),
  KEY `fk_commoditypricedetails_pricecategory` (`pricecategoryid`),
  KEY `fk_commoditypricedetails_submissionid` (`submissionid`)
) ENGINE=InnoDB AUTO_INCREMENT=1509564 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `commoditypricesubmission`;
CREATE TABLE `commoditypricesubmission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datecollected` date NOT NULL,
  `collectedbyid` int(11) unsigned NOT NULL,
  `sourceid` int(11) unsigned NOT NULL,
  `comments` blob NOT NULL,
  `status` enum('Saved','Approved','Rejected') NOT NULL DEFAULT 'Saved',
  `dateapproved` date DEFAULT NULL,
  `approvedbyid` int(11) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_submission` (`datecollected`,`collectedbyid`,`sourceid`),
  KEY `fk_pricesubmission_createdby` (`createdby`),
  KEY `fk_pricesubmission_lastupdatedby` (`lastupdatedby`),
  KEY `fk_pricesubmission_approvedbyid` (`approvedbyid`),
  KEY `fk_pricesubmission_sourceid` (`sourceid`),
  KEY `fk_pricesubmission_datecollected` (`datecollected`),
  KEY `fk_pricesubmission_collectedbyid` (`collectedbyid`),
  KEY `index_pricesubmission_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=29037 DEFAULT CHARSET=latin1


-- 2013-05-03 18:38:14
