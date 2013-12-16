#Building Information
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.room -d '{"cellid":"mf7.82.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.room -d '{"cellname":"room.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.room -d '{"room":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.floor -d '{"mf7.82.room":"room.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk1 -d '{"cellid":"mf7.82.desk1"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk1 -d '{"cellname":"desk1.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk1 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk1":"desk1.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk2 -d '{"cellid":"mf7.82.desk2"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk2 -d '{"cellname":"desk2.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk2 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk2":"desk2.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk3 -d '{"cellid":"mf7.82.desk3"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk3 -d '{"cellname":"desk3.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk3 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk3":"desk3.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk4 -d '{"cellid":"mf7.82.desk4"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk4 -d '{"cellname":"desk4.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk4 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk4":"desk4.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk5 -d '{"cellid":"mf7.82.desk5"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk5 -d '{"cellname":"desk5.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk5 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk5":"desk5.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk6 -d '{"cellid":"mf7.82.desk6"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk6 -d '{"cellname":"desk6.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk6 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk6":"desk6.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk7 -d '{"cellid":"mf7.82.desk7"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk7 -d '{"cellname":"desk7.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk7 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk7":"desk7.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk8 -d '{"cellid":"mf7.82.desk8"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk8 -d '{"cellname":"desk8.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk8 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk8":"desk8.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk9 -d '{"cellid":"mf7.82.desk9"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk9 -d '{"cellname":"desk9.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk9 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk9":"desk9.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk10 -d '{"cellid":"mf7.82.desk10"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk10 -d '{"cellname":"desk10.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk10 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk10":"desk10.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk11 -d '{"cellid":"mf7.82.desk11"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk11 -d '{"cellname":"desk11.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk11 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk11":"desk11.mf7.82"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk12 -d '{"cellid":"mf7.82.desk12"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cells/mf7.82.desk12 -d '{"cellname":"desk12.mf7.82"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/celltype/mf7.82.desk12 -d '{"desk":true}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellsinside/mf7.82.room -d '{"mf7.82.desk12":"desk12.mf7.82"}' -H 'Content-Type:"application/json"'
