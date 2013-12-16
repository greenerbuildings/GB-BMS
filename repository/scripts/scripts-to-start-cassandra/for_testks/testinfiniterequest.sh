#!/bin/bash

now=$(date +"%T")
echo "Start time : $now" > time.txt
echo "--------------Test all possible queries---------------------------------------" >> time.txt
for ((  i = 0 ;  i <= 7777;  i++  ))
do
echo "--------------1. GET a Column---------------------------------------"
curl -X GET http://localhost:7777/data/testks/variables/test/datatype  -H 'Content-Type:"application/json"' 

echo "--------------2. GET a row---------------------------------------"
curl -X GET http://localhost:7777/data/testks/variables/test/  -H 'Content-Type:"application/json"' 

echo "--------------3. GET the last 100 Column of a row---------------------------------------"
curl -X GET http://localhost:7777/data/testks/week502012/test/?startcolumn=1754707727095\&lastcolumns=100  -H 'Content-Type:"application/json"'

echo "--------------4. GET a range of columns in a row---------------------------------------"
curl -X GET http://localhost:7777/data/testks/week502012/test/?startcolumn=1754707726437\&endcolumn=1354707722878  -H 'Content-Type:"application/json"'

 echo "--------------5. PUT a column---------------------------------------"
curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"updatedvalue":"123"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"datatype":"string"}' -H 'Content-Type:"application/json"'  
curl -X GET http://localhost:7777/data/testks/variables/test/updatedvalue  -H 'Content-Type:"application/json"'  

curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"updatedvalue":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"datatype":"boolean"}' -H 'Content-Type:"application/json"'  
curl -X GET http://localhost:7777/data/testks/variables/test/updatedvalue  -H 'Content-Type:"application/json"'  

curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"updatedvalue":123.44}' -H 'Content-Type:"application/json"' 
curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"datatype":"float"}' -H 'Content-Type:"application/json"'  
curl -X GET http://localhost:7777/data/testks/variables/test/updatedvalue  -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"updatedvalue":123}' -H 'Content-Type:"application/json"' 
curl -X PUT http://localhost:7777/data/testks/variables/test -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'  
curl -X GET http://localhost:7777/data/testks/variables/test/updatedvalue  -H 'Content-Type:"application/json"'


curl -X POST http://localhost:7777/search/testks/ -d '{"CQL":"SELECT * FROM variables"}' -H 'Content-Type:"application/json"' 
done
#for ((  i = 0 ;  i <= 7777;  i++  ))
#do
#curl -X PUT http://localhost:7777/data/testks/week492012/test -d '{"cn":123}' -H 'Content-Type:"application/json"' 
#curl -X GET http://localhost:7777/data/testks/variables/test  -H 'Content-Type:"application/json"' 
#curl -X GET http://localhost:7777/data/testks/variables/statusscreen3_326/updatedvalue  -H 'Content-Type:"application/json"' 
#curl -X POST http://localhost:7777/search/testks/ -d '{"CQL":"SELECT * FROM variables"}' -H 'Content-Type:"application/json"' 
#done
echo "Welcome back we are done" >>time.txt
now2=$(date +"%T")
echo "End time : $now2" >> time.txt



