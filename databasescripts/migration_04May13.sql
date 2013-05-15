
delete from lookupquery where name = 'AVAILABLE_LGMIS_DISTRICTS';
insert into lookupquery (name, description, querystring) values ('AVAILABLE_LGMIS_DISTRICTS', 'All LGMIS locations', 'SELECT ld.locationid AS optionvalue, l.name as optiontext FROM locationdetail AS ld Inner Join location AS l ON ld.locationid = l.id');


/* Foreign Keys must be dropped in the target to ensure that requires changes can be done*/

ALTER TABLE `contact` DROP FOREIGN KEY `fk_contact_createdby` ;

ALTER TABLE `contact` DROP FOREIGN KEY `fk_contact_lastupdatedby` ;

ALTER TABLE `contact` DROP FOREIGN KEY `fk_contact_location` ;

ALTER TABLE `contact` DROP FOREIGN KEY `fk_contact_subcounty` ;

ALTER TABLE `cropproduction` DROP FOREIGN KEY `fk_cropproduction_collector` ;

ALTER TABLE `cropproduction` DROP FOREIGN KEY `fk_cropproduction_commodity` ;

ALTER TABLE `cropproduction` DROP FOREIGN KEY `fk_cropproduction_createdby` ;

ALTER TABLE `cropproduction` DROP FOREIGN KEY `fk_cropproduction_lastupdatedby` ;

ALTER TABLE `cropproduction` DROP FOREIGN KEY `fk_cropproduction_location` ;

ALTER TABLE `livestockproduction` DROP FOREIGN KEY `fk_livestockproduction_collector` ;

ALTER TABLE `livestockproduction` DROP FOREIGN KEY `fk_livestockproduction_commodity` ;

ALTER TABLE `livestockproduction` DROP FOREIGN KEY `fk_livestockproduction_createdby` ;

ALTER TABLE `livestockproduction` DROP FOREIGN KEY `fk_livestockproduction_lastupdatedby` ;

ALTER TABLE `livestockproduction` DROP FOREIGN KEY `fk_livestockproduction_location` ;

ALTER TABLE `locationdetail` DROP FOREIGN KEY `fk_locationdetail_createdby` ;

ALTER TABLE `locationdetail` DROP FOREIGN KEY `fk_locationdetail_lastupdatedby` ;

ALTER TABLE `locationdetail` DROP FOREIGN KEY `fk_locationdetail_location` ;

ALTER TABLE `locationstatistic` DROP FOREIGN KEY `fk_locationstatistic_createdby` ;

ALTER TABLE `locationstatistic` DROP FOREIGN KEY `fk_locationstatistic_lastupdatedby` ;

ALTER TABLE `locationstatistic` DROP FOREIGN KEY `fk_locationstatistic_location` ;


/* Alter table in target */
ALTER TABLE `commodity` 
	ADD COLUMN `image` varchar(255)  COLLATE utf8_general_ci NULL after `maxprice`, COMMENT='';

