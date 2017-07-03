
Tools used
---------------
1) JAVA : version 1.8.0_91
2) Apache Tomcat 8.0.27
3) Netbeans 

Installation
-------------
1) Install java (download jdk.tar.gz file and extract)
2) Install apache tomcat (download tomcat.tar.gz file and extract)
3) Set following variables in .bashrc (in home directory)

	export JAVA_HOME=path_to_jdk
	export CATALINA_HOME=path_to_tomcat
	export PATH=$JAVA_HOME/bin:$CATALINA_HOME/bin:$PATH
	export CLASSPATH=$JAVA_HOME/lib:$CATALINA_HOME/lib:$CLASSPATH

	Run file by $. .bashrc
4) Create account to access tomcat UI
	goto tomcat_folder/conf/tomcat-users.xml

	Add following to the file : tomcat-users.xml

	<role rolename="manager-gui"/>
	<role rolename="manager-script"/>
	<role rolename="manager-jmx"/>
	<role rolename="manager-status"/>
	<user username="ratheesh" password="abc123" roles="manager-gui, manager-script,manager-jmx ,manager-status"/>

	And restart tomcat by [tomcat/bin]$ sh startup.sh
	UI can be accessed by localhost:8080 
	username: ratheesh, password:abc123

5) Install mysql
	Create database name : 'wicroftserver' by
	mysql> create database wicroftserver
	mysql> use wicroftserver

	Execute the sql commands in the file : 'wicroft_all.sql' // all related tables will be created

6) Goto : wicroft/src/java/com/iitb/cse
   Set the following in the file
   ------------------------------ 
    
    i) experimentDetailsDirectory = "<folder_path_for_wicroft_logs>"; // Wicroft directory to store all log files, experiment details
    
    ii) logfileLocation  = "<log4j_properties_filelocation>"; 	// log4j properties file location
    
    iii) DB_USER_NAME = "root";  							// mysql username
    iv)  DB_PASSWORD = "root123";							// mysql password
    v)   JDBC_DRIVER = "com.mysql.jdbc.Driver"; 			// mysql driver
    vi)  DB_URL = "jdbc:mysql://127.0.0.1/wicroftserver"; 	// URL to database 

7) The log4j.properties file 
-----------------------------
log4j libraries used for logging

log4j.rootLogger=DEBUG, Appender1,Appender2
log4j.appender.Appender1=org.apache.log4j.ConsoleAppender
log4j.appender.Appender1.layout=org.apache.log4j.PatternLayout
log4j.appender.Appender1.layout.ConversionPattern=%-7p %d [%t] %c %x - %m%n
log4j.appender.Appender2=org.apache.log4j.FileAppender
log4j.appender.Appender2.File=/home/cse/Downloads/Wicroft/wicroft_serverlog.txt
log4j.appender.Appender2.layout=org.apache.log4j.PatternLayout
log4j.appender.Appender2.layout.ConversionPattern=%-7p %d [%t] %c %x - %m%n

	1) Have console appender : log into console
	2) File appender : Log to file 
	   Full path to file can be specified in above
	   e.g log4j.appender.Appender2.File=/home/cse/Downloads/Wicroft/wicroft_serverlog.txt

8) Build the source file and copy to tomcat/webapps folder
9) goto to link localhost:8080/wicroft 
	login using the admin account (given in 'wicroft_all.sql' file)

10) Done !!!



