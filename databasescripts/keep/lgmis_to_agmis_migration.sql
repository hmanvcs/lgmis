
USE `ag1`;

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


/* Create table in target */
CREATE TABLE `locationdetail2`(
	`id` int(11) unsigned NOT NULL  , 
	`summary` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`businesssector` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`tourismsector` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`cropproduction` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`datecreated` datetime NOT NULL  , 
	`createdby` int(11) unsigned NOT NULL  , 
	`lastupdatedate` datetime NULL  , 
	`lastupdatedby` int(11) unsigned NULL  , 
	`livestockproduction` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`handcraftsector` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`fishproduction` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	`agriculturalinputprices` mediumtext COLLATE utf8_general_ci NOT NULL  , 
	PRIMARY KEY (`id`) , 
	KEY `fk_locationdetail_createdby`(`createdby`) , 
	KEY `fk_locationdetail_lastupdatedby`(`lastupdatedby`) 
) ENGINE=InnoDB DEFAULT CHARSET='utf8';


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
