-- Adminer 3.3.3 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = 'SYSTEM';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `aclgroup`;
CREATE TABLE `aclgroup` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name` (`name`),
  KEY `fk_group_createdby` (`createdby`),
  KEY `fk_group_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_group_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_group_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `aclpermission`;
CREATE TABLE `aclpermission` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupid` int(11) unsigned DEFAULT NULL,
  `resourceid` int(11) unsigned NOT NULL,
  `create` enum('1','0') NOT NULL DEFAULT '0',
  `edit` enum('1','0') NOT NULL DEFAULT '0',
  `view` enum('1','0') NOT NULL DEFAULT '0',
  `list` enum('1','0') NOT NULL DEFAULT '0',
  `delete` enum('1','0') NOT NULL DEFAULT '0',
  `export` enum('1','0') NOT NULL DEFAULT '0',
  `approve` enum('1','0') NOT NULL DEFAULT '0',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_aclpermission_groupid` (`groupid`),
  KEY `fk_aclpermission_resourceid` (`resourceid`),
  KEY `fk_permission_createdby` (`createdby`),
  KEY `fk_permission_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_aclpermission_groupid` FOREIGN KEY (`groupid`) REFERENCES `aclgroup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_aclpermission_resourceid` FOREIGN KEY (`resourceid`) REFERENCES `aclresource` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permission_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permission_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `aclresource`;
CREATE TABLE `aclresource` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `create` enum('1','0') NOT NULL DEFAULT '0',
  `edit` enum('1','0') NOT NULL DEFAULT '0',
  `view` enum('1','0') NOT NULL DEFAULT '0',
  `list` enum('1','0') NOT NULL DEFAULT '0',
  `delete` enum('1','0') NOT NULL DEFAULT '0',
  `approve` enum('1','0') NOT NULL DEFAULT '0',
  `export` enum('1','0') NOT NULL DEFAULT '0',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_resource_createdby` (`createdby`),
  KEY `fk_resource_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_resource_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_resource_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `aclusergroup`;
