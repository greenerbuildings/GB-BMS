#Blinds Hight 1
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight1_313 -d '{"serinstid":"serinst.blindsheight1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight1_313 -d '{"serinstname":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight1_313 -d '{"serinstservicetype":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellserviceinstancesin/pt3.13.room -d '{"serinst.blindsheight1_313":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight1_313 -d '{"serinstoperations":[{"operation":{"name":"setheight","parameters":[{"name":"height", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetypeinstances/blindsheight -d '{"serinst.blindsheight1_313":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"varid":"blindsheight1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"varname":"blindsheight1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"controllable":"true"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"domainstates":{"range":{"min":"0","max":"100","step":"1"},"costa":"1","costb":"0"}}}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"servicetype":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"updatedvalue":"100"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"routingkey":"potentiaal.floor3.floor.actuators.blinds.blindsheight1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight1_313 -d '{"varlocation":"pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellvariablesin/pt3.13.room -d '{"blindsheight1_313":"blindsheight1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/sertypevariablesin/blindsheight -d '{"blindsheight1_313":"blindsheight1_313"}' -H 'Content-Type:"application/json"'

#Blinds hight2 
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight2_313 -d '{"serinstid":"serinst.blindsheight2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight2_313 -d '{"serinstname":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight2_313 -d '{"serinstservicetype":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellserviceinstancesin/pt3.13.room -d '{"serinst.blindsheight2_313":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight2_313 -d '{"serinstoperations":[{"operation":{"name":"setheight","parameters":[{"name":"height", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetypeinstances/blindsheight -d '{"serinst.blindsheight2_313":"blinds.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"varid":"blindsheight2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"varname":"blindsheight2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"controllable":"true"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"domainstates":{"range":{"min":"0","max":"100","step":"1"},"costa":"1","costb":"0"}}}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"servicetype":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"updatedvalue":"100"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"routingkey":"potentiaal.floor3.floor.actuators.blinds.blindsheight2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight2_313 -d '{"varlocation":"pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellvariablesin/pt3.13.room -d '{"blindsheight2_313":"blindsheight2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/sertypevariablesin/blindsheight -d '{"blindsheight2_313":"blindsheight2_313"}' -H 'Content-Type:"application/json"'

#Blinds height3
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight3_313 -d '{"serinstid":"serinst.blindsheight3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight3_313 -d '{"serinstname":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight3_313 -d '{"serinstservicetype":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellserviceinstancesin/pt3.13.room -d '{"serinst.blindsheight3_313":"blindsheight.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsheight3_313 -d '{"serinstoperations":[{"operation":{"name":"setheight","parameters":[{"name":"height", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetypeinstances/blindsheight -d '{"serinst.blindsheight3_313":"blinds.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"varid":"blindsheight3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"varname":"blindsheight3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"controllable":"true"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"domainstates":{"range":{"min":"0","max":"100","step":"1"},"costa":"1","costb":"0"}}}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"servicetype":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"updatedvalue":"100"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"routingkey":"potentiaal.floor3.floor.actuators.blinds.blindsheight3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsheight3_313 -d '{"varlocation":"pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellvariablesin/pt3.13.room -d '{"blindsheight3_313":"blindsheight3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/sertypevariablesin/blindsheight -d '{"blindsheight3_313":"blindsheight3_313"}' -H 'Content-Type:"application/json"'


#Blind angle1
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle1_313 -d '{"serinstid":"serinst.blindsangle1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle1_313 -d '{"serinstname":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle1_313 -d '{"serinstservicetype":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellserviceinstancesin/pt3.13.room -d '{"serinst.blindsangle1_313":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle1_313 -d '{"serinstoperations":[{"operation":{"name":"setangle","parameters":[{"name":"angle", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetypeinstances/blindsangle -d '{"serinst.blindsangle1_313":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"varid":"blindsangle1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"varname":"blindsangle1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"controllable":"true"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"domainstates":{"range":{"min":"-90","max":"90","step":"1"},"costa":"0","costb":"0"}}}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"servicetype":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"updatedvalue":"-90"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"routingkey":"potentiaal.floor3.floor.actuators.blinds.blindsangle1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle1_313 -d '{"varlocation":"pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellvariablesin/pt3.13.room -d '{"blindsangle1_313":"blindsangle1_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/sertypevariablesin/blindsangle -d '{"blindsangle1_313":"blindsangle1_313"}' -H 'Content-Type:"application/json"'

#Blind angle2
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle2_313 -d '{"serinstid":"serinst.blindsangle2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle2_313 -d '{"serinstname":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle2_313 -d '{"serinstservicetype":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellserviceinstancesin/pt3.13.room -d '{"serinst.blindsangle2_313":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle2_313 -d '{"serinstoperations":[{"operation":{"name":"setangle","parameters":[{"name":"angle", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetypeinstances/blindsangle -d '{"serinst.blindsangle2_313":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"varid":"blindsangle2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"varname":"blindsangle2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"controllable":"true"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"domainstates":{"range":{"min":"-90","max":"90","step":"1"},"costa":"0","costb":"0"}}}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"servicetype":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"updatedvalue":"-90"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"routingkey":"potentiaal.floor3.floor.actuators.blinds.blindsangle2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle2_313 -d '{"varlocation":"pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellvariablesin/pt3.13.room -d '{"blindsangle2_313":"blindsangle2_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/sertypevariablesin/blindsangle -d '{"blindsangle2_313":"blindsangle2_313"}' -H 'Content-Type:"application/json"'

#Blind angle3
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle3_313 -d '{"serinstid":"serinst.blindsangle3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle3_313 -d '{"serinstname":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle3_313 -d '{"serinstservicetype":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellserviceinstancesin/pt3.13.room -d '{"serinst.blindsangle3_313":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/serviceinstance/serinst.blindsangle3_313 -d '{"serinstoperations":[{"operation":{"name":"setangle","parameters":[{"name":"angle", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetypeinstances/blindsangle -d '{"serinst.blindsangle3_313":"blindsangle.pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"varid":"blindsangle3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"varname":"blindsangle3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"controllable":"true"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"domainstates":{"range":{"min":"-90","max":"90","step":"1"},"costa":"0","costb":"0"}}}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"servicetype":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"updatedvalue":"-90"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"datatype":"integer"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"routingkey":"potentiaal.floor3.floor.actuators.blinds.blindsangle3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/variables/blindsangle3_313 -d '{"varlocation":"pt3.13.room"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellvariablesin/pt3.13.room -d '{"blindsangle3_313":"blindsangle3_313"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/sertypevariablesin/blindsangle -d '{"blindsangle3_313":"blindsangle3_313"}' -H 'Content-Type:"application/json"'

#Blinds service definition
#blindsheight
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blindsheight -d '{"sertypeid":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blindsheight -d '{"sertypename":"blindsheight"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blindsheight -d '{"sertypeoperations":[{"operation":{"name":"setheight","parameters":[{"name":"height", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellservicetypesin/pt3.13.room -d '{"blindsheight":"blindsheight"}' -H 'Content-Type:"application/json"'

#Blindsangle   
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blindsangle -d '{"sertypeid":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blindsangle -d '{"sertypename":"blindsangle"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blindsangle -d '{"sertypeoperations":[{"operation":{"name":"setangle","parameters":[{"name":"angle", "value":"0"}]}}]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellservicetypesin/pt3.13.room -d '{"blindsangle":"blindsangle"}' -H 'Content-Type:"application/json"'



# Excess
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeid":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypename":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeoperations":["none"]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellservicetypesin/pt3.13.room -d '{"blinds":"blinds"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeid":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypename":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeoperations":["none"]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellservicetypesin/pt3.13.room -d '{"blinds":"blinds"}' -H 'Content-Type:"application/json"'

curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeid":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypename":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeoperations":["none"]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellservicetypesin/pt3.13.room -d '{"blinds":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeid":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypename":"blinds"}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/servicetype/blinds -d '{"sertypeoperations":["none"]}' -H 'Content-Type:"application/json"'
curl -X PUT http://localhost:7777/data/gbrepository/cellservicetypesin/pt3.13.room -d '{"blinds":"blinds"}' -H 'Content-Type:"application/json"'








