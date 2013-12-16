#!/bin/bash

echo "#!/bin/bash" > cellsdata_to_repo.sh
echo "echo \"data related to buildig description CFs\"" >> cellsdata_to_repo.sh
chmod +x cellsdata_to_repo.sh

cat cells_list.txt | tr '[A-Z]' '[a-z]' > cells_list2.txt
#1-cellid	2-Floor	3-location	4-Cellname	5-Number-of-sub-cells	6-Number-of-Areas	7-Cell-Type
awk '{print ("curl -X PUT http://localhost:7777/data/testks/cells/"$1,"-d \047{\"cellid\":\""$1"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/cells/"$1,"-d \047{\"cellname\":\""$4"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/celltype/"$1,"-d \047{\""$7"\":true}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/cellsinside/"$3,"-d \047{\""$1"\":\""$4"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\n")}' cells_list2.txt >> cellsdata_to_repo.sh
echo "  " >> cellsdata_to_repo.sh
echo "echo \"    \"" >> cellsdata_to_repo.sh


echo "#!/bin/bash" > vardata_to_repo.sh
chmod +x vardata_to_repo.sh
echo "echo \"============================================================\"" >> vardata_to_repo.sh
echo "echo \"data related to variables\"" >> vardata_to_repo.sh
cat variables_list.txt | tr '[A-Z]' '[a-z]' > variables_list2.txt
#1-VariableID	2-variableName	3-variableLoc	4-varControlability	5-varDomainStates	6-variable_serviceTypeID	7-datatype	8-operations	9-rmq_routingkey	10-Domain-states-all-in-string
awk '{print ("curl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"varid\":\""$1"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"varname\":\""$1"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"controllable\":\""$4"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"domainstates\":"$5"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"servicetype\":\""$6"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"updatedvalue\":\"none\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"datatype\":\""$7"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"routingkey\":\""$9"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"varlocation\":\""$3"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$3,"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/sertypevariablesin/"$6,"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\n")}' variables_list2.txt >> vardata_to_repo.sh
#"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"routingkey\":\""$8"\"}\047 -H \047Content-Type:\"application/json\"\047" \
#"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"vardomain\":"$5"}\047 -H \047Content-Type:\"application/json\"\047" \
#"\ncurl -X PUT http://localhost:7777/data/testks/variables/"$1,"-d \047{\"varlocation\":\""$3"\"}\047 -H \047Content-Type:\"application/json\"\047" \
#"\n")}' variables_list2.txt >> vardata_to_repo.sh

echo "#!/bin/bash" > sertypedata_to_repo.sh
chmod +x sertypedata_to_repo.sh
echo "echo \"============================================================\"" >> sertypedata_to_repo.sh
echo "echo \"data related to servicetype\"" >> sertypedata_to_repo.sh
cat servicetype_list.txt | tr '[A-Z]' '[a-z]' > servicetype_list2.txt
#1-ServiceTypeID	2-ServiceTypeName	3-ServiceTypeLocation	4-operations	5-variables	6-Operations-all-in-string
awk '{print ("curl -X PUT http://localhost:7777/data/testks/servicetype/"$1,"-d \047{\"sertypeid\":\""$1"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/servicetype/"$1,"-d \047{\"sertypename\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/servicetype/"$1,"-d \047{\"sertypeoperations\":"$4"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/cellservicetypesin/"$3,"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\n")}' servicetype_list2.txt >> sertypedata_to_repo.sh


echo "#!/bin/bash" > serinstdata_to_repo.sh
chmod +x serinstdata_to_repo.sh
echo "echo \"============================================================\"" >> serinstdata_to_repo.sh
echo "echo \"data related to serviceinst\"" >> serinstdata_to_repo.sh
cat serviceinst_list.txt | tr '[A-Z]' '[a-z]' > serviceinst_list2.txt
#1-serviceinstanceID	2-serviceinstanceName	3-serinServiceTypeID	4-serinLocation	5-operations	6-variablesIn	7-serInstanceBindings	8-Operation-all-in-string
awk '{print ("curl -X PUT http://localhost:7777/data/testks/serviceinstance/"$1,"-d \047{\"serinstid\":\""$1"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/serviceinstance/"$1,"-d \047{\"serinstname\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/serviceinstance/"$1,"-d \047{\"serinstservicetype\":\""$3"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/cellserviceinstancesin/"$4,"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/serviceinstance/"$1,"-d \047{\"serinstoperations\":"$5"}\047 -H \047Content-Type:\"application/json\"\047" \
"\ncurl -X PUT http://localhost:7777/data/testks/servicetypeinstances/"$3,"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047" \
"\n")}' serviceinst_list2.txt >> serinstdata_to_repo.sh
#"\ncurl -X PUT http://localhost:7777/data/testks/serviceinstance/"$1,"-d \047{\"serinstbindings\":"$5"}\047 -H \047Content-Type:\"application/json\"\047" \
#"\ncurl -X PUT http://localhost:7777/data/testks/serviceinstance/"$1,"-d \047{\"serinsteffective\":\""$6"\"}\047 -H \047Content-Type:\"application/json\"\047" \



