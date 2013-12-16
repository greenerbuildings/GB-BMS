/*! 
  PORT number changed to 7777 for the REST server, the testmodule and inventory module are
  no more running, just to reduce the processor load of this application.

  In version 9 of our REST server, the following things are added,
  automatic check of currentweek historical database, if not exist,
  then it creates one. This is done every time the rest server is started
  or a client tries to write on current weeks column family and was not available.
  The URL parser is modified to include range queries, GET from col=1 to col2.
  It is also possible to write from JSON input in its repective data type and read it successfully.

 
  In this version 8 of our REST server, JSON parser is modified
  so that it parses and responds properly to any standard JSON input

  in v7 the HTTP web server
  is extended to include an online test query which gives
  a JSON response up on query submit. And it opens port
  7777 for this purpose.
  In addition, port 7788 is open for invetorying purposes.
  That is needed for Facility managers to hardcode data
  in the cassandra database


  The contents of this file are in the public domain. 
  See LICENSE_FOR_EXAMPLE_PROGRAMS.txt

  This example illustrates the use of the HTTP extension 
  to the server object from the dlib C++ Library.
  It creates a server that always responds with a simple HTML form.
  To view the page this program displays you should 
  go to http://localhost:5000
*/

#include <iostream>
#include <sstream>
#include <time.h>
#include "rest/rest_server.h"
#include "dlib/ref.h"
#include "cassandraclient/Cassclient.h"
#include "url/url2.h"
#include <string>
#include "dlib/server.h"
//#include "webpage/repowebpage.h"


using namespace cassandra;

double get_clock_with_nanoseconds(){
	  timespec ts;
	  clock_gettime(CLOCK_REALTIME, &ts);
	  return ts.tv_sec + ( ts.tv_nsec * 1e-9 );
}


namespace Rest {
	  /*!  
	    Class: Stats Implementation
	    This class makes a simple statistics of our REST server
	    It is done according to the requirements of the 
	    REPOSITORY componenet of the Greener buildings	
	  */	
	  Stats::Stats(Rest_Server* srv): last_num_request(0),data(Json::Value(Json::objectValue))
	  {
		    owner = srv;
		    data["start_time"] = Json::Value(get_clock_with_nanoseconds());
		    data["running_time"] = Json::Value(0);
		    data["num_requests"] = Json::Value(0);
		    data["num_errors"] = Json::Value(0);
		    data["num_clients"] = Json::Value(0);
		    data["average_response_time"] = Json::Value(0.0);
	  }
  
	  void Stats::set_start_time(double st){
	    	    data["start_time"] = Json::Value(st); 
	  }
  
	  void Stats::update_running_time(){
		    lock.lock();
		    data["running_time"] = Json::Value(get_clock_with_nanoseconds() - data["start_time"].asDouble());
		    lock.unlock();
	  }
  
	  void Stats::update_num_requests(){
		    lock.lock();
		    data["num_requests"] = Json::Value(data["num_requests"].asInt() + 1);
		    lock.unlock();
	  }
	  
	  void Stats::update_num_errors(){
		    lock.lock();
		    data["num_errors"] = Json::Value(data["num_errors"].asInt() + 1 );
		    lock.unlock();
	  }
	  
	  void Stats::update_num_clients(){
		    lock.lock();
		    data["num_clients"] = Json::Value(owner->get_num_clients());
		    lock.unlock();
		    return;
	  }
	  
	  void Stats::update_average_response_time(double response_time){
		    lock.lock();
		    data["average_response_time"] =  Json::Value(((data["average_response_time"].asDouble() * last_num_request ) +  response_time)/data["num_requests"].asInt());
		    last_num_request = data["num_requests"].asDouble();
		    lock.unlock();
	  }
	  
	  Json::Value Stats::get_statistics(){
		    update_running_time();
		    update_num_clients();
		    return data;
	  }


	  //==============================================================
	 /*! 
	   Class: Rest Server Implementation
	 */   
	  Rest_Server::~Rest_Server(){
		    std::cout << "Calling Rest Server Destructor" << std::endl;
		    delete t;
		    delete stopper;
	  }
	  
	  Rest_Server::Rest_Server():server_stats(this),num_clients(0){
	  };
	  
	  void stop(Rest_Server& the_server){
		    std::cout << "Stopper thread reready" << std::endl;
		    the_server.is_running();
		    the_server.clear();
		    std::cout << "Stopper thread finished" << std::endl;
	  }
	  
	  void Rest_Server::is_running(){
		    stop.lock();
		    while (num_clients > 0)
		      	sleep(2);

		    stop.unlock();
	  }
	  
