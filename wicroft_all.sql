

CREATE TABLE `androidappusers` (
  `macaddress` varchar(25) NOT NULL,
  `email` varchar(50) NOT NULL,
  `lastheartbeat` datetime NOT NULL,
  `appversion` varchar(8) DEFAULT '0.0',
  `devicename` varchar(100) DEFAULT NULL,
  `androidVersion` varchar(8) DEFAULT '_',
  PRIMARY KEY (`macaddress`)
);



CREATE TABLE `control_file_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fileid` int(11) NOT NULL,
  `userid` int(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `maclist` varchar(18) DEFAULT NULL,
  `filedate` datetime DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `totalclients` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
);


CREATE TABLE `control_file_user_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fileid` int(11) NOT NULL,
  `userid` int(100) NOT NULL,
  `macaddr` varchar(18) DEFAULT NULL,
  `filesenddate` datetime DEFAULT NULL,
  `filereceiveddate` datetime DEFAULT NULL,
  `retry` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `statusmessage` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
);



CREATE TABLE `experimentdetails` (
  `expid` int(11) NOT NULL,
  `userid` int(100) NOT NULL,
  `macaddress` char(17) NOT NULL,
  `osversion` int(11) NOT NULL,
  `wifiversion` varchar(30) DEFAULT NULL,
  `rssi` varchar(5) DEFAULT NULL,
  `bssid` varchar(18) DEFAULT NULL,
  `ssid` varchar(25) DEFAULT NULL,
  `linkspeed` varchar(10) DEFAULT NULL,
  `numberofcores` int(11) NOT NULL,
  `storagespace` int(11) NOT NULL,
  `memory` int(11) NOT NULL,
  `processorspeed` int(11) NOT NULL,
  `wifisignalstrength` int(11) NOT NULL,
  `ipaddress` varchar(16) DEFAULT NULL,
  `port` varchar(6) DEFAULT NULL,
  `fileid` int(11) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `logfilereceived` tinyint(1) NOT NULL DEFAULT '0',
  `expover` tinyint(1) NOT NULL DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `statusmessage` varchar(100) DEFAULT NULL,
  `expoverDate` datetime DEFAULT NULL,
  `expreqsenddate` datetime DEFAULT NULL,
  `retry` tinyint(1) NOT NULL DEFAULT '0',
  `expackreceived` tinyint(1) NOT NULL DEFAULT '0',
  `expackreceiveddate` datetime DEFAULT NULL,
  `logfilereceiveddate` datetime DEFAULT NULL,
  PRIMARY KEY (`userid`,`expid`,`macaddress`),
  FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
);




CREATE TABLE `experiments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `starttime` datetime DEFAULT NULL,
  `endtime` datetime DEFAULT NULL,
  `fileid` int(11) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `expid` int(100) NOT NULL,
  `creationtime` datetime DEFAULT NULL,
  `statusmessage` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE CASCADE
);


 CREATE TABLE `users` (
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `userid` int(100) NOT NULL AUTO_INCREMENT,
  `instances` int(100) DEFAULT '0',
  `creationdate` datetime NOT NULL,
  PRIMARY KEY (`userid`)
);














