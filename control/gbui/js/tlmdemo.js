////////////////////////////////////////////////////////////////////////////////////////////////////
// File: tlmdemo.js
// Ver:  Sep 14 2012, 15:00
// Desc:
//  Main UI code to initialize the TLM UI and handle UI events and light levels.
//	Note that min/max set-points are currently not implemented in the UI. The min-setpoint is 
//	derived from the indoorTotalLightVal sensor and is recalculated when the external light level 
//	is lower than the internal light level after the user modifies the artificial lights. 
//	The max lighting set-point is recalculated from indoorTotalLightVal when the user modifies  
// 	the blinds when the external lighting level is high.
////////////////////////////////////////////////////////////////////////////////////////////////////

//TODO:
/*
For Comfort, allow for continuous range of -2 to +2
For Temp allow for continuous range of 16 to 27
Add toggle button to switch between temperature mode and comfort mode
Show a line of current temperature / comfort (depending on mode) to show the difference between current temp and desired temp

*/

var tempColours = new Array();

function Sensors() {
	//val result:String = "SEN 0 " + numPeople + " " + meeting + " " + statuspmv + " " + statusmeantemp + " " + hvac1 + " " + hvac2 + " " + outtemp + " " + lux1
	this.numpeople = 0;
	this.meeting = 0;
	this.statuspmv = 0.0;
	this.statusmeantemp = 20.0;
	this.hvac1 = "";
	this.hvac2 = "";
	this.outtemp = 0.0;
	this.lux1 = 0.0
}

function truncate(strval, val)
{
  var str = strval + "";
  if(str.length > val)
	str = str.substring(0, val);
  return str
}

Sensors.prototype.updateSensors = function() {
  var canvas = document.getElementById("sensorCanvas");
  var context = canvas.getContext("2d");

  //context.fillStyle = "#00ffff";
  context.clearRect(0, 0, 550, 380);
  //context.clearRect();
  //context.fillRect(0,0,550,380);
  
  context.fillStyle = "005800";
  context.font = "bold 24px Sans-Serif";
  context.fillText("Number of People: " + sensors.numpeople, 0, 30);
  var actString = "none";
  if(sensors.meeting == 1) actString = "Brainstorming"
  else if(sensors.meeting == 2) actString = "Presenting"
  
  context.fillText("Activity: " + actString, 0, 80);
  context.fillText("PMV actual: " + truncate(sensors.statuspmv,5), 0, 130);
  context.fillText("Temp actual: " + truncate(sensors.statusmeantemp,5), 0, 180);
  context.fillText("HVAC1 status: " + sensors.hvac1, 300, 30);
  context.fillText("HVAC2 status: " + sensors.hvac2, 300, 80);
  context.fillText("Outside temp: " + truncate(sensors.outtemp,5), 300, 130);
  context.fillText("Lux inside: " + truncate(sensors.lux1,5), 300, 180);
}

function Light(id, dimLevel, stepSize, maxLevel, lightLevel) {
	this.id = id;
	this.actuator_id = 0;
	this.dimVal = dimLevel;
	this.stepSize = stepSize;
	this.maxLevel = maxLevel;
	this.lightLevel = lightLevel;
	//console.log(this.id);
}


Light.prototype.updateSlider = function() {
}

function HVAC(comfortMode, stepSize, minLevel, maxLevel, curValue, desiredValue) {
	this.comfortMode = comfortMode;
	this.stepSize = stepSize;
	this.minLevel = minLevel;
	this.maxLevel = maxLevel;
	this.curTempValue = 16.0;
	this.curPMVValue = 0.0;
	this.desiredTempValue = 22.0;
	this.desiredPMVValue = 0.0;
	/*
	$( "#tempSlider" ).slider( "option", "max", maxLevel );
	$( "#tempSlider" ).slider( "option", "min", minLevel );
	$( "#tempSlider" ).slider( "option", "stepSize", stepSize);
	$( "#templider" ).slider( "value", desiredValue);
	*/
}

HVAC.prototype.updateCurValue = function() {
	var position = $("#scale").position();
	var height = $("#scale").height();//css("height");
	console.log(this.curTempValue);
	var newPos = this.curTempValue - 16.0;
	newPos = height - (height * newPos / 11.0); 
	$("#pointer").css("top", (position.top + newPos+2));
	//$( "#tempSlider" ).slider( "value", this.desiredTempValue);
	//var frac = Math.round(($("#tempSlider").slider("value") - 16)); //assuming we are in temp mode all of the time (otherwise check for comfort mode)
	//$("#tempSlider.ui-slider .ui-slider-range").css("background-color", tempColours[frac]);

	
}