CREATE TABLE `aclusergroup` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groupid` int(11) unsigned NOT NULL,
  `userid` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_group_user` (`groupid`,`userid`),
  KEY `fk_aclusergroup_userid` (`userid`),
  CONSTRAINT `fk_aclusergroup_groupid` FOREIGN KEY (`groupid`) REFERENCES `aclgroup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_aclusergroup_userid` FOREIGN KEY (`userid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `appconfig`;
CREATE TABLE `appconfig` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `section` varchar(50) NOT NULL DEFAULT '',
  `optionname` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `optionvalue` varchar(255) DEFAULT '',
  `optiontype` varchar(15) DEFAULT '',
  `active` enum('Y','N') NOT NULL DEFAULT 'Y',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_appconfig_createdby` (`createdby`) USING BTREE,
  KEY `fk_appconfig_lastupdatedby` (`lastupdatedby`) USING BTREE,
  CONSTRAINT `fk_appconfig_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_appconfig_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `audittrail`;
CREATE TABLE `audittrail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(11) unsigned DEFAULT NULL,
  `transactiontype` varchar(50) NOT NULL,
  `transactiondetails` mediumtext,
  `transactiondate` datetime NOT NULL,
  `executedby` int(11) unsigned DEFAULT NULL,
  `success` enum('N','Y') NOT NULL DEFAULT 'N',
  `browserdetails` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_audittrail_userid` (`userid`),
  KEY `fk_audittrail_transactiontype` (`transactiontype`),
  KEY `fk_audittrail_executedby` (`executedby`),
  CONSTRAINT `fk_audittrail_executedby` FOREIGN KEY (`executedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_audittrail_userid` FOREIGN KEY (`userid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `boat`;
CREATE TABLE `boat` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `regno` varchar(15) CHARACTER SET latin1 NOT NULL,
  `description` varchar(500) CHARACTER SET latin1 DEFAULT NULL,
  `owner` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `type` char(1) CHARACTER SET latin1 NOT NULL,
  `landingsiteid` int(11) unsigned NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_boat_createdby` (`createdby`),
  KEY `fk_boat_lastupdatedby` (`lastupdatedby`),
  KEY `fk_boat_landingsiteid` (`landingsiteid`),
  CONSTRAINT `fk_boat_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_boat_landingsiteid` FOREIGN KEY (`landingsiteid`) REFERENCES `landingsite` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_boat_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `businessdirectorycategory`;
CREATE TABLE `businessdirectorycategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` varchar(500) DEFAULT '',
  `parentid` int(11) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned DEFAULT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_business_directory_category_name` (`name`),
  KEY `fk_business_directory_category_createdby` (`createdby`),
  KEY `fk_business_directory_category_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_business_directory_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_business_directory_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `commodity`;
CREATE TABLE `commodity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `unitid` int(10) unsigned DEFAULT NULL,
  `description` varchar(500) DEFAULT '',
  `parentid` int(11) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `categoryid` int(10) unsigned NOT NULL,
  `minprice` int(11) DEFAULT NULL,
  `maxprice` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_commodity_name_parent` (`name`,`parentid`),
  KEY `fk_commodity_createdby` (`createdby`),
  KEY `fk_commodity_lastupdatedby` (`lastupdatedby`),
  KEY `fk_commodity_category` (`categoryid`),
  KEY `fk_commodity_unit` (`unitid`),
  CONSTRAINT `fk_commodity_category` FOREIGN KEY (`categoryid`) REFERENCES `commoditycategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commodity_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commodity_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_commodity_unit` FOREIGN KEY (`unitid`) REFERENCES `commodityunit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `commoditycategory`;
CREATE TABLE `commoditycategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` varchar(500) DEFAULT '',
  `parentid` int(11) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_commodity_category_name` (`name`),
  KEY `fk_commodity_category_createdby` (`createdby`),
  KEY `fk_commodity_category_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_commodity_category_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commodity_category_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `commoditypricecategory`;
CREATE TABLE `commoditypricecategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned DEFAULT NULL,
  `pricecategoryid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_commodity_price_category` (`pricecategoryid`,`commodityid`),
  KEY `fk_commoditypricecategory_commodity` (`commodityid`),
  KEY `fk_commoditypricecategory_pricecategory` (`pricecategoryid`),
  CONSTRAINT `fk_commoditypricecategory_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commoditypricecategory_pricecategory` FOREIGN KEY (`pricecategoryid`) REFERENCES `pricecategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
  KEY `fk_commoditypricedetails_submissionid` (`submissionid`),
  CONSTRAINT `fk_commoditypricedetails_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commoditypricedetails_pricecategory` FOREIGN KEY (`pricecategoryid`) REFERENCES `pricecategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commoditypricedetails_submissionid` FOREIGN KEY (`submissionid`) REFERENCES `commoditypricesubmission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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
  KEY `index_pricesubmission_status` (`status`),
  CONSTRAINT `fk_pricesubmission_approvedbyid` FOREIGN KEY (`approvedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pricesubmission_collectedbyid` FOREIGN KEY (`collectedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pricesubmission_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pricesubmission_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pricesubmission_sourceid` FOREIGN KEY (`sourceid`) REFERENCES `pricesource` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `commodityunit`;
CREATE TABLE `commodityunit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `name` varchar(10) NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_unit_name` (`name`),
  KEY `fk_commodity_unit_createdby` (`createdby`),
  KEY `fk_commodity_unit_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_commodity_unit_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commodity_unit_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `salutation` varchar(10) CHARACTER SET latin1 DEFAULT '',
  `gender` enum('M','F') CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstname` varchar(100) CHARACTER SET utf8 DEFAULT '',
  `lastname` varchar(100) CHARACTER SET utf8 DEFAULT '',
  `othernames` varchar(100) CHARACTER SET utf8 DEFAULT '',
  `orgname` varchar(100) CHARACTER SET utf8 DEFAULT '',
  `contactperson` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `contacttype` tinyint(11) NOT NULL,
  `phone` varchar(50) CHARACTER SET utf8 NOT NULL,
  `phone2` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(255) CHARACTER SET latin1 DEFAULT '',
  `address` varchar(500) CHARACTER SET utf8 NOT NULL,
  `notes` varchar(1000) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `locationid` int(11) unsigned DEFAULT NULL,
  `subcountyid` int(11) unsigned DEFAULT NULL,
  `idorpassportno` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  `driverlicenceno` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  `licenceno` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  `dateofregistration` date DEFAULT NULL,
  `numberofmale` int(11) unsigned NOT NULL,
  `numberoffemale` int(11) unsigned NOT NULL,
  `businessdescription` mediumtext COLLATE latin1_general_ci,
  `goodsorservicesoffered` mediumtext COLLATE latin1_general_ci,
  `numberofoutlets` int(11) unsigned NOT NULL,
  `wishtoadvertise` tinyint(4) unsigned NOT NULL,
  `goodsorservicetoadvertise` mediumtext COLLATE latin1_general_ci,
  `vatnumber` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  `tinnumber` varchar(255) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_contact_unique` (`firstname`,`lastname`,`orgname`),
  KEY `fk_contact_createdby` (`createdby`),
  KEY `fk_contact_lastupdatedby` (`lastupdatedby`),
  KEY `fk_contact_location` (`locationid`),
  KEY `fk_contact_subcounty` (`subcountyid`),
  CONSTRAINT `fk_contact_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_subcounty` FOREIGN KEY (`subcountyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;


DROP TABLE IF EXISTS `contactcategory`;
CREATE TABLE `contactcategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contactid` int(11) unsigned DEFAULT NULL,
  `categoryid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_contact_category` (`contactid`,`categoryid`),
  KEY `fk_contactcategory_contact` (`contactid`),
  KEY `fk_contactcategory_category` (`categoryid`),
  CONSTRAINT `fk_contactcategory_category` FOREIGN KEY (`categoryid`) REFERENCES `businessdirectorycategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_contactcategory_contact` FOREIGN KEY (`contactid`) REFERENCES `contact` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `cropproduction`;
CREATE TABLE `cropproduction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `seedcost` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `yieldperacre` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `datecollected` date NOT NULL,
  `collectedbyid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cropproduction_createdby` (`createdby`),
  KEY `fk_cropproduction_lastupdatedby` (`lastupdatedby`),
  KEY `fk_cropproduction_commodity` (`commodityid`),
  KEY `fk_cropproduction_location` (`locationid`),
  KEY `fk_cropproduction_collector` (`collectedbyid`),
  CONSTRAINT `fk_cropproduction_collector` FOREIGN KEY (`collectedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropproduction_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropproduction_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropproduction_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropproduction_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `cropsectorinformation`;
CREATE TABLE `cropsectorinformation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `seedsource` mediumtext NOT NULL,
  `pests` mediumtext NOT NULL,
  `diseases` mediumtext NOT NULL,
  `creditsource` mediumtext NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_cropsectorinformation_createdby` (`createdby`),
  KEY `fk_cropsectorinformation_lastupdatedby` (`lastupdatedby`),
  KEY `fk_cropsectorinformation_commodity` (`commodityid`),
  KEY `fk_cropsectorinformation_location` (`locationid`),
  CONSTRAINT `fk_cropsectorinformation_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropsectorinformation_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropsectorinformation_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cropsectorinformation_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `fishcatchdetail`;
CREATE TABLE `fishcatchdetail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `catchsummaryid` int(11) unsigned NOT NULL,
  `boatid` int(11) unsigned NOT NULL,
  `nettype` char(2) CHARACTER SET latin1 NOT NULL,
  `hooksize` decimal(10,1) NOT NULL,
  `hookno` tinyint(3) unsigned NOT NULL,
  `mputaid` int(11) unsigned DEFAULT NULL,
  `mputacount` tinyint(3) unsigned DEFAULT NULL,
  `mputaweight` decimal(10,1) DEFAULT NULL,
  `ngegeid` int(11) unsigned DEFAULT NULL,
  `ngegecount` tinyint(3) unsigned DEFAULT NULL,
  `ngegeweight` decimal(10,1) DEFAULT NULL,
  `mukeneid` int(11) unsigned DEFAULT NULL,
  `mukenecount` tinyint(3) unsigned DEFAULT NULL,
  `mukeneweight` decimal(10,1) DEFAULT NULL,
  `mambaid` int(11) unsigned DEFAULT NULL,
  `mambacount` tinyint(3) unsigned DEFAULT NULL,
  `mambaweight` decimal(10,1) DEFAULT NULL,
  `maleid` int(11) unsigned DEFAULT NULL,
  `malecount` tinyint(3) unsigned DEFAULT NULL,
  `maleweight` decimal(10,1) DEFAULT NULL,
  `othertilapiaid` int(11) unsigned DEFAULT NULL,
  `othertilapiacount` tinyint(3) unsigned DEFAULT NULL,
  `othertilapiaweight` decimal(10,1) DEFAULT NULL,
  `otherid` int(11) unsigned DEFAULT NULL,
  `othercount` tinyint(3) unsigned DEFAULT NULL,
  `otherweight` decimal(10,1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fishcatchdetail_catchsummaryid` (`catchsummaryid`),
  KEY `fk_fishcatchdetail_mputaid` (`mputaid`),
  KEY `fk_fishcatchdetail_ngegeid` (`ngegeid`),
  KEY `fk_fishcatchdetail_mukeneid` (`mukeneid`),
  KEY `fk_fishcatchdetail_mambaid` (`mambaid`),
  KEY `fk_fishcatchdetail_maleid` (`maleid`),
  KEY `fk_fishcatchdetail_othertilapiaid` (`othertilapiaid`),
  KEY `fk_fishcatchdetail_otherid` (`otherid`),
  KEY `fk_fishcatchdetail_boatid` (`boatid`),
  CONSTRAINT `fk_fishcatchdetail_boatid` FOREIGN KEY (`boatid`) REFERENCES `boat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_catchsummaryid` FOREIGN KEY (`catchsummaryid`) REFERENCES `fishcatchsummary` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_maleid` FOREIGN KEY (`maleid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_mambaid` FOREIGN KEY (`mambaid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_mputaid` FOREIGN KEY (`mputaid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_mukeneid` FOREIGN KEY (`mukeneid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_ngegeid` FOREIGN KEY (`ngegeid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_otherid` FOREIGN KEY (`otherid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchdetail_othertilapiaid` FOREIGN KEY (`othertilapiaid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `fishcatchsummary`;
CREATE TABLE `fishcatchsummary` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `landingsiteid` int(11) unsigned NOT NULL,
  `districtid` int(11) unsigned NOT NULL,
  `daterecorded` date NOT NULL,
  `recordedbyid` int(11) unsigned NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_landingsite_daterecorded` (`landingsiteid`,`daterecorded`),
  KEY `fk_fishcatchsummary_lastupdatedby` (`lastupdatedby`),
  KEY `fk_fishcatchsummary_createdby` (`createdby`),
  KEY `fk_fishcatchsummary_districtid` (`districtid`),
  KEY `fk_fishcatchsummary_recordedbyid` (`recordedbyid`),
  CONSTRAINT `fk_fishcatchsummary_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchsummary_districtid` FOREIGN KEY (`districtid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchsummary_landingsiteid` FOREIGN KEY (`landingsiteid`) REFERENCES `landingsite` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchsummary_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_fishcatchsummary_recordedbyid` FOREIGN KEY (`recordedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `handcraftinformation`;
CREATE TABLE `handcraftinformation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `materialsource` mediumtext NOT NULL,
  `materialtype` mediumtext NOT NULL,
  `market` mediumtext NOT NULL,
  `creditsource` mediumtext NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_handcraftinformation_createdby` (`createdby`),
  KEY `fk_handcraftinformation_lastupdatedby` (`lastupdatedby`),
  KEY `fk_handcraftinformation_commodity` (`commodityid`),
  KEY `fk_handcraftinformation_location` (`locationid`),
  CONSTRAINT `fk_handcraftinformation_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftinformation_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftinformation_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftinformation_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `handcraftproduction`;
CREATE TABLE `handcraftproduction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `retail` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `wholesale` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `datecollected` date NOT NULL,
  `collectedbyid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_handcraftproduction_createdby` (`createdby`),
  KEY `fk_handcraftproduction_lastupdatedby` (`lastupdatedby`),
  KEY `fk_handcraftproduction_commodity` (`commodityid`),
  KEY `fk_handcraftproduction_location` (`locationid`),
  KEY `fk_handcraftproduction_collector` (`collectedbyid`),
  CONSTRAINT `fk_handcraftproduction_collector` FOREIGN KEY (`collectedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftproduction_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftproduction_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftproduction_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_handcraftproduction_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `landingsite`;
CREATE TABLE `landingsite` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `description` varchar(500) CHARACTER SET latin1 DEFAULT NULL,
  `waterbodyid` int(11) unsigned NOT NULL,
  `districtid` int(11) unsigned NOT NULL,
  `subcountyid` int(11) unsigned NOT NULL,
  `parishid` int(11) unsigned NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_landingsite_lastupdatedby` (`lastupdatedby`),
  KEY `fk_landingsite_createdby` (`createdby`),
  KEY `fk_landingsite_waterbodyid` (`waterbodyid`),
  KEY `fk_landingsite_districtid` (`districtid`),
  KEY `fk_landingsite_subcountyid` (`subcountyid`),
  KEY `fk_landingsite_parishid` (`parishid`),
  CONSTRAINT `fk_landingsite_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_landingsite_districtid` FOREIGN KEY (`districtid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_landingsite_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_landingsite_parishid` FOREIGN KEY (`parishid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_landingsite_subcountyid` FOREIGN KEY (`subcountyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_landingsite_waterbodyid` FOREIGN KEY (`waterbodyid`) REFERENCES `waterbody` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `livestockinformation`;
CREATE TABLE `livestockinformation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `breedsource` mediumtext NOT NULL,
  `pests` mediumtext NOT NULL,
  `diseases` mediumtext NOT NULL,
  `creditsource` mediumtext NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_livestockinformation_createdby` (`createdby`),
  KEY `fk_livestockinformation_lastupdatedby` (`lastupdatedby`),
  KEY `fk_livestockinformation_commodity` (`commodityid`),
  KEY `fk_livestockinformation_location` (`locationid`),
  CONSTRAINT `fk_livestockinformation_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockinformation_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockinformation_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockinformation_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `livestockproduction`;
CREATE TABLE `livestockproduction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `commodityid` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `breedcost` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `yield` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `datecollected` date NOT NULL,
  `collectedbyid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_livestockproduction_createdby` (`createdby`),
  KEY `fk_livestockproduction_lastupdatedby` (`lastupdatedby`),
  KEY `fk_livestockproduction_commodity` (`commodityid`),
  KEY `fk_livestockproduction_location` (`locationid`),
  KEY `fk_livestockproduction_collector` (`collectedbyid`),
  CONSTRAINT `fk_livestockproduction_collector` FOREIGN KEY (`collectedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockproduction_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockproduction_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockproduction_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_livestockproduction_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `location`;
CREATE TABLE `location` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `locationtype` tinyint(6) NOT NULL,
  `regionid` int(11) unsigned DEFAULT NULL,
  `districtid` int(11) unsigned DEFAULT NULL,
  `countyid` int(11) unsigned DEFAULT NULL,
  `subcountyid` int(11) unsigned DEFAULT NULL,
  `parishid` int(11) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_locationname_type` (`name`,`locationtype`,`regionid`,`districtid`,`countyid`,`subcountyid`,`parishid`),
  KEY `fk_location_createdby` (`createdby`),
  KEY `fk_location_lastupdatedby` (`lastupdatedby`),
  KEY `fk_location_region` (`regionid`),
  KEY `fk_location_district` (`districtid`),
  KEY `fk_location_county` (`countyid`),
  KEY `fk_location_subcounty` (`subcountyid`),
  KEY `fk_location_parish` (`parishid`),
  CONSTRAINT `fk_location_county` FOREIGN KEY (`countyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location_district` FOREIGN KEY (`districtid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location_parish` FOREIGN KEY (`parishid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location_region` FOREIGN KEY (`regionid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_location_subcounty` FOREIGN KEY (`subcountyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `locationdetail`;
CREATE TABLE `locationdetail` (
  `id` int(11) unsigned NOT NULL,
  `summary` mediumtext NOT NULL,
  `businesssector` mediumtext NOT NULL,
  `tourismsector` mediumtext NOT NULL,
  `cropproduction` mediumtext NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `livestockproduction` mediumtext NOT NULL,
  `handcraftsector` mediumtext NOT NULL,
  `fishproduction` mediumtext NOT NULL,
  `agriculturalinputprices` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_locationdetail_createdby` (`createdby`),
  KEY `fk_locationdetail_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_locationdetail_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_locationdetail_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_locationdetail_location` FOREIGN KEY (`id`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `locationstatistic`;
CREATE TABLE `locationstatistic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locationid` int(10) unsigned NOT NULL,
  `startdate` date NOT NULL,
  `enddate` date NOT NULL,
  `statistic` int(11) NOT NULL,
  `value` decimal(10,1) unsigned DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_locationstatistic_location` (`locationid`),
  KEY `unique_locationstatistic_statistic_period` (`statistic`,`startdate`,`enddate`),
  KEY `fk_locationstatistic_createdby` (`createdby`),
  KEY `fk_locationstatistic_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_locationstatistic_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_locationstatistic_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_locationstatistic_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `lookupquery`;
CREATE TABLE `lookupquery` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `querystring` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `lookuptype`;
CREATE TABLE `lookuptype` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_lookuptype_createdby` (`createdby`),
  KEY `fk_lookuptype_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_lookuptype_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lookuptype_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `lookuptypevalue`;
CREATE TABLE `lookuptypevalue` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lookuptypeid` int(11) unsigned NOT NULL,
  `lookuptypevalue` varchar(50) NOT NULL,
  `lookupvaluedescription` varchar(255) NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `datecreated` datetime NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_lookuptypevalue_lookuptypeid` (`lookuptypeid`),
  CONSTRAINT `fk_lookuptypevalue_lookuptypeid` FOREIGN KEY (`lookuptypeid`) REFERENCES `lookuptype` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `marketanalysisreport`;
CREATE TABLE `marketanalysisreport` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `volume` tinyint(3) unsigned NOT NULL,
  `number` tinyint(3) unsigned NOT NULL,
  `reportdate` date NOT NULL,
  `highlights` mediumtext NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filesize` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_marketanalysisreport_reportdate` (`reportdate`),
  UNIQUE KEY `unique_marketanalysisreport_volume_number` (`volume`,`number`),
  KEY `fk_marketanalysisreport_createdby` (`createdby`),
  KEY `fk_marketanalysisreport_lastupdatedby` (`lastupdatedby`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `offer`;
CREATE TABLE `offer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contact` varchar(255) NOT NULL DEFAULT '',
  `commodityid` int(11) unsigned NOT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `price` int(11) unsigned NOT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `offertype` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `telephone` varchar(255) NOT NULL,
  `expirydate` date NOT NULL,
  `notes` varchar(500) DEFAULT '',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_offer_category_createdby` (`createdby`) USING BTREE,
  KEY `idx_offer_category_lastupdatedby` (`lastupdatedby`) USING BTREE,
  KEY `idx_offer_commodity` (`commodityid`) USING BTREE,
  KEY `idx_offer_location` (`locationid`) USING BTREE,
  CONSTRAINT `fk_offer_commodity` FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_offer_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_offer_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_offer_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `organisation`;
CREATE TABLE `organisation` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `abbreviation` varchar(25) DEFAULT NULL,
  `address` varchar(500) NOT NULL,
  `logo` varchar(55) DEFAULT NULL,
  `phone` varchar(50) NOT NULL,
  `fax` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `subscriptionexpirydate` datetime NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `parentid` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `fk_organisation_createdby` (`createdby`),
  KEY `fk_organisation_lastupdatedby` (`lastupdatedby`),
  KEY `fk_organisation_parentid` (`parentid`),
  CONSTRAINT `fk_organisation_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_organisation_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_organisation_parentid` FOREIGN KEY (`parentid`) REFERENCES `organisation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `organisationdistrict`;
CREATE TABLE `organisationdistrict` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `districtid` int(11) unsigned NOT NULL,
  `organisationid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_organisationdistrict_organisationid` (`organisationid`),
  KEY `fk_organisationdistrict_districtid` (`districtid`),
  CONSTRAINT `fk_organisationdistrict_districtid` FOREIGN KEY (`districtid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_organisationdistrict_organisationid` FOREIGN KEY (`organisationid`) REFERENCES `organisation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;


DROP TABLE IF EXISTS `pricecategory`;
CREATE TABLE `pricecategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_price_category_name` (`name`),
  KEY `fk_price_category_createdby` (`createdby`),
  KEY `fk_price_category_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_commodity_category_createdby0` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_commodity_category_lastupdatedby0` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `pricesource`;
CREATE TABLE `pricesource` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT '',
  `contactperson` varchar(100) DEFAULT NULL,
  `phone` varchar(50) NOT NULL,
  `email` varchar(255) CHARACTER SET latin1 DEFAULT '',
  `address` varchar(500) NOT NULL,
  `notes` varchar(1000) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT '',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `locationid` int(11) unsigned NOT NULL,
  `applicationtype` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pricesource_location` (`locationid`) USING BTREE,
  KEY `index_pricesource_applicationtype` (`applicationtype`),
  CONSTRAINT `fk_pricesource_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `pricesourcecategory`;
CREATE TABLE `pricesourcecategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pricesourceid` int(11) unsigned DEFAULT NULL,
  `pricecategoryid` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_pricesource_pricecategory` (`pricecategoryid`,`pricesourceid`),
  KEY `fk_pricesourcecategory_pricesourceid` (`pricesourceid`),
  CONSTRAINT `fk_pricesourcecategory_pricecategoryid` FOREIGN KEY (`pricecategoryid`) REFERENCES `pricecategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pricesourcecategory_pricesourceid` FOREIGN KEY (`pricesourceid`) REFERENCES `pricesource` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `session`;
CREATE TABLE `session` (
  `id` char(32) NOT NULL DEFAULT '',
  `modified` int(11) DEFAULT NULL,
  `lifetime` int(11) DEFAULT NULL,
  `data` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `touristattraction`;
CREATE TABLE `touristattraction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `districtid` int(10) unsigned NOT NULL,
  `subcountyid` int(10) unsigned DEFAULT NULL,
  `physicallocation` varchar(255) NOT NULL DEFAULT '',
  `touristattractions` mediumtext NOT NULL,
  `priceoffers` mediumtext NOT NULL,
  `accomodation` mediumtext NOT NULL,
  `entertainment` mediumtext NOT NULL,
  `transport` mediumtext NOT NULL,
  `otherservices` mediumtext NOT NULL,
  `booking` mediumtext NOT NULL,
  `contact` varchar(255) NOT NULL DEFAULT '',
  `tourpackages` mediumtext NOT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_tourist_attraction` (`name`),
  KEY `fk_touristattraction_district` (`districtid`),
  KEY `fk_touristattraction_subcounty` (`subcountyid`),
  KEY `fk_touristattraction_createdby` (`createdby`),
  KEY `fk_touristattraction_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_touristattraction_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_touristattraction_district` FOREIGN KEY (`districtid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_touristattraction_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_touristattraction_subcounty` FOREIGN KEY (`subcountyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `useraccount`;
CREATE TABLE `useraccount` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `othername` varchar(255) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `phonenumber` varchar(15) DEFAULT NULL,
  `phonenumber2` varchar(15) DEFAULT NULL,
  `password` varchar(50) NOT NULL DEFAULT '',
  `activationkey` varchar(50) DEFAULT NULL,
  `notes` varchar(1000) DEFAULT NULL,
  `securityquestion` varchar(255) NOT NULL DEFAULT '',
  `securityanswer` varchar(255) NOT NULL DEFAULT '',
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned DEFAULT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  `isactive` enum('Y','N') DEFAULT 'N',
  `loginretries` int(11) DEFAULT NULL,
  `nextpasswordchangedate` date DEFAULT NULL,
  `lastlogindate` datetime DEFAULT NULL,
  `changepassword` enum('N','Y') NOT NULL DEFAULT 'Y',
  `locationid` int(11) unsigned DEFAULT NULL,
  `marketid` int(11) unsigned DEFAULT NULL,
  `applicationtype` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `organisationid` int(11) unsigned DEFAULT NULL,
  `activationdate` datetime DEFAULT NULL,
  `agreedtoterms` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `fk_useraccount_createdby` (`createdby`),
  KEY `fk_useraccount_lastupdatedby` (`lastupdatedby`),
  KEY `fk_useraccount_location` (`locationid`),
  KEY `fk_useraccount_marketid` (`marketid`),
  KEY `fk_useraccount_organisationid` (`organisationid`),
  CONSTRAINT `fk_useraccount_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_useraccount_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_useraccount_location` FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_useraccount_marketid` FOREIGN KEY (`marketid`) REFERENCES `pricesource` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_useraccount_organisationid` FOREIGN KEY (`organisationid`) REFERENCES `organisation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `waterbody`;
CREATE TABLE `waterbody` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `description` varchar(500) CHARACTER SET latin1 DEFAULT NULL,
  `datecreated` datetime NOT NULL,
  `createdby` int(11) unsigned NOT NULL,
  `lastupdatedate` datetime DEFAULT NULL,
  `lastupdatedby` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_waterbody_createdby` (`createdby`),
  KEY `fk_waterbody_lastupdatedby` (`lastupdatedby`),
  CONSTRAINT `fk_waterbody_createdby` FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_waterbody_lastupdatedby` FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2013-05-03 19:01:21