	  void Rest_Server::finish(){
	    	    stop.unlock();
	  }
  
	  int Rest_Server::get_num_clients(){
		    int tmp;
		    num_clients_lock.lock();
		    tmp = num_clients;
		    num_clients_lock.unlock();
		    return tmp;
	  }
  
	  void run(Rest_Server& the_server)
	  {
		    // Start the server.  start() blocks until the server is shutdown
		    // by a call to clear()
		    try {
		      	the_server.start();
			std::cout << "Run finished, bye bye" << std::endl;
		    }
		    catch (dlib::socket_error& e) {
		      	std::cout << "Socket error while starting server: " << e.what() << std::endl;
		    }
		    catch (std::exception& e) {
		      	std::cout << "Error while starting server: " << e.what() << std::endl;
		    }
	  }
	  
	  bool Rest_Server::start_up(){
		    t = new dlib::thread_function (run, dlib::ref(*this));
		    stopper = new dlib::thread_function (Rest::stop, dlib::ref(*this));
		    if (t == NULL || stopper == NULL )
		      	return false;
		    
		    stop.lock();  
		    return true;
	  }
	  
	  /*! 
	   Handling GET request.
	   It is used for four functionalities:
	   1) for echo probe (to check is it is alive)
	   2) for statistics snapshot
	   3) for graceful shutdown request
	   4) for other REST GET commands
	  */
				      	
				    
	  const jsonString Rest_Server::on_get(const std::string uri){
		    std::size_t pos;
		    pos = uri.find_last_of("/");
		    if ((uri.substr(pos - 5, pos) == "/echo/") || (uri.substr(pos, pos + 4) == "/echo"))
		      	return echo();
		    else if ((uri.substr(pos -5, pos) == "/stat/") || (uri.substr(pos, pos + 4) == "/stat"))
		      	return stats();
		    else if ((uri.substr(pos -9, pos) == "/shutdown/") || (uri.substr(pos, pos + 8) == "/shutdown"))
		      	return shutdown();
		    else
		      	return on_get_request(uri);
	  }

	  /*! 
	   Handling PUT request.
	   It is used to PUT data or search queries 
	  */
	  const jsonString Rest_Server::on_put(const std::string uri, Json::Value& value){
	    	return on_put_request(uri,value);
	  }

	  /*! 
	   Handling POST request.
	   It is used to update values
	  */
	  const jsonString Rest_Server::on_post(const std::string uri, Json::Value& value){
		std::size_t pos;
		pos = uri.find_last_of("/");
	    	if (uri.substr(pos-9,pos) == "/shutdown/")
	      		return shutdown(value);
	    
	    	return on_post_request(uri,value);
	  }
	  

	  /*! 
	   Handling DELETE request.
	   It is used to delete values.
	  */
	  const jsonString Rest_Server::on_delete(const std::string uri){
	    	return on_delete_request(uri);
	  }
  
	  /*! 
	   A shutdown function, which is called via GET request
	  */
	  const jsonString Rest_Server::shutdown(Json::Value& value ){
		    try{
			      std::string response;
			      if (shutdown_request(value))
				response = "{\"shutting down\":True, \"ok\":True}";
			      else
				response = "{\"shutting down\":True, \"ok\":False}";
			      
			      std::cout << "Shutting down, bye bye" << std::endl;
			      finish();
			      return response;
		    	}
		    catch (std::exception& e){
			      return "{\"shutting down\":True, \"ok\":False}";
			      std::cout << e.what() << std::endl;
	    		}
		return "{\"error\":\"unknown shutdown problem\"}";
	  }


	  /*! 
	   A function to probe the casssandra database
	  */
	  const jsonString Rest_Server::echo(){
	    	Cassclient cassEcho("localhost",9160);
	    	return cassEcho.echoCassandra();	
	  }
  
	  /*! 
	   A function to get the statistics
	  */
	  const jsonString Rest_Server::stats(){
	    	Json::Value srv_stats = server_stats.get_statistics();
	    	stats_request(srv_stats);
	    	Cassclient cassStat("localhost",9160);
	    	return "{\"Statistics\":"+ srv_stats.toStyledString()+ ", \"Snapshot\":"+cassStat.cassandra_snapshot() +"}";
	  }
	  



	 /*! 
	  This function handles any incookming request.
	  It could be GET, PUT, POST, DELETE, or invalid.
	 */
	  const std::string Rest_Server::on_request (const incoming_things& incoming,
		                                     outgoing_things& outgoing) {
	    try{	    
		      //update number of connected clients
		      num_clients_lock.lock();
		      ++num_clients;
		      num_clients_lock.unlock();
		      double start_clock = get_clock_with_nanoseconds();
		      server_stats.update_num_requests();
		      bool has_no_data = false;
		      bool parsingSuccessful = false;
		      if ( incoming.request_type ==  "GET" || incoming.request_type ==  "DELETE" )
				// methods delete and get only need the uri to operate, therefore, we avoid 
				// running the Json parcing
				has_no_data = true;
		      
		      Json::Value root;
		      Json::Reader reader;
		      if ( !has_no_data ){
				parsingSuccessful = reader.parse( incoming.body, root );
				if (incoming.content_type.find("application/json") == std::string::npos){
					outgoing.http_return=416;
					outgoing.http_return_status="We only accept JSON content type for POST, PUT\n";
					server_stats.update_num_errors();
					return outgoing.http_return_status;
				}
		      }
		
		      if ( !parsingSuccessful && !has_no_data) {
			    	outgoing.http_return=501;
			    	outgoing.http_return_status= "Can't decode message, error:" + reader.getFormatedErrorMessages(); 
			    	std::cout << "Message: \"" <<  incoming.body << "\"" << std::endl;
			    	std::cout   << reader.getFormatedErrorMessages() << std::endl;
			    	server_stats.update_num_errors();
			    	return outgoing.http_return_status;
		      }
		      
		      // possible REST responses
		      std::string rest_response;
		      if ( incoming.request_type ==  "POST" )  
			  	rest_response = on_post(incoming.path,root);
		      else if ( incoming.request_type ==  "GET" )
			  	rest_response = on_get(incoming.path);
		      else if ( incoming.request_type ==  "PUT" )
			  	rest_response = on_put(incoming.path,root);
		      else if ( incoming.request_type ==  "DELETE")
			  	rest_response = on_delete(incoming.path);

		      // Write out response 
		      std::ostringstream sout;
		      sout << rest_response << std::endl;
		      
		      // Set headers
		      outgoing.headers["Content-type"] = "application/json";      
		      outgoing.headers["Access-Control-Allow-Origin"] = "*";      
		      double end_clock = get_clock_with_nanoseconds();
		      server_stats.update_average_response_time(end_clock - start_clock);
		      num_clients_lock.lock();
		      --num_clients;
		      num_clients_lock.unlock();
		      return sout.str();
	    }
	    catch (std::exception& e)
	    	{
	      		num_clients_lock.lock();
	      		--num_clients;
	      		num_clients_lock.unlock();
	      		server_stats.update_num_errors();
	      		return e.what();
	    	}
	  }
} // end of namespace Rest

// test class for wrrapers
class test_Rest_Server : public Rest::Rest_Server {
	/*! 
	  This class handles the actions needed on GET request
	*/
	std::string on_get_request(const std::string uri ){
		std::string databaseIP = "localhost";
		int databasePort= 9160;
		Cassclient getcaClient(databaseIP,databasePort);
		url2 geturi;
		geturi.parse_url(uri);	
		if (geturi.colname().empty()) {
			if (geturi.rowk().empty()) {
				return "{\"error\": invalid GET request\"\n, \"submited uri:\""+uri+"\"\n,\"suggestation\":\"GET -X IPaddress:port/data/KEYSPACE/COLUMNFAMILY/ROWKEY/\"} ";
			}
			else {// read entire row or range oc columns in a row
				if (geturi.startcolumn().empty()){//read entire row
					// first check it has data type in the static CFs (variables/datatype)
					std::size_t foundweek1;
					std::string tempcf1 = geturi.colfamily();
					foundweek1=tempcf1.find("week");
	  		        	if (foundweek1!=std::string::npos){//if cf has the word "week"
				 		std::string tempdtype1= getcaClient.readaColumn(geturi.keysp(),"variables",geturi.rowk(),"datatype");//get its data type from variables
				 		url2 dtype1;
				 		dtype1.parse_json(tempdtype1);
						return getcaClient.readaBinaryRow(geturi.keysp(),geturi.colfamily(),geturi.rowk(),dtype1.jsoncolvalue());			
					}
					else // consider every column in the row as string							
						return getcaClient.readaRow(geturi.keysp(),geturi.colfamily(),geturi.rowk() );			
				}
				else{// read a range of columns in a row
					if(geturi.endcolumn().empty()){// check if it is lastcolumn query
						if(geturi.lastcolumns().empty())
							return "{\"error\":\"GET uri missing endcolumn or lastcount\"}";
						else{
							std::stringstream ss(geturi.lastcolumns()); // change string to int  
  							int lascols;  
  							if( (ss >> lascols).fail() )  {
							     return "{\"error\":\"GET uri lastcount problem\"}";
							  }							

							// first check it has data type in the static CFs (variables/datatype)
							std::size_t foundweek2x;
							std::string tempcf2x = geturi.colfamily();
							foundweek2x=tempcf2x.find("week");
			  		        	if (foundweek2x!=std::string::npos){// if cf has the word "week"
						 		std::string tempdtype2x= getcaClient.readaColumn(geturi.keysp(),"variables",geturi.rowk(),"datatype");//get its data type from variables
						 		url2 dtype2x;
						 		dtype2x.parse_json(tempdtype2x);
								return getcaClient.readLastXinaBinaryRow(geturi.keysp(),geturi.colfamily(),geturi.rowk(),geturi.startcolumn(),lascols,dtype2x.jsoncolvalue());			
							}
							else // consider every column in the row as string							
								return getcaClient.readLastXinaRow(geturi.keysp(),geturi.colfamily(),geturi.rowk(),geturi.startcolumn(),lascols);			

						}
					}
					else{
						// first check it has data type in the static CFs (variables/datatype)
						std::size_t foundweek2;
						std::string tempcf2 = geturi.colfamily();
						foundweek2=tempcf2.find("week");
		  		        	if (foundweek2!=std::string::npos){//if cf has the word "week"
					 		std::string tempdtype2= getcaClient.readaColumn(geturi.keysp(),"variables",geturi.rowk(),"datatype");// get its data type from variables
					 		url2 dtype2;
					 		dtype2.parse_json(tempdtype2);
							return getcaClient.readColumnRangeInaBinaryRow(geturi.keysp(),geturi.colfamily(),geturi.rowk(),geturi.startcolumn(),geturi.endcolumn(),dtype2.jsoncolvalue());			
						}
						else // consider every column in the row as string							
							return getcaClient.readColumnRangeInaRow(geturi.keysp(),geturi.colfamily(),geturi.rowk(),geturi.startcolumn(),geturi.endcolumn());			
					}
				}
			}
		}
		else {// read one column	
		        // first check it has data type in the static CFs (variables/datatype)
			std::size_t foundweek;
			std::string tempcf = geturi.colfamily();
		       foundweek=tempcf.find("week");
  		    if (foundweek!=std::string::npos){// if cf has the word "week"
			 std::string tempdtype= getcaClient.readaColumn(geturi.keysp(),"variables",geturi.rowk(),"datatype");// get its data type from variables
			 url2 dtype;
			 dtype.parse_json(tempdtype);			
			 return getcaClient.readaBinaryColumn(geturi.keysp(),geturi.colfamily(),geturi.rowk(),geturi.colname(),dtype.jsoncolvalue());				
			}
		     else // treat it as static CFs which all are defined as string			
			return getcaClient.readaColumn(geturi.keysp(),geturi.colfamily(),geturi.rowk(),geturi.colname() );
		}

	}

	/*! 
	  This class handles the actions needed on PUT request
	*/
	std::string on_put_request(const std::string uri, Json::Value& value ){

		Cassclient putcaClient("127.0.0.1",9160);
		url2 puturi;
		puturi.parse_url(uri);
		puturi.parse_json(value.toStyledString());
		if (puturi.jsonparsemesage() == "{\"OK\"}"){
			if (puturi.data() == "/data/"){	
				if (puturi.colname().empty()) {
					if (puturi.rowk().empty()) {// no column name no row key
						return "{\"error\":\"invalid PUT URL (without row key and column name)\"}";
					}
					else {	// it is valid
						//if ((puturi.colfamily()=="variables")&&(puturi.jsoncolname()=="updatedvalue")){
						//	std::string histrespo = putcaClient.writeaColumnFromJSON(puturi.keysp(), "thisweek", puturi.rowk(),value.toStyledString());//write it to historical
						//	return putcaClient.writeaColumn(puturi.keysp(), puturi.colfamily(), puturi.rowk(),puturi.jsoncolname(),puturi.jsoncolvalue()); //save everything as string
						//}
						return putcaClient.writeaColumnFromJSON(puturi.keysp(), puturi.colfamily(), puturi.rowk(),value.toStyledString()); //write considering data type			
						// return putcaClient.writeaColumn(puturi.keysp(), puturi.colfamily(), puturi.rowk(),puturi.jsoncolname(),puturi.jsoncolvalue()); //mycname1, mycvalue1);
					}
			       	}
		   		else {
					return "{\"error\":\"invalid PUT URL\"}";
			
				}
		 	}// end of if (puturi.data==/data/)
		 	else if (puturi.data().empty()){
				return "{\"error\":\"invalid URL\"}";
			} 
	
		 	else {// if it is search type
				return "{\"error\":\"invalid PUT URL (without /data/ )\"}";
		 	}
		}
		else{
	 		return puturi.jsonparsemesage();
   		}
	 
	}


	/*! 
	  This class handles the actions needed on POST request.
	  It is main purpose is to POST CQL(Cassandra Query language) commands
	*/
	std::string on_post_request(const std::string uri, Json::Value& value ){
	Cassclient postcaClient("127.0.0.1",9160);
		url2 posturi;
		posturi.parse_url(uri);
		posturi.parse_json(value.toStyledString());
		if (posturi.jsonparsemesage() == "{\"OK\"}"){
			if (posturi.data() == "/data/"){	
				return "{\"error\":\"POST URL ( without /search/)\"}";				
		 	}// end of if (posturi.data==/data/)
		 	else if (posturi.data().empty()){
				return "{\"error\":\"invalid URL\"}";
			} 
	
		 	else {// if it is search type
				if (posturi.keysp().empty()) {
					return "{\"error\":\"post (/search/) URL with out keyspace\"}";				
				}
				else {				
					return postcaClient.excql(posturi.keysp(),posturi.jsoncolvalue()); 								
				}	
		 	}
		}
		else{
			return posturi.jsonparsemesage();
		}	 
	}
      

	/*! 
	  This class handles the actions needed on DELETE request.
	  It is main purpose is to execute CQL(Cassandra Query language)
	  commands for DELETE
	*/
	std::string on_delete_request(const std::string uri ){
		Cassclient deletecaClient("127.0.0.1",9160);
		url2 deleteuri;
		deleteuri.parse_url(uri);
		if (deleteuri.data() == "/data/"){	
			if (deleteuri.colname().empty()) {
				if (deleteuri.rowk().empty()) {// will be modified to delete Column Family
					return "{\"error\":\"can not delete column family\"}";				
				}
				else {// delete entire row
					std::ostringstream cqlstring;
					cqlstring.str("");
					cqlstring.clear();
					cqlstring << "DELETE FROM"<< std::endl;
					cqlstring <<	deleteuri.colfamily() << std::endl;
					cqlstring << "WHERE KEY = '"<< deleteuri.rowk()<<"'" << std::endl;		
					return deletecaClient.exdeletecql(deleteuri.keysp(),cqlstring.str()); 				
				}
		 }
	   else {// delete a given column
				std::ostringstream cqlstring2;
				cqlstring2.str("");
				cqlstring2.clear();
				cqlstring2 << "DELETE " <<std::endl;
				cqlstring2 << deleteuri.colname() << std::endl;
				cqlstring2 << "FROM "<< std::endl;
				cqlstring2 <<	deleteuri.colfamily() << std::endl;
				cqlstring2 << " where KEY ='"<< deleteuri.rowk()<<"'" << std::endl;		
				return deletecaClient.exdeletecql(deleteuri.keysp(),cqlstring2.str()); 					
		 }
	 }// end of if (deleteuri.data==/data/)
	 else if (deleteuri.data().empty()){
		return "{\"error\":\"invalid Delete command\"}";
		
	 } 
	
	 else {
		return "{\"error\":\"invalid URL\"}";
					
	 }

	return "{\"error\":\"unknown\"}";
	 

	}  
    
};




int main()
{
	 
  try
  {
 
    Cassclient thisweekcfClient("127.0.0.1",9160);  
    thisweekcfClient.createthisweekcf("gbrepository");
    std::cout << "\nThis week´s column family is: "<<thisweekcfClient.whatisthisweekcf()<<std::endl; 

    // create an instance of our web server
    test_Rest_Server our_Rest_Server;
    	

    // make the REST listen on port 5000
    our_Rest_Server.set_listening_port(7777);

    // create a thread that will start the server.   The ref() here allows us to pass 
    // our_  Rest_Server into the threaded function by reference.
    our_Rest_Server.start_up();
    std::cout << "REST sever waiting for run to exit" << std::endl;
    std::cout << "\n*************************************************************************" << std::endl;
    std::cout << "*              REPOSITORYś REST Module has  been started.               *"<< std::endl;
    std::cout << "*         It can be accessed on http://domonica.ele.tue.nl:7777         *" << std::endl;
    std::cout << "*************************************************************************\n" << std::endl;
    // this will cause the server to shut down 
    our_Rest_Server.t->wait();
    std::cout << "t is finished, bye bye" << std::endl;   	

           
  }
  catch (std::exception& e)
  {
    std::cout << "exception in the rest_server" <<e.what() << std::endl;
  }
}
