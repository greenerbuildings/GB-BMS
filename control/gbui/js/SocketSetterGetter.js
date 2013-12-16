////////////////////////////////////////////////////////////
// file: SOCKETSETTERGETTER.js 
// ver: Sep 14 2012, 13:30
////////////////////////////////////////////////////////////
var lights = new Array();
var blinds = new Array();
var hvac;
var sensors;
var USER_ID = " 16 "; //user id is important when sending commands: ensure there are spaces for the delimiter
var DEBUG_MODE = true;
var comfortMode = false; //false = temperature mode; true = PMV comfort mode
var CATEGORY_CMD = "CMD";
var CATEGORY_REQ = "GET";

/* checking for errors:
 - when a control update is made, save the actuator state before events become blocked
 - when event becomes unblocked, check if updated the state is the same.
 - if not, then we know that something has gone wrong.
 
 */

var	prevBlindsSelected = -1;
var prevBlindsAngle = -1;
var prevBlindsHeight = -1;

/*
var  CATEGORY_SET = "SET";
var  LIGHT_DIM_CTRL = "03";
var  LIGHT_SWITCH_ON = "06";
var  LIGHT_SWITCH_OFF = "07";
var  BLINDS_ROTATE_LEVEL_CTRL = "28";
var  BLINDS_HEIGHT_CTRL = "33";
var  ILDC_CTRL_START = "34";
var  ILDC_CTRL_STOP = "35";
*/

var CMD_TYPE_ALL = "00"; 
var CMD_TYPE_DIM1 = "01";
var CMD_TYPE_DIM2 = "02";
var CMD_TYPE_DIM3 = "03";
var CMD_TYPE_DIM4 = "04";
var CMD_TYPE_BH1 = "05";
var CMD_TYPE_BH2 = "06";
var CMD_TYPE_BH3 = "07";
var CMD_TYPE_BH4 = "08";
var CMD_TYPE_BA1 = "09";
var CMD_TYPE_BA1 = "10";
var CMD_TYPE_BA1 = "11";
var CMD_TYPE_BA1 = "12";
var CMD_TYPE_HVAC_TEMP = "13";
var CMD_TYPE_HVAC_PMV = "14";
var LIGHT_DIM_CTRL = "15";
var BLINDS_ROTATE_LEVEL_CTRL = "28";
var BLINDS_HEIGHT_CTRL = "33";
var BLINDS_STATUS_CTRL = "36"; //expected both height and angle in that order

var myWebSocket;
var freezeMode = false; //used to toggle the background - emululate freezing settings

wsURI = ""; //may include port number
openStatus = false;
var lightSensorCallback; //callback function when light sensor heartbeat is triggered
var pollInterval; //polling interval for light sensor heartbeat
var glareDetected; //flag to indicate if glare sensor is triggered
//var blockIncomingEvents;
var openStatus;	
var myDeviceManager; //instance of SocketSetterGetter for use in main program
var oldGlare = 5000; //used to check if the glare value has changed
var retryCount = 0;
var RETRY_NOTIFY_MAX = 2;
var MAX_CUTOFF = 70;
var lastTimeReceived = -1012030;

function SocketSetterGetter()
{

	this.blockIncomingEvents = false;
	openStatus = false;	
	this.pollingID = null;
}


function reconnectToServer(uri)
{
	myDeviceManager.connect(uri);
}