/* Alter table in target */
ALTER TABLE `contact` 
	ADD COLUMN `countyid` int(11) unsigned   NULL after `locationid`, 
	CHANGE `subcountyid` `subcountyid` int(11) unsigned   NULL after `countyid`, 
	CHANGE `idorpassportno` `idorpassportno` varchar(255)  COLLATE latin1_general_ci NULL after `subcountyid`, 
	CHANGE `driverlicenceno` `driverlicenceno` varchar(255)  COLLATE latin1_general_ci NULL after `idorpassportno`, 
	CHANGE `licenceno` `licenceno` varchar(255)  COLLATE latin1_general_ci NULL after `driverlicenceno`, 
	CHANGE `dateofregistration` `dateofregistration` date   NULL after `licenceno`, 
	CHANGE `numberofmale` `numberofmale` int(11) unsigned   NOT NULL after `dateofregistration`, 
	CHANGE `numberoffemale` `numberoffemale` int(11) unsigned   NOT NULL after `numberofmale`, 
	CHANGE `businessdescription` `businessdescription` mediumtext  COLLATE latin1_general_ci NULL after `numberoffemale`, 
	CHANGE `goodsorservicesoffered` `goodsorservicesoffered` mediumtext  COLLATE latin1_general_ci NULL after `businessdescription`, 
	CHANGE `numberofoutlets` `numberofoutlets` int(11) unsigned   NOT NULL after `goodsorservicesoffered`, 
	CHANGE `wishtoadvertise` `wishtoadvertise` tinyint(4) unsigned   NOT NULL after `numberofoutlets`, 
	CHANGE `goodsorservicetoadvertise` `goodsorservicetoadvertise` mediumtext  COLLATE latin1_general_ci NULL after `wishtoadvertise`, 
	CHANGE `vatnumber` `vatnumber` varchar(255)  COLLATE latin1_general_ci NULL after `goodsorservicetoadvertise`, 
	CHANGE `tinnumber` `tinnumber` varchar(255)  COLLATE latin1_general_ci NULL after `vatnumber`, 
	ADD COLUMN `categoryid` int(11) unsigned   NULL after `tinnumber`, 
	ADD KEY `fk_contact_categoryid`(`categoryid`), 
	ADD KEY `fk_contact_county`(`countyid`), COMMENT='';