#echo "#!/bin/bash" > roomvar_to_repo.sh
#chmod +x roomvar_to_repo.sh
#echo "echo \"============================================================\"" >> roomvar_to_repo.sh
#echo "echo \"data related to variables location: ROOMVARs\"" >> roomvar_to_repo.sh
#echo "  " >> roomvar_to_repo.sh
#echo "echo \"    \"" >> roomvar_to_repo.sh
#awk '{if ($8 == "room") print $1}' cells_list2.txt > roomcells.txt
#awk '{printf("%s\t",$0) }' roomcells.txt > roomcells2.txt
#awk '{if ($3 == "room") print($1,$2)}' variables_list2.txt > roomvars.txt
#cat roomvars.txt  |  awk -v something="$(head -n 1 roomcells2.txt)" '{print $0" "something}'> 2roomcells2.txt
#awk '{for(i=0;i<NF;i++){if(i>1)print ("curl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$(i+1),"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047")}}' 2roomcells2.txt >> roomvar_to_repo.sh 
#awk '{for(i=0;i<NF;i++){if(i>1)print ($1, $2 , $(i+1))}}' 2roomcells2.txt

#echo "#!/bin/bash" > hallvar_to_repo.sh
#chmod +x hallvar_to_repo.sh
#echo "echo \"============================================================\"" >> hallvar_to_repo.sh
#echo "echo \"data related to variables location: HALLVARs\"" >> hallvar_to_repo.sh
#echo "  " >> hallvar_to_repo.sh
#echo "echo \"    \"" >> hallvar_to_repo.sh
#awk '{if ($8 == "hall") print $1}' cells_list2.txt > hallcells.txt
#awk '{printf("%s\t",$0) }' hallcells.txt > hallcells2.txt
#awk '{if (($3 == "hall.room.desk")||($3 == "hall.room")) print($1,$2)}' variables_list2.txt > hallvars.txt
#cat hallvars.txt  |  awk -v something="$(head -n 1 hallcells2.txt)" '{print $0" "something}'> 2hallcells2.txt
#awk '{for(i=0;i<NF;i++){if(i>1)print ("curl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$(i+1),"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047")}}' 2hallcells2.txt >> hallvar_to_repo.sh 

#echo "#!/bin/bash" > areavars_to_repo.sh
#chmod +x areavars_to_repo.sh
#echo "echo \"============================================================\"" >> areavars_to_repo.sh
#echo "echo \"data related to variables location: AREAVARs\"" >> areavars_to_repo.sh
#echo "  " >> areavars_to_repo.sh
#echo "echo \"    \"" >> areavars_to_repo.sh
#awk '{if (($8 == "area")||($8 == "room")||($8 == "hall")) print $1}' cells_list2.txt > areacells.txt
#awk '{printf("%s\t",$0) }' areacells.txt > areacells2.txt
#awk '{if (($3 == "room")||($3 == "hall.room")||($3 == "hall.room.desk")) print($1,$2)}' variables_list2.txt > areavars.txt
#cat areavars.txt  |  awk -v something="$(head -n 1 areacells2.txt)" '{print $0" "something}'> 2areacells2.txt
#awk '{for(i=0;i<NF;i++){if(i>1)print ("curl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$(i+1),"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047")}}' 2areacells2.txt >> areavars_to_repo.sh 