HVAC.prototype.setMode = function(mode) {
	this.comfortMode = mode;
	if(mode) {
		this.stepSize = 0.2;
		this.minLevel = -2;
		this.maxLevel = 2;
		this.desiredTempValue = 20.0;
		this.desiredPMVValue = 20.0;
	}
	else {
		this.stepSize = 0.2;
		this.minLevel = 16;
		this.maxLevel = 27;
		this.desiredTempValue = 20.0;
		this.desiredPMVValue = 0.0;
	}
	$( "#tempSlider" ).slider( "option", "max", this.maxLevel );
	$( "#tempSlider" ).slider( "option", "min", this.minLevel );
	$( "#tempSlider" ).slider( "option", "stepSize", this.stepSize);
	$( "#tempSlider" ).slider( "value", this.desiredTempValue);
}

function logEvent(event) {
  console.log(event.type);
}
window.applicationCache.addEventListener('checking', logEvent, false);
window.applicationCache.addEventListener('noupdate', logEvent, false);
window.applicationCache.addEventListener('downloading', logEvent, false);
window.applicationCache.addEventListener('cached', logEvent, false);
window.applicationCache.addEventListener('updateready', logEvent, false);
window.applicationCache.addEventListener('obsolete', logEvent, false);
window.applicationCache.addEventListener('error', logEvent, false);


////////////////////////////////////////////////////////////////////////////////////////////////////
// DECLARE VARS, FUNCTIONS AND INITIALIZE 
// Note: some initializations are made within the slider widget declarations
////////////////////////////////////////////////////////////////////////////////////////////////////
//BEWARE - some initializations are made within the slider widget declarations//
var SERVER_ADDRESS = 'ws://192.168.30.37:8282/websocket/'; //wsURI location for setting system state values
//var SERVER_ADDRESS = 'ws://130.144.79.149:8181/consoleappsample'; //wsURI location for setting system state values
var ZONE_ID = " 16 "//used to identify a user or area for which the UI commands should apply on the server

var maxLight = 3000; //max possible lux limited by slider - also set as max in slider widget options
var minLight = 200; //min lux level in auto mode
var freezeMode = false; //used to toggle the background - emululate freezing settings
var SENSOR_POLLING_INTERVAL = 1000;


var skyBlue = "#009FE3";
var glareOrange = "#E94E1B";
var lightYellow = "F4ED00";
//var blockIncomingEvents = false; //whenever the blinds and lights are changed by the user, this flag will prevent listening to updates from the server until the change has been honoured
var blockingTimer = null; //track if the blocking timer is still running
var freezeToggle; // global declaration of toggle method so that other contexts can access it
var lastLightUpdate = -1000; //used to reduce the number of events sent to the server

tempColours[0] = "#7CCBF1";
tempColours[1] = "#DEF0E4";
tempColours[2] = "#EEF1B5";
tempColours[3] = "#FBF173";
tempColours[4] = "#F8EE52";
tempColours[5] = "#FFE838";
tempColours[6] = "#FFCC26";
tempColours[7] = "#FEBC22";
tempColours[8] = "#F7904F";
tempColours[9] = "#F78D1E";
tempColours[10] = "#F26222";
tempColours[11] = "#EE2A24";


var unblockEvents = function () {
	console.log("unblocking events");
	myDeviceManager.blockIncomingEvents = false;	
	lastLightUpdate = -1;
}