/* Create table in target */
CREATE TABLE `content`(
	`id` int(11) unsigned NOT NULL  auto_increment , 
	`pagename` varchar(50) COLLATE utf8_general_ci NOT NULL  , 
	`pagetitle` varchar(25) COLLATE utf8_general_ci NOT NULL  , 
	`summary` varchar(1000) COLLATE utf8_general_ci NULL  , 
	`leftcolumnone` blob NULL  , 
	`leftcolumntwo` blob NULL  , 
	`leftcolumnthree` blob NULL  , 
	`rightcolumnone` blob NULL  , 
	`rightcolumntwo` blob NULL  , 
	`rightcolumnthree` blob NULL  , 
	`locationid` int(11) unsigned NULL  , 
	`ispublished` tinyint(4) unsigned NULL  , 
	`order` tinyint(4) unsigned NULL  , 
	`datecreated` datetime NOT NULL  , 
	`createdby` int(11) unsigned NOT NULL  , 
	`lastupdatedate` datetime NULL  , 
	`lastupdatedby` int(11) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	KEY `fk_locationdetail_createdby`(`createdby`) , 
	KEY `fk_locationdetail_lastupdatedby`(`lastupdatedby`) , 
	KEY `fk_locationdetail_locationid`(`locationid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8';


/* Create table in target */
CREATE TABLE `contentimage`(
	`id` int(11) unsigned NOT NULL  auto_increment , 
	`pageid` int(11) unsigned NOT NULL  , 
	`filename` varchar(255) COLLATE utf8_general_ci NOT NULL  , 
	`filepath` varchar(500) COLLATE utf8_general_ci NOT NULL  , 
	`captiontitle` varchar(50) COLLATE utf8_general_ci NULL  , 
	`captiondetail` varchar(500) COLLATE utf8_general_ci NULL  , 
	`hascaption` tinyint(4) unsigned NULL  , 
	`ispublished` tinyint(4) unsigned NULL  , 
	`order` tinyint(4) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	KEY `fk_contentimage_pageid`(`pageid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8';


/* Alter table in target */
ALTER TABLE `cropproduction` 
	ADD COLUMN `prodtype` varchar(50)  COLLATE utf8_general_ci NULL after `locationid`, 
	ADD COLUMN `cost` decimal(10,2) unsigned   NOT NULL DEFAULT '0.00' after `prodtype`, 
	ADD COLUMN `costtype` varchar(50)  COLLATE utf8_general_ci NULL after `cost`, 
	ADD COLUMN `yield` decimal(10,2) unsigned   NOT NULL DEFAULT '0.00' after `costtype`, 
	ADD COLUMN `yieldtype` varchar(50)  COLLATE utf8_general_ci NULL after `yield`, 
	ADD COLUMN `unitid` int(11) unsigned   NULL after `yieldtype`, 
	CHANGE `startdate` `startdate` date   NOT NULL after `unitid`, 
	CHANGE `enddate` `enddate` date   NOT NULL after `startdate`, 
	ADD COLUMN `quarter` varchar(15)  COLLATE utf8_general_ci NULL after `enddate`, 
	CHANGE `datecreated` `datecreated` datetime   NOT NULL after `quarter`, 
	CHANGE `createdby` `createdby` int(11) unsigned   NOT NULL after `datecreated`, 
	CHANGE `lastupdatedate` `lastupdatedate` datetime   NULL after `createdby`, 
	CHANGE `lastupdatedby` `lastupdatedby` int(11) unsigned   NULL after `lastupdatedate`, 
	CHANGE `datecollected` `datecollected` date   NOT NULL after `lastupdatedby`, 
	CHANGE `collectedbyid` `collectedbyid` int(11) unsigned   NOT NULL after `datecollected`, 
	ADD COLUMN `seedsource` varchar(1000)  COLLATE utf8_general_ci NULL after `collectedbyid`, 
	ADD COLUMN `comcustom` varchar(255)  COLLATE utf8_general_ci NULL after `seedsource`, 
	ADD COLUMN `comtypecustom` varchar(50)  COLLATE utf8_general_ci NULL after `comcustom`, 
	ADD COLUMN `customprodtype` varchar(50)  COLLATE utf8_general_ci NULL after `comtypecustom`, 
	DROP COLUMN `seedcost`, 
	DROP COLUMN `yieldperacre`, COMMENT='';

/* Alter table in target */
ALTER TABLE `livestockproduction` 
	ADD COLUMN `cost` decimal(10,2) unsigned   NOT NULL DEFAULT '0.00' after `locationid`, 
	CHANGE `yield` `yield` decimal(10,2) unsigned   NOT NULL DEFAULT '0.00' after `cost`, 
	ADD COLUMN `costtype` varchar(50)  COLLATE utf8_general_ci NULL after `collectedbyid`, 
	ADD COLUMN `yieldtype` varchar(50)  COLLATE utf8_general_ci NULL after `costtype`, 
	ADD COLUMN `prodtype` varchar(50)  COLLATE utf8_general_ci NULL after `yieldtype`, 
	ADD COLUMN `unitid` int(11) unsigned   NULL after `prodtype`, 
	ADD COLUMN `quarter` varchar(15)  COLLATE utf8_general_ci NULL after `unitid`, 
	ADD COLUMN `seedsource` varchar(1000)  COLLATE utf8_general_ci NULL after `quarter`, 
	ADD COLUMN `comcustom` varchar(255)  COLLATE utf8_general_ci NULL after `seedsource`, 
	ADD COLUMN `comtypecustom` varchar(50)  COLLATE utf8_general_ci NULL after `comcustom`, 
	ADD COLUMN `customprodtype` varchar(50)  COLLATE utf8_general_ci NULL after `comtypecustom`, 
	ADD COLUMN `customunit` varchar(50)  COLLATE utf8_general_ci NULL after `customprodtype`, 
	ADD COLUMN `customyieldtype` varchar(50)  COLLATE utf8_general_ci NULL after `customunit`, 
	DROP COLUMN `breedcost`, COMMENT='';

/* Alter table in target */
ALTER TABLE `locationdetail` 
	CHANGE `id` `id` int(11) unsigned   NOT NULL auto_increment first, 
	ADD COLUMN `locationid` int(11) unsigned   NOT NULL after `id`, 
	CHANGE `summary` `summary` mediumtext  COLLATE utf8_general_ci NULL after `locationid`, 
	CHANGE `businesssector` `businesssector` mediumtext  COLLATE utf8_general_ci NULL after `summary`, 
	CHANGE `tourismsector` `tourismsector` mediumtext  COLLATE utf8_general_ci NULL after `businesssector`, 
	CHANGE `cropproduction` `cropproduction` mediumtext  COLLATE utf8_general_ci NULL after `tourismsector`, 
	ADD COLUMN `image` varchar(255)  COLLATE utf8_general_ci NULL after `cropproduction`, 
	CHANGE `datecreated` `datecreated` datetime   NULL after `image`, 
	CHANGE `createdby` `createdby` int(11) unsigned   NULL after `datecreated`, 
	CHANGE `lastupdatedate` `lastupdatedate` datetime   NULL after `createdby`, 
	CHANGE `lastupdatedby` `lastupdatedby` int(11) unsigned   NULL after `lastupdatedate`, 
	CHANGE `livestockproduction` `livestockproduction` mediumtext  COLLATE utf8_general_ci NOT NULL after `lastupdatedby`, 
	CHANGE `handcraftsector` `handcraftsector` mediumtext  COLLATE utf8_general_ci NOT NULL after `livestockproduction`, 
	CHANGE `fishproduction` `fishproduction` mediumtext  COLLATE utf8_general_ci NOT NULL after `handcraftsector`, 
	CHANGE `agriculturalinputprices` `agriculturalinputprices` mediumtext  COLLATE utf8_general_ci NOT NULL after `fishproduction`, 
	ADD KEY `fk_locationdetail_location`(`locationid`), COMMENT='';


/* Alter table in target */
ALTER TABLE `locationstatistic` 
	ADD COLUMN `statisticid` int(10) unsigned   NULL after `enddate`, 
	ADD COLUMN `customstat` varchar(50)  COLLATE utf8_general_ci NULL after `statisticid`, 
	ADD COLUMN `unitid` int(11) unsigned   NULL after `customstat`, 
	ADD COLUMN `customunit` varchar(50)  COLLATE utf8_general_ci NULL after `unitid`, 
	CHANGE `value` `value` decimal(10,1) unsigned   NULL after `customunit`, 
	ADD COLUMN `period` varchar(15)  COLLATE utf8_general_ci NULL after `value`, 
	ADD COLUMN `source` varchar(255)  COLLATE utf8_general_ci NULL after `period`, 
	ADD COLUMN `notes` varchar(1000)  COLLATE utf8_general_ci NULL after `source`, 
	CHANGE `datecreated` `datecreated` datetime   NOT NULL after `notes`, 
	CHANGE `createdby` `createdby` int(11) unsigned   NOT NULL after `datecreated`, 
	CHANGE `lastupdatedate` `lastupdatedate` datetime   NULL after `createdby`, 
	CHANGE `lastupdatedby` `lastupdatedby` int(11) unsigned   NULL after `lastupdatedate`, 
	DROP COLUMN `statistic`, 
	ADD KEY `fk_commodityunit_unitid`(`unitid`), 
	ADD KEY `fk_locationstatistic_statisticid`(`statisticid`), 
	DROP KEY `unique_locationstatistic_statistic_period`, add KEY `unique_locationstatistic_statistic_period`(`startdate`,`enddate`), COMMENT='';

/* Create table in target */
CREATE TABLE `statistic`(
	`id` int(11) unsigned NOT NULL  auto_increment , 
	`type` int(11) unsigned NOT NULL  , 
	`value` varchar(500) COLLATE utf8_general_ci NOT NULL  , 
	`unitid` int(11) unsigned NULL  DEFAULT '16' , 
	`description` varchar(500) COLLATE utf8_general_ci NULL  , 
	`locationid` int(11) unsigned NULL  , 
	`createdby` int(11) unsigned NOT NULL  , 
	`datecreated` datetime NOT NULL  , 
	`lastupdatedate` datetime NULL  , 
	`lastupdatedby` int(11) unsigned NULL  , 
	PRIMARY KEY (`id`) , 
	KEY `fk_statistic_createdby`(`createdby`) , 
	KEY `fk_statistic_lastupdatedby`(`lastupdatedby`) , 
	KEY `fk_statistic_locationid`(`locationid`) , 
	KEY `fk_statistic_unitid`(`unitid`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8';


/* Alter table in target */
ALTER TABLE `touristattraction` 
	ADD COLUMN `image` varchar(255)  COLLATE utf8_general_ci NULL after `lastupdatedby`, COMMENT='';

/* Alter ForeignKey(s)in target */

ALTER TABLE `contact`
ADD CONSTRAINT `fk_contact_categoryid` 
FOREIGN KEY (`categoryid`) REFERENCES `commoditycategory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `contact`
ADD CONSTRAINT `fk_contact_county` 
FOREIGN KEY (`countyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/* Create ForeignKey(s) in Second database */ 

ALTER TABLE `content`
ADD CONSTRAINT `fk_content_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `content`
ADD CONSTRAINT `fk_content_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `content`
ADD CONSTRAINT `fk_content_locationid` 
FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/* Create ForeignKey(s) in Second database */ 

ALTER TABLE `contentimage`
ADD CONSTRAINT `fk_contentimage_pageid` 
FOREIGN KEY (`pageid`) REFERENCES `content` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;


/* Alter ForeignKey(s)in target */

ALTER TABLE `locationdetail`
ADD CONSTRAINT `fk_locationdetail_location` 
FOREIGN KEY (`locationid`) REFERENCES `agmis`.`location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;


/* Alter ForeignKey(s)in target */

ALTER TABLE `locationstatistic`
ADD CONSTRAINT `fk_commodityunit_unitid` 
FOREIGN KEY (`unitid`) REFERENCES `commodityunit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `locationstatistic`
ADD CONSTRAINT `fk_locationstatistic_statisticid` 
FOREIGN KEY (`statisticid`) REFERENCES `statistic` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/* Create ForeignKey(s) in Second database */ 

ALTER TABLE `statistic`
ADD CONSTRAINT `fk_statistic_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `statistic`
ADD CONSTRAINT `fk_statistic_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `statistic`
ADD CONSTRAINT `fk_statistic_locationid` 
FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `statistic`
ADD CONSTRAINT `fk_statistic_unitid` 
FOREIGN KEY (`unitid`) REFERENCES `commodityunit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
 

/* The foreign keys that were dropped are now re-created*/

ALTER TABLE `contact`
ADD CONSTRAINT `fk_contact_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `contact`
ADD CONSTRAINT `fk_contact_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `contact`
ADD CONSTRAINT `fk_contact_location` 
FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `contact`
ADD CONSTRAINT `fk_contact_subcounty` 
FOREIGN KEY (`subcountyid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `cropproduction`
ADD CONSTRAINT `fk_cropproduction_collector` 
FOREIGN KEY (`collectedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `cropproduction`
ADD CONSTRAINT `fk_cropproduction_commodity` 
FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `cropproduction`
ADD CONSTRAINT `fk_cropproduction_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `cropproduction`
ADD CONSTRAINT `fk_cropproduction_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `cropproduction`
ADD CONSTRAINT `fk_cropproduction_location` 
FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `livestockproduction`
ADD CONSTRAINT `fk_livestockproduction_collector` 
FOREIGN KEY (`collectedbyid`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `livestockproduction`
ADD CONSTRAINT `fk_livestockproduction_commodity` 
FOREIGN KEY (`commodityid`) REFERENCES `commodity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `livestockproduction`
ADD CONSTRAINT `fk_livestockproduction_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `livestockproduction`
ADD CONSTRAINT `fk_livestockproduction_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `livestockproduction`
ADD CONSTRAINT `fk_livestockproduction_location` 
FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `locationdetail`
ADD CONSTRAINT `fk_locationdetail_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `locationdetail`
ADD CONSTRAINT `fk_locationdetail_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `locationstatistic`
ADD CONSTRAINT `fk_locationstatistic_createdby` 
FOREIGN KEY (`createdby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `locationstatistic`
ADD CONSTRAINT `fk_locationstatistic_lastupdatedby` 
FOREIGN KEY (`lastupdatedby`) REFERENCES `useraccount` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `locationstatistic`
ADD CONSTRAINT `fk_locationstatistic_location` 
FOREIGN KEY (`locationid`) REFERENCES `location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
