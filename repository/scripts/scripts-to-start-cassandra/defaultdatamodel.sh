#!/bin/bash

# the keyspace for the whole REPOSITORY is gbrepository
echo "CREATING api echo related Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY api (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY api ADD alive varchar"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/api/echo -d '{"alive":true}' -H 'Content-Type:"application/json"' 
#*************************************************************************#

#*************************************************************************#
#    cells related Column families
#*************************************************************************#
#   Building description related Column Families: the row key for building 
#   related column families is a unique ID of a cell, eg. room326, room3261 .....
#	1. 	cells 	containas basic information such as cell ID and cell name.
#	2. 	celltype 	to be defined .....
#	3. 	cellsinside 	contians columns of cells inside a psecific cell. The columns are in the form of {"cellid":"cellname"}, i.e. column name is represents the unique ID of the  and column value gives the name of the cell that is inside.
#	4. 	celldevicesin 	contains columns of all devices inside a cell. Each column is represented with {"device ID":"device name"}
#	5. 	cellservicetypesin 	contains columns of all service types that are available in a cell. Each column is represented with {"service type ID":"service type name"}
#	6. 	cellserviceinstancesin 	contains columns of all serviceinstances that are available in a cell. Each column is represented with {"service type ID":"service type name"}
#	7. 	cellvariablesin 	contains columns of all variables related to a cell in the form of columns represented as {"variable ID":"variable name"}
#	8. 	cellproperties 	 to be defined in detail
echo "CREATING Building description related Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY cells (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"' 

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY celltype (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY cellsinside (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY celldevicesin (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY cellservicetypesin (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY cellserviceinstancesin (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY cellvariablesin (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY cellproperties (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

echo "Inserting sample data related to column family cells"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY cells ADD cellid varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY cells ADD cellname varchar"}' -H 'Content-Type:"application/json"' 



#*************************************************************************#
#    service types related data
#*************************************************************************#
#    Service types related column families: These column families will have a unique servie type ID as a row key such as ser1, ser2, ser3 ...

#	1. 	servicetype 	containas basic information such as service type ID and service type name.
#	2. 	sertypeoperations 	 it contains the columns of operations, for example a service type light can have operations {"name1":"turn on"} and {"name2":"turn off"}
#	3. 	sertypevariablesin 	contains columns of all variables in a service types. Each column is represented with {"variable ID":"variable name"}
echo "inserting data for service types related Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY servicetype (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY sertypeoperations (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY sertypevariablesin (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY servicetypeinstances (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY servicetype ADD sertypeid varchar"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY servicetype ADD sertypename varchar"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY servicetype ADD sertypeoperations varchar"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY sertypeoperations ADD name1 varchar"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY sertypeoperations ADD name2 varchar"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY sertypevariablesin ADD name1 varchar"}' -H 'Content-Type:"application/json"'



#*************************************************************************#
#    service instances related column families
#*************************************************************************#
#    Service instances related column families: Similar to the above column famileis, service instancea also have a unique ID that is used as a row key.
#	1. 	serviceinstance 	containas basic information such as service instance ID, service type in which it belongs, and service instance name.
#	2. 	serinstancebindings 	 to be defined
#	3. 	serinstanceeffective 	contains group of columns of data that indicate the areas (locations) in which the service instance is effective at. For in stance {"name1":"room326"}, {"name2":"room3261"}
echo "inserting data for service instances related Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY serviceinstance (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY serinstancebindings (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY serinstanceeffective (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY serviceinstance ADD serinstid varchar"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY serviceinstance ADD serinstname varchar"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY serviceinstance ADD serinstservicetype varchar"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY serviceinstance ADD serinstbindings varchar"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY serviceinstance ADD serinsteffective varchar"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY serviceinstance ADD serinstoperations varchar"}' -H 'Content-Type:"application/json"'

curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE INDEX sertype ON serviceinstance (serinstservicetype)"}' -H 'Content-Type:"application/json"'

#*************************************************************************#
#    devices related column families
#*************************************************************************#
#    Devices related column families: Similarly, devices also have a unique ID that is used as a row key.
#1. 	devices 	containas basic information such as device ID, device name.
#2. 	devproperties 	contains group of columns which represent the properties of device such as its power consumption. (for details ..to be defined )
echo "CREATING devices related Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY devices (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY devproperties (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'



#*************************************************************************#
#    Variables related Column families
#*************************************************************************#
#    Variables related column families: All variables also have a unique ID that is used as a row key.
#1. 	variables 	containas basic information such as variable ID, variable name, and variable controllabaility (boolean).
#2. 	vardomainstates 	contains group of columns which represent possible states of the variable.  For example a variable called presence may have domain states {"name1":"1"}, {"name2":"0"}
echo "CREATING variables related Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY variables (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY vardomainstates (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'
#curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"CREATE COLUMNFAMILY vartags (KEY varchar PRIMARY KEY)"}' -H 'Content-Type:"application/json"'

echo "Inserting data related to variables  Column Families"
echo "-----------------------------------------------------"
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD varid varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD varname varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD controllable varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD routingkey varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD updatedvalue varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD domainstates varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD servicetype varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD datatype varchar"}' -H 'Content-Type:"application/json"' 
curl -X POST http://localhost:7777/search/gbrepository/ -d '{"CQL":"ALTER COLUMNFAMILY variables ADD varlocation varchar"}' -H 'Content-Type:"application/json"' 









