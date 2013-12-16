===
RME README
===

RME has two separate parts: (1) RME Server; (2) RME Web Interface. 
The RME Server is the actual RME implementation. RME Web Interface is not necessary for the GB cycle to work! The cycle (event from RabbitMQ -> process -> send to CFD/Planner) is handled by the server, so it's possible to start only the server to obtain the functionality. The RME Web Interface provides the ability to enter/remove rules, check the current status of the environment, etc. in a human-readable way.

1) RME Server

- Navigate to 'rme' directory
- Type: 
java -jar rme-<version>.jar -Xmx1024M -Xms1024M

(memory requirements are important, due to solver library memory constraints)


2) RME Web Interface

To start it Play Framework is required.
- Download Play Framework from here: http://www.playframework.org/download
I use 2.0.3, but 2.0.4 should work just as fine as well.
Installation instructions can be found here: http://www.playframework.org/documentation/2.0.4/Installing

- Make sure that the RME server is already running
- Navigate to 'rmeweb' directory
- Type "play run"
- Web Interface should now be available at address 'localhost:9000'



