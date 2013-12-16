VERSION:
--------
01/08/2013 1.5.1 - shutdown function improved
21/06/2013 v1.5 - clothing is function of external temperature - updated summer conditions 
21/02/2013 v1.4 - implemented feature #30
15/02/2013 v1.3 - restored communication with logger service - implemented feature #23
09/01/2013 v1.2 - removed communication with logger service
02/01/2013 v1.1


TFA-CFD Installation
--------------------
 1. TFA:
 1.1. Prerequisites
 a) webserver: Apache Tomcat(version>7.0.27) (listening port must be:31381)
 b) library :library needed  to run the module are included into the .war
 1.2. Installation
 a) put tfa.war file into ${catalina.home}/webapps
 b) run Apache Tomcat; The module will be automatically deployed
 2. CFD:
 2.1. Prerequisites
 a) webserver: Apache Tomcat(version>7.0.27) (listening port must be:31381)
 b) library :library needed  to run the module are included into the .war
 2.2. Installation
 a) put cfd.war file into ${catalina.home}/webapps
 b) run Apache Tomcat; The module will be automatically deployed

Starting/Stopping tfa/cfd
1. Starting: run Apache Tomcat; (${catalina.home}/bin/catalina.sh start)
The module will be automatically deployed
2. Stopping: shutdown Apache Tomcat (${catalina.home}/bin/catalina.sh stop)
OR
1. open Tomcat Web Application Manager (type ip:port of the web server on a browser)
2. clic on Manager App ;
3. log in;
4. start/stop/reload the required module

	

NOTE:
-----
(1) Both modules must run on the same machine.

(2) Default port used by Tomcat is 8080; change it to port 31381:
edit the file server.xml located in ${catalina.home}/conf;
change the string 
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
to
<Connector port="31381" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
			   
(3) Java 7 JDK/JRE must be installed on the machine