#echo "#!/bin/bash" > doorvars_to_repo.sh
#chmod +x doorvars_to_repo.sh
#echo "echo \"============================================================\"" >> doorvars_to_repo.sh
#echo "echo \"data related to variables location: AREAVARs\"" >> areavars_to_repo.sh
#echo "  " >> doorvars_to_repo.sh
#echo "echo \"    \"" >> doorvars_to_repo.sh
#awk '{if ($8 == "door") print $1}' cells_list2.txt > doorcells.txt
#awk '{printf("%s\t",$0) }' doorcells.txt > doorcells2.txt
#awk '{if ($3 == "door") print($1,$2)}' variables_list2.txt > doorvars.txt
#cat doorvars.txt  |  awk -v something="$(head -n 1 doorcells2.txt)" 'BEGIN{NR=2};{print $0" "something}'> 2doorcells2.txt
#awk '{for(i=0;i<NF;i++){if(i>1)print ("curl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$(i+1),"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047")}}' 2doorcells2.txt >> doorvars_to_repo.sh 

#echo "#!/bin/bash" > deskvars_to_repo.sh
#chmod +x deskvars_to_repo.sh
#echo "echo \"============================================================\"" >> deskvars_to_repo.sh
#echo "echo \"data related to variables location: DESKVARs\"" > deskvars_to_repo.sh
#echo "  " >> deskvars_to_repo.sh
#echo "echo \"    \"" >> deskvars_to_repo.sh
#awk '{if ($8 == "desk") print $1}' cells_list2.txt > deskcells.txt
#awk '{printf("%s\t",$0) }' deskcells.txt > deskcells2.txt
#awk '{if ($3 == "desk") print($1,$2)}' variables_list2.txt > deskvars.txt
#cat deskvars.txt  |  awk -v something="$(head -n 1 deskcells2.txt)" 'BEGIN{NR=2};{print $0" "something}'> 2deskcells2.txt
#awk '{for(i=0;i<NF;i++){if(i>1)print ("curl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$(i+1),"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047")}}' 2deskcells2.txt >> deskvars_to_repo.sh 

#echo "#!/bin/bash" > cabinetvars_to_repo.sh
#chmod +x cabinetvars_to_repo.sh
#echo "echo \"============================================================\"" >> cabinetvars_to_repo.sh
#echo "echo \"data related to variables location: CABINETVARs\"" >> cabinetvars_to_repo.sh
#echo "  " >> cabinetvars_to_repo.sh
#echo "echo \"    \"" >> cabinetvars_to_repo.sh
#awk '{if ($8 == "cabinet") print $1}' cells_list2.txt > cabinetcells.txt
#awk '{printf("%s\t",$0) }' cabinetcells.txt > cabinetcells2.txt
#awk '{if ($3 == "cabinet") print($1,$2)}' variables_list2.txt > cabinetvars.txt
#cat cabinetvars.txt  |  awk -v something="$(head -n 1 cabinetcells2.txt)" 'BEGIN{NR=2};{print $0" "something}'> 2cabinetcells2.txt
#awk '{for(i=0;i<NF;i++){if(i>1)print ("curl -X PUT http://localhost:7777/data/testks/cellvariablesin/"$(i+1),"-d \047{\""$1"\":\""$2"\"}\047 -H \047Content-Type:\"application/json\"\047")}}' 2cabinetcells2.txt >> cabinetvars_to_repo.sh  


##copyshell scripts to another shell to run them at once
#echo "#!/bin/bash" > all_to_repo.sh
#chmod +x all_to_repo.sh
#echo "echo \"============================================================\"" >> all_to_repo.sh
#echo "echo \"Invoking insert data to REPOSITORY\"" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to cells(building description)\"" >> all_to_repo.sh
#echo "./cellsdata_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables\"" >> all_to_repo.sh
#echo "./vardata_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables location\"" >> all_to_repo.sh
#echo "./roomvar_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables location\"" >> all_to_repo.sh
#echo "./hallvar_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables location\"" >> all_to_repo.sh
#echo "./areavars_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables location\"" >> all_to_repo.sh
#echo "./doorvars_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables location\"" >> all_to_repo.sh
#echo "./deskvars_to_repo.sh" >> all_to_repo.sh
#echo "  " >> all_to_repo.sh
#echo "echo \" \"" >> all_to_repo.sh
#echo "echo \"Data related to variables location\"" >> all_to_repo.sh
#echo "./cabinetvars_to_repo.sh" >> all_to_repo.sh