var blockEvents = function(timeout) {
	myDeviceManager.blockIncomingEvents = true;	
	console.log("blocking events " + blockingTimer);
	if(blockingTimer != null)
		clearTimeout(blockingTimer);
	blockingTimer = setTimeout(unblockEvents, timeout);
}

 
 $(document).ready(function() { //process the widgets when the document is loaded
    
	
	var docElm = document.documentElement;
	
	if (docElm.requestFullscreen) {
		docElm.requestFullscreen();
	}
	else if (docElm.mozRequestFullScreen) {
		docElm.mozRequestFullScreen();
	}
	else if (docElm.webkitRequestFullScreen) {
		docElm.webkitRequestFullScreen();
	}


	
	$( "#tabs" ).tabs();
	sensors = new Sensors();
	hvac = new HVAC(false, 0.2, 16, 27, 21, 20);
	
	$("#tabs").bind("tabsshow", function(event, ui) {
		if(ui.index == 2) 
			hvac.updateCurValue();
	});
		
	lights[0] = new Light("lightSlider1", 500, 10, 1000, 0);
	lights[1] = new Light("lightSlider2", 500, 10, 1000, 0);
	lights[2] = new Light("lightSlider3", 500, 10, 1000, 0);
	lights[3] = new Light("lightSlider4", 500, 10, 1000, 0);
	
	document.body.addEventListener('touchmove', function(e){ e.preventDefault(); }); //only applies to touch screens to disable scrolling within a web page
	//the lights and blinds controller is used to emulate control functions of the artificial lights and blinds motors
	myDeviceManager = new SocketSetterGetter(); //passes uri of controller for web socket messaging
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// BLINDS WIDGET CONTROL EVENT HANDLING
	// 
	////////////////////////////////////////////////////////////////////////////////////////////////////	
	var blindsControlEvent = function (id, type, val) {
		console.log("control event from " + id + "with command " + type + " and val " + val)
	
		if(freezeMode) 
			freezeToggle();		
		redrawSliders(); //update the new readings from the sensors
		//updateLeaf(); //update the energy efficiency feedback

		if(type == HEIGHT_CHANGED)
			myDeviceManager.setBlindsHeight(id, Math.round(blinds[id-1].blindsPos));
				
		if(type == ANGLE_CHANGED)
			myDeviceManager.setBlindsAngle(id, Math.round( blinds[id-1].blindsAngle));
		prevBlindsSelected = id-1;
		prevBlindsAngle = Math.round( blinds[id-1].blindsAngle);
		prevBlindsHeight = Math.round(blinds[id-1].blindsPos);
		
		blockEvents(15000);
	}
	

	////////////////////////////////////////////////////////////////////////////////////////////////////
	// UPDATE THE UI - invoked when the user changes the artificial lights
	////////////////////////////////////////////////////////////////////////////////////////////////////
	var lightControlEvent = function (id) {
		var idval = parseInt(id[11]) - 1;
		//console.log("#" + id +  ".ui-slider");
		//$( "#" + id +  ".ui-slider .ui-slider-range").css("background", "#FF00FF");
		if(lights[idval].dimVal != $( "#" + id ).slider( "value" ))	{
			lights[idval].dimVal = $( "#" +id ).slider( "value" );
			myDeviceManager.setLightLevel(idval, lights[idval].dimVal); 
			blockEvents(5000);
		}
	}

	var tempControlEvent = function ()	{
		if(hvac.desiredTempValue != $("#tempSlider").slider("value")) {
			hvac.desiredTempValue = $("#tempSlider").slider("value");
			myDeviceManager.setHVACLevel(hvac.desiredTempValue); 
			updateTempBackground();
			blockEvents(10000);
		}
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	// BLINDS WIDGET INITIALIZATION
	////////////////////////////////////////////////////////////////////////////////////////////////////		
	blindsCanvas1=document.getElementById("blindsCanvas1");
	blinds[0] = new BlindsWidget(1,16,100,blindsCanvas1, blindsCanvas1.getContext("2d"),0,50, blindsControlEvent);
	blindsCanvas2=document.getElementById("blindsCanvas2");
	blinds[1] = new BlindsWidget(2,16,100,blindsCanvas2, blindsCanvas2.getContext("2d"),0,50, blindsControlEvent);
	blindsCanvas3=document.getElementById("blindsCanvas3");
	blinds[2] = new BlindsWidget(3,16,100,blindsCanvas3, blindsCanvas3.getContext("2d"),0,50, blindsControlEvent);

	myDeviceManager.connect(SERVER_ADDRESS);
	
	for(i=0; i< blinds.length; i++)
	{
		var frame_pos = $("#tlm-frame").position();
		var tab_pos = $("#tabs").position();
		blinds[i].setTouchOffsets(frame_pos.left + tab_pos.left, frame_pos.top+tab_pos.top);
		blinds[i].updateBlinds();
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// FREEZE MODE HANDLERS
	////////////////////////////////////////////////////////////////////////////////////////////////////		
	$("#freeze").click(function() {
		freezeToggle();
	});

	freezeToggle = function () {
		elem=document.getElementById("tlm-frame"); //toggle the color of the background div containing the widgets
		if(freezeMode)
		{
			 myDeviceManager.setAutoMode(true);
			 elem.style.backgroundColor = '#FFFFFF';
					 $('#freeze').css('background-image', "url(images/freeze.png)"); //set css sprite

		}
		else {
			 myDeviceManager.setAutoMode(false);
			 elem.style.backgroundColor = '#DDDDDD';
			 $('#freeze').css('background-image', "url(images/unfreeze.png)"); //set css sprite
		}
		freezeMode = !freezeMode;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	// JQUERY SLIDER WIDGET INITIALIZATION
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
    $(function() {
		for(var i = 0; i < lights.length; i++)
		{	
			//(sliderElement, dimVal, stepSize, maxLevel, lightLevel)
			$( "#lightSlider" + (i+1) ).slider({ //#lightSlider refers to slider for controlling artificial lighting
				orientation: "vertical",
				range: "min",
				min: 0,
				max: lights[i].maxLevel, //note 1000 lux represents the total available from the artificial lighting
				value: lights[i].dimVal,
				step: lights[i].stepSize,
				//slide: lightControlEvent
			});
			$("#lightSlider" + (i+1)).slider( "value", lights[i].dimVal);
			$("#lightSlider" + (i+1)).slider({ stop: function( event, ui ) {lightControlEvent(this.id);}});
			//$("#lightSlider" + (i+1)).slider({ slide: function( event, ui ) {console.log("akdjalksdjoaiuslkn"); $("#lightSlider"+ (i+1) +".ui-slider" ).css("background", "#FFFFFF");}});
		}
    });    

	function updateTempBackground()	{
		var range = hvac.maxLevel - hvac.minLevel;
		/*
		var beginColour = 0x009FE3; //blie
		var endColour = 0xE94E1B; //orange
		R0 = (beginColour & 0xff0000) >> 16;
		G0 = (beginColour & 0x00ff00) >> 8;
		B0 = (beginColour & 0x0000ff) >> 0;
		R1 = (endColour & 0xff0000) >> 16;
		G1 = (endColour & 0x00ff00) >> 8;
		B1 = (endColour & 0x0000ff) >> 0;			
		var frac = ($("#tempSlider").slider("value") - 16.0)/11.0; //assuming we are in temp mode all of the time (otherwise check for comfort mode)
		R = (interpolate(R0, R1, frac) & 0x0000ff) >> 0;;
		G = (interpolate(G0, G1, frac) & 0x0000ff) >> 0;
		B = (interpolate(B0, B1, frac) & 0x0000ff) >> 0;
		theVal = ((( R << 8 ) |  G ) << 8 ) | B;
		*/
		var frac = Math.round(($("#tempSlider").slider("value") - 16)); //assuming we are in temp mode all of the time (otherwise check for comfort mode)
		//console.log(frac + "," + tempColours[frac]);
		//console.log(R + "," + G + "," + B);
		$("#tempSlider.ui-slider .ui-slider-range").css("background-color", tempColours[frac]);
	}

	$(function() {
        $( "#tempSlider" ).slider({ //#lightSlider refers to slider for controlling artificial lighting
            orientation: "vertical",
            range: "min",
            min: hvac.minLevel,
            max: hvac.maxLevel, //note 1000 lux represents the total available from the artificial lighting
            value: hvac.desiredTempValue,
			step: hvac.stepSize,
        });
        $("#tempSlider").slider( "value", hvac.desiredTempValue);
		//hvac.curValue = hvac.desiredValue;
		$("#tempSlider").slider({ stop: function( event, ui ) {tempControlEvent();}});
		//$("#tempSlider").slider({ stop: function( event, ui ) {updateTempBackground();}});
		updateTempBackground();
    });
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// REDRAW CODE FOR ENERGY CONSUMPTION FEEDBACK - 4 ENERGY STATES WITH 4 VISUALIZATIONS OF LEAF IMAGE
	// note that the calculation of energy states and feedback is not complete yet.
	////////////////////////////////////////////////////////////////////////////////////////////////////
	function updateLeaf() {
	/*
			var visStatus = (artificialLightInside <= 50) ? "visible" : "hidden";
			if($("#leaf").css("visibility") != visStatus)
				$("#leaf").css("visibility",visStatus);
	*/
	}


	////////////////////////////////////////////////////////////////////////////////////////////////////
	// CODE TO UPDATE AND REDRAW ALL SLIDERS
	////////////////////////////////////////////////////////////////////////////////////////////////////
	function redrawSliders() {

			for(i=0; i < lights.length; i++)
			{
				$( "#" + lights[i].id ).slider("value", lights[i].dimVal);
			}
			//updateLeaf();
	}
});

function interpolate(pBegin, pEnd, pFrac) {	 
	if (pBegin < pEnd) {
		return (1.0*(pEnd - pBegin) * pFrac) + pBegin;
	  } else {
		return (1.0*(pBegin - pEnd) * (1 - pFrac)) + pEnd;
	}
}
function componentToHex(c) {
	var hex = c.toString(16);
	return hex.length == 1 ? "0" + hex : hex;
}
function rgbToHex(r, g, b) {
	//console.log(r + "," + g + "," + b)
	return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}
		