function myTimer()
{
	if(!myDeviceManager.blockIncomingEvents) 
		myDeviceManager.getAllVars();
}

 $(document).ready(function(){ //process the widgets when the document is loaded

////////////////SOCKETS/////////////////////////////////////////////
SocketSetterGetter.prototype.connect = function(uri) {
	wsURI = uri;
	
	if (!window.WebSocket) {
		window.WebSocket = window.MozWebSocket;
	}
	
	console.log("connecting to " + wsURI);
	
	 if (window.WebSocket) {
		myWebSocket = new WebSocket(wsURI);
	 }
	
	myWebSocket.onopen = function () {
		console.log(".. connection open");
		$("#connectStatus").css("visibility","hidden");
		retryCount = 0;
		openStatus = true;
		myDeviceManager.pollingID = setInterval(function(){myTimer()},2000);
		myDeviceManager.sendSensorRequest();
	};

	myWebSocket.onclose = function () {
		console.log('.. connection to web socket closed, re-establishing connection......');
		openStatus = false;
		retryCount = retryCount + 1;
		$("#connectStatus").css("visibility","visible");
		if(myDeviceManager.pollingID != null)
		{
			clearInterval(myDeviceManager.pollingID);
			myDeviceManager.pollingID = null;
		}
		setTimeout(function(){reconnectToServer(wsURI)}, 5000);
	};
	
	myWebSocket.onmessage = function (evt) {
		//var timeNow = new Date().getTime();
		//if(timeNow - timeLastReceivedEvent > 60000)
		//location.reload()
		//timeLastReceivedEvent = timeNow;
		
		if(myDeviceManager.blockIncomingEvents) return; //don't handle incoming messages from server until UI command is processsed
		
		var messageString = evt.data;
		
		//if(DEBUG_MODE) console.log("raw message = " + messageString);
		
		var messageArray = messageString.split(" ");
		var cmd = messageArray[0];
		var cmd_type = parseInt(messageArray[1]);
		//TODO: process updates relating to single actuators
		if(cmd_type == CMD_TYPE_ALL && cmd == "CMD") //expect dump of all actuator values: dim1 dim2 dim3 dim4 b1h b2h b3h b1a b2a b3a ht1 hp1 htd1 hpd1
		{
			console.log("update all: " + messageString);
			for(i = 0; i < lights.length; i ++)
			{	
				if(lights[i].dimVal != parseInt(messageArray[i+2]))
				{
					lights[i].dimVal = parseInt(messageArray[i+2]);
					if(DEBUG_MODE) console.log("new dim value for " + "#lightSlider" + (i+1) + " is " + lights[i].dimVal);
					$("#lightSlider" + (i+1)).slider( "value", lights[i].dimVal);
				}
			}
			for(i=0; i < 3; i++)
			{
				/*
				console.log(prevBlindsSelected + "," + )	
				if(prevBlindsSelected != i && prevBlindsAngle != parseInt(messageArray[i+9]) && prevBlindsHeight != parseInt(messageArray[i+6]))
				{
					alert("No reaction from the blinds system! Please contact Oliver for assistance.");
				}
				*/
				//if(Math.abs(blinds[i].blindsPos - (parseInt(messageArray[i+6]) * 100 / 255)) > 3)
				if(Math.abs(blinds[i].blindsPos - (parseInt(messageArray[i+6]))) > 3)
				{

					if(DEBUG_MODE) console.log("new value for height: " + parseInt(messageArray[i+6]));
					//blinds[i].blindsPos = parseInt(messageArray[i+6]) * 100 / 255;
					blinds[i].blindsPos = parseInt(messageArray[i+6]);
					blinds[i].updateBlinds();
				}

				if((/*90 - */blinds[i].blindsAngle) != parseInt(messageArray[i+9]))
				{
					var blindsAngle = parseInt(messageArray[i+9]);
					blinds[i].blindsAngle = /*90 - */messageArray[i+9];
					blinds[i].updateBlinds();
					if(DEBUG_MODE) console.log("new value for angle: " + blinds[i].blindsAngle + ":" + blindsAngle);
				}
			}
			if(hvac.desiredTempValue != parseFloat(messageArray[12]))
			{
				hvac.desiredTempValue = parseFloat(messageArray[12]) ;
				//console.log(hvac.curValue - 15);
				hvac.updateCurValue();
				//$( "#tempSlider" ).slider( "value", hvac.desiredValue);
			}
			if(hvac.curTempValue != parseFloat(messageArray[14]))
			{
				hvac.curTempValue = parseFloat(messageArray[14]);
				hvac.updateCurValue();
			}
			
		}
		else if(cmd_type == CMD_TYPE_ALL && cmd == "SEN")
		{
			//updateCanvas();
			//println("siname = " + siname + " , varname = " + varname + " , varstate = " + mvar)
            //val result:String = "SEN 0 " + numPeople + " " + meeting + " " + statuspmv + " " + statusmeantemp + " " + hvac1 + " " + hvac2 + " " + outtemp + " " + lux1
			sensors.numpeople = parseInt(messageArray[2]);
			sensors.meeting = parseInt(messageArray[3]);
			sensors.statuspmv = Math.round(parseFloat(messageArray[4]) * 10.0) *0.1;
			sensors.statusmeantemp = Math.round(parseFloat(messageArray[5]) * 10.0) * 0.1;
			sensors.hvac1 = messageArray[6];
			sensors.hvac2 = messageArray[7];
			sensors.outtemp = Math.round(messageArray[8] * 10.0) * 0.1;
			sensors.lux1 = Math.round(messageArray[9] * 10.0) * 0.1;
            sensors.updateSensors();
			if(DEBUG_MODE) console.log("received sensor value update");
		}



	};
}
});

