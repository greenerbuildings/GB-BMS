/*! 
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

#ifndef REST_REST_SERVER_H_INCLUDED
#define REST_REST_SERVER_H_INCLUDED

#include <string>
#include "json/json.h"
#include "dlib/server.h"
#include "cassandraclient/Cassclient.h"


namespace Rest {
  typedef std::map<std::string,std::string> StatMap;
  typedef std::string jsonString; 

  
  class Rest_Server;
  /* Container class for server statistics information */
  class Stats{
    public:
      Stats(Rest_Server *);
      void set_start_time(double);
      void update_running_time();
      void update_num_requests();
      void update_num_errors();
      void update_num_clients();
      void update_average_response_time(double);
      Json::Value get_statistics();      		
      
    private:
      double last_num_request;
      Rest_Server* owner;
      dlib::mutex lock;
      Json::Value data;
  };
  
  class Rest_Server : public dlib::server::http_1a_c
  {
    public:
      Rest_Server();
      ~Rest_Server();
      
      // start the server (none blocking funtion) starts a separate thread
      bool start_up();
      void is_running();
      void finish();
      int get_num_clients();
     
	  
      
      // virtual functions to be implemented on the child class. The non virtual 
      // counterparts, have the specific rest server behavior and make calls to 
      // their virtual counterparts (*_request(..)) where additional processing
      // can be achived. Return value should be a valid Json string.
      virtual jsonString on_get_request(const std::string uri ){
        return "{\"URI\":\""+uri+"\", \"ok\": True}";
      }
      
      virtual jsonString on_put_request(const std::string uri, Json::Value &value ){
        return value.toStyledString();
      }
      
      virtual jsonString on_post_request(const std::string uri, Json::Value &value ){
        return value.toStyledString();
      }
      
      virtual jsonString on_delete_request(const std::string uri ){
        return "{\"URI\":\""+uri+"\",\"removed\" : True, \"ok\": True}";
      }
      
      virtual jsonString echo_request(){
        return "{\"ok\":True}"; 
      }
            
      // As the virtual function before, but this time it does not return a json
      // string, instead, it should append to the Values already passed by the basic
      // server statistics. Conversion to a json string gets done later.
      virtual void stats_request(Json::Value& current_stats){
        current_stats["user_based_request"] = Json::Value("Appended by virtual class");
        return;
      };
      
      //  As the virtual function before, but this time it does not return a json
      // string, instead, it returns where the shutdown procedures implemented by
      // children classes succedded or not.
      virtual bool shutdown_request(Json::Value& value){return true;};
      
      dlib::thread_function *t;
      dlib::thread_function *stopper;
    
    protected:
      // server statistics container, is protected so that it can be easily used
      // by more complex stats containers in child classes 
      Stats server_stats;
      
    private:
      dlib::mutex stop;
      dlib::mutex num_clients_lock;
      long num_clients;
      

      const jsonString on_get(const std::string);
      const jsonString on_put(const std::string, Json::Value&);
      const jsonString on_post(const std::string, Json::Value&);
      const jsonString on_delete(const std::string);
      const jsonString shutdown(Json::Value& value = (Json::Value&) Json::Value::null);
      const jsonString echo();
      const jsonString stats();
      const std::string on_request (const incoming_things&, outgoing_things&);
  };
  
  // thread function to actually run the server
  void run(Rest_Server&);
}
#endif // REST_REST_SERVER_H_INCLUDED