SocketSetterGetter.prototype.setBlinds = function(blindid, height, angle)
{
	this.setBlindsHeight(blindid,height);
	this.setBlindsAngle(blindid, angle);
}

SocketSetterGetter.prototype.setBlindsHeight = function(blindid, height)
{
	//height should be a value between 0 and 255
	//this.sendMessage(blindid, BLINDS_HEIGHT_CTRL, Math.round(height * 255 / 100));
	this.sendMessage(blindid, BLINDS_HEIGHT_CTRL, Math.round(height));
}

SocketSetterGetter.prototype.setBlindsAngle = function(blindid, angle)
{
	//angle between 0 and 180 degrees (clock-wise)?
	this.sendMessage(blindid, BLINDS_ROTATE_LEVEL_CTRL, Math.round(/*90 - */angle));
}

SocketSetterGetter.prototype.getLightLevel = function(id)
{
	this.sendRequest(id, BLINDS_STATUS_CTRL); 
}

SocketSetterGetter.prototype.setLightLevel = function(lightid, level)
{
	var adjustedLevel = (level > 8)?level:0;
	
	this.sendMessage((lightid+1), LIGHT_DIM_CTRL, adjustedLevel);
}

SocketSetterGetter.prototype.getLightLevel = function(id)
{
		this.sendRequest(id, LIGHT_DIM_CTRL); //just work in temperature mode for now
}


SocketSetterGetter.prototype.setHVACLevel = function(val)
{
	if(hvac.comfortMode)
		this.sendMessage(0, CMD_TYPE_HVAC_PMV, val);
	else
		this.sendMessage(0, CMD_TYPE_HVAC_TEMP, val);
}

SocketSetterGetter.prototype.getHVACLevel = function()
{
	if(hvac.comfortMode)
		this.sendRequest(0, CMD_TYPE_HVAC_PMV); //just work in temperature mode for now
	else
		this.sendRequest(0, CMD_TYPE_HVAC_TEMP); //just work in temperature mode for now
}

SocketSetterGetter.prototype.getAllVars = function()
{
	this.sendRequest(0, CMD_TYPE_ALL); //just work in temperature mode for now
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// PLACEHOLDER METHOD FOR DYNALITE CONTROL METHODS
////////////////////////////////////////////////////////////////////////////////////////////////////

SocketSetterGetter.prototype.sendRequest = function (id, code)
{	
	
	if (myWebSocket.readyState == 1) {	
			//console.log("sending request " + code + " for id " + id);
			myWebSocket.send(CATEGORY_REQ + " " + code + " " + id);	
	}
	else
		console.log("cannot send requst with code " + code + " for " + id);
}

SocketSetterGetter.prototype.sendSensorRequest = function ()
{	
	if (myWebSocket.readyState == 1) {	
			//console.log("sending request " + code + " for id " + id);
			myWebSocket.send("GETS" + " " + "0" + " " + "0");	
	}
	else
		console.log("cannot send requst with code " + code + " for " + id);
}


SocketSetterGetter.prototype.sendMessage = function (id, code, value)
{	
	
	if (myWebSocket.readyState == 1) {	
			if(DEBUG_MODE) console.log("sending command " + code + " to " + id + " with value " + value );
			myWebSocket.send(CATEGORY_CMD + " " + code + " " + id + " " + value);	
	}
	else
		if(DEBUG_MODE) console.log("cannot send command with code " + code + " to " + id + " with value " + value);
}