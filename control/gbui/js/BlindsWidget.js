////////////////////////////////////////////////////////////
// file: BLindsWidget.js 
// ver: Sep 13 2012, 17:40
////////////////////////////////////////////////////////////



//pre-load some images for the widget
//var handleImageLarge = new Image();
var handleImageSmall = new Image();
var sunImage = new Image();
//handleImageLarge.src = "images/height-handle.png";
handleImageSmall.src = "images/angle-handle.png";
sunImage.src = "images/sunImage.png";
var NO_CHANGE = 0; 
var ANGLE_CHANGED = 1;
var HEIGHT_CHANGED = 2;

function BlindsWidget(instanceName, numBlinds, blindsPos, blindsCanvas, blindsContext, blindsAngle, slatWidth, controlCallback) {
	this.instanceName = instanceName;
	this.numBlinds = numBlinds; //total number of slats drawn on blinds
	this.blindsPos = blindsPos; //percentage of blinds height 100% = fully closed
	this.blindsCanvas = blindsCanvas; //html5 canvas used to draw blinds
	this.blindsContext = blindsContext; //drawing context used to draw blinds
	this.blindsAngle = blindsAngle; //angle of slates in degrees
	this.slatWidth = slatWidth; //slat width in pixels
	this.blindsPosY = -1; //height of blinds in pixels
	this.rotateMode = false; //used for previous version of widget
	this.heightMode = false; //used for previous version of widget
	this.dragStartX = -1; //for detecting drag with mouse/touch screen
	this.dragStartY = -1; //for detecting drag with mouse/touch screen
	this.blindsControlCallback = controlCallback; //used to invoke and capture control events via a timer
	this.handleWidth = 50; //width of handle
	this.handleHeight = 30; //height of handle
	this.arcOffset = 20; //offset for angle control from blinds slats
	this.arcRadius = 90; //radius of the arc for controlling blinds angle
	this.glareDetected = false; //flag to indicate if glare angle should be shown
	this.glareStartAngle = -20; //start of glare angle indicator
	this.glareEndAngle = 20; //end of glare angle indicator
	this.rotHandlePos = [0,0];
	this.updateFlag = false;
	this.updateVal = NO_CHANGE;
	this.imagesLoaded = false;
	this.touchOffsetX = 0;
	this.touchOffsetY = 0;
	
	this.handleImageLarge = new Image();
	this.handleImageLarge.src = "images/height-handle.png";
	this.blindsCanvas.addEventListener('mousemove', $.proxy( this.ev_mousemove,this), false);    
	this.blindsCanvas.addEventListener('mousedown', $.proxy( this.ev_mousedown,this), false);    
	this.blindsCanvas.addEventListener('mouseup', $.proxy( this.ev_mouseup,this), false);    
	this.blindsCanvas.addEventListener('touchstart', $.proxy( this.ev_mousedown,this), false);    
	this.blindsCanvas.addEventListener('touchmove',$.proxy( this.ev_mousemove,this), true);    
	this.blindsCanvas.addEventListener('touchend', $.proxy( this.ev_mouseup,this), false);	
}
 
 $(document).ready(function(){ //process the widgets when the document is loaded
 
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// BLINDS REDRAW CODE
	////////////////////////////////////////////////////////////////////////////////////////////////////
	BlindsWidget.prototype.updateBlinds = function() {
		
		
		var width = this.blindsCanvas.width;
		var height = this.blindsCanvas.height;
		this.blindsPosY = Math.max(15, height * this.blindsPos / 100);
		var blindsCenterX = this.slatWidth /2;
				
		this.blindsContext.clearRect(blindsCenterX - this.slatWidth/2 - 1, 0, this.slatWidth + 4, height);
		this.blindsContext.clearRect(this.arcOffset + this.slatWidth  - handleImageSmall.width/2- 1, height/2 - this.arcRadius - handleImageSmall.height/2, this.arcRadius + handleImageSmall.width + 2, this.arcRadius * 2 + handleImageSmall.height);
		
		this.blindsContext.fillStyle = skyBlue; //bue sky colour
		this.blindsContext.fillRect(blindsCenterX - 15, 0, 15, 400);//blindsPosY);
		this.blindsContext.lineJoin = "round";
		this.blindsContext.lineCap = "round";
		this.blindsContext.beginPath();
		this.blindsContext.lineWidth = 3;
		this.blindsContext.moveTo(blindsCenterX,0);
		this.blindsContext.lineTo(blindsCenterX,this.blindsPosY ); //reduce height to allow for drawing of handle
		this.blindsContext.stroke();
		
		var delta = this.blindsPosY / (this.numBlinds + 1);
		var drawAngle = this.blindsAngle;
		if(this.blindsAngle > 85) drawAngle = 85;
		if(this.blindsAngle < -85) drawAngle = -85;
		
		var radFactor =  Math.PI / 180;
		var angRad = drawAngle * radFactor;
		var slatRad = angRad;
		//if(this.blindsPos < 20) slatRad = 0;

		var cosAngFactor = 0.5 * Math.cos(angRad);
		var sinAngFactor = 0.5 * Math.sin(angRad);
		this.blindsContext.lineWidth = 4;
		for(var y= delta; y < this.numBlinds*(delta-1) + 1  ; y+=delta) {
			var x1 = blindsCenterX - this.slatWidth * cosAngFactor;
			var y1 = y + this.slatWidth * sinAngFactor
			var x2 = blindsCenterX + this.slatWidth *cosAngFactor;
			var y2 = y - this.slatWidth * sinAngFactor;
			this.blindsContext.beginPath();
			this.blindsContext.moveTo(x1,y1);
			this.blindsContext.lineTo(x2,y2);
			this.blindsContext.stroke();
		}
		if(this.glareDetected)
		{
			this.blindsContext.beginPath();
			this.blindsContext.moveTo(this.slatWidth + this.arcOffset, height /2);
			this.blindsContext.arc(this.slatWidth + this.arcOffset, height /2, this.arcRadius, this.glareStartAngle * radFactor, this.glareEndAngle * radFactor, false);
			this.blindsContext.closePath();
			this.blindsContext.fillStyle = glareOrange; //colour of the sun!
			this.blindsContext.fill();
			var theta =  -(this.glareStartAngle + 0.5*(this.glareEndAngle -  this.glareStartAngle) ) * radFactor ;
			this.blindsContext.drawImage(sunImage, (this.slatWidth + this.arcOffset + this.arcRadius * 0.5 * Math.cos(theta) - sunImage.width/2), (height/2 - this.arcRadius * 0.5 * Math.sin(theta) - sunImage.height/2));
		}
		this.blindsContext.lineWidth = 3;
		this.blindsContext.beginPath();
		this.blindsContext.moveTo(this.slatWidth + this.arcOffset, height /2 - this.arcRadius);
		this.blindsContext.arc(this.slatWidth + this.arcOffset, height /2, this.arcRadius, -0.5* Math.PI, 0.5* Math.PI, false);		
		this.blindsContext.stroke();
		this.blindsContext.moveTo(this.slatWidth + this.arcOffset, height /2);
		this.blindsContext.lineTo(this.slatWidth + this.arcOffset + 2*this.arcRadius*cosAngFactor, height/2 - 2*this.arcRadius*sinAngFactor);
		this.blindsContext.stroke();
		
		if(!this.imagesLoaded) {
			this.handleImageLarge.onload =  $.proxy(function() {this.updateBlinds(); imagesLoaded = true}, this);
			handleImageSmall.onload = $.proxy(function() {this.updateBlinds(); imagesLoaded = true}, this);
		}
			
		this.blindsContext.drawImage(this.handleImageLarge, blindsCenterX - this.handleImageLarge.width/2, this.blindsPosY - this.handleImageLarge.height);
		
		this.rotHandlePos = [this.slatWidth + this.arcOffset + 2*this.arcRadius*cosAngFactor, height/2 - 2*this.arcRadius*sinAngFactor];
		this.blindsContext.drawImage(handleImageSmall, this.rotHandlePos[0] - handleImageSmall.width/2, this.rotHandlePos[1] - handleImageSmall.height/2);
		
		
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////
	// HANDLE MOUSE UP EVENTS OUTSIDE OF WIDGET
	////////////////////////////////////////////////////////////////////////////////////////////////////	
	/*
	$(document).mouseup(function(ev) {
		if(myBlindsWidget.heightMode)
		{
			//if the user changes the height of the blinds but releases the mouse *outside* of the widget, then we will capture it here!
			myBlindsWidget.blindsControlCallback(HEIGHT_CHANGED);
			myBlindsWidget.updateBlinds();
		}
		myBlindsWidget.heightMode = false;
		//ev.preventDefault();
	});

	$(document).mousemove(function(ev) {
		if(myBlindsWidget.rotateMode)
			myBlindsWidget.ev_mousemove(ev);
		//ev.preventDefault();
	});
	*/
	BlindsWidget.prototype.setTouchOffsets = function(x, y)
	{
		this.touchOffsetX = x;
		this.touchOffsetY = y;
	}
	BlindsWidget.prototype.setGlare = function(glareFlag) {
		this.glareDetected =  glareFlag;
	}
	
	BlindsWidget.prototype.setGlareAngle = function(start, end) {
		this.glareStartAngle = start;
		this.glareEndAngle = end;
	}

	BlindsWidget.prototype.ev_mouseup = function (ev) {
		if(this.rotateMode)
			this.blindsControlCallback(this.instanceName, ANGLE_CHANGED, this.blindsAngle);
		if(this.heightMode)
			this.blindsControlCallback(this.instanceName, HEIGHT_CHANGED, this.blindsPos);
		this.rotateMode = false;
		this.heightMode = false;
		capturedInput = true;
		ev.preventDefault();
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// HANDLE TOUCH / MOUSEDOWN EVENTS FOR BLINDS HEIGHT AND SLATS
	////////////////////////////////////////////////////////////////////////////////////////////////////
	BlindsWidget.prototype.ev_mousedown = function (ev) {

		var x, y;  
		if(ev.touches != null) {
			ev.preventDefault();
			//var position = this.blindsCanvas.offset();
			x = ev.touches[0].pageX - this.blindsCanvas.offsetLeft - this.touchOffsetX; /////////////////// HACK OFFSET FOR IPAD /////////////////
			y = ev.touches[0].pageY - this.blindsCanvas.offsetTop - this.touchOffsetY; /////////////////// HACK OFFSET FOR IPAD /////////////////			
			//alert(x + "," + y);
		}
		else if (ev.layerX || ev.layerX == 0) { // Firefox
			x = ev.layerX;
			y = ev.layerY;
		} else if (ev.offsetX || ev.offsetX == 0) { // Opera
			x = ev.offsetX;
			y = ev.offsetY;
		}
		blockIncomingEvents = true;
		this.dragStartX = x;
		this.dragStartY = y;
		//TODO touch area should be deduced from dimensions of handle bitmaps

		if((x > this.slatWidth /2 - this.handleWidth/2 && x < this.slatWidth/2 + this.handleWidth/2 ) && (y > this.blindsPosY - 40 && y < this.blindsPosY + 40)) {
			this.heightMode = true;
		}
		else if(x > this.rotHandlePos[0] - 30 && x < this.rotHandlePos[0] + 30 && y > this.rotHandlePos[1] - 30 && y < this.rotHandlePos[1] + 30) {
			this.rotateMode = true;
		}
		ev.preventDefault();
	}
	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////
	// HANDLE TOUCH-DRAG / MOUSE-DRAG EVENTS FOR BLINDS HEIGHT AND SLATS
	////////////////////////////////////////////////////////////////////////////////////////////////////
	BlindsWidget.prototype.ev_mousemove = function(ev) {
	  var x, y;
	  
	  if(ev.touches !=null) {
		  ev.preventDefault();
		  	x = ev.touches[0].pageX - this.blindsCanvas.offsetLeft - this.touchOffsetX; /////////////////// HACK OFFSET FOR IPAD /////////////////
			y = ev.touches[0].pageY - this.blindsCanvas.offsetTop - this.touchOffsetY; /////////////////// HACK OFFSET FOR IPAD /////////////////	
	  }
	  else if (ev.layerX || ev.layerX == 0) { // Firefox
		  x = ev.layerX;
		  y = ev.layerY;
	  } else if (ev.offsetX || ev.offsetX == 0) { // Opera
		  x = ev.offsetX;
		  y = ev.offsetY;
	  }
	  if(this.heightMode) {
	  
		  this.blindsPosY = Math.min(y, this.blindsCanvas.height);
		  if(this.blindsPosY < 15) 
			this.blindsPosY = 15; //diameter of blinds handle
		  if(this.blindsPosY > this.blindsCanvas.height - 20) 
			this.blindsPosY = this.blindsCanvas.height - 1; //diameter of blinds handle
		  
		  var newPos = this.blindsPosY * 100 / this.blindsCanvas.height;
		  if(newPos < 10) newPos = 0;

		  this.blindsPos = newPos;
		  this.updateBlinds();
	  }
	  else if(this.rotateMode) {
		  if(x >= this.arcOffset + this.slatWidth)
		  {
			  var angle = Math.atan(( this.blindsCanvas.height / 2 - y )   /(x - this.arcOffset - this.slatWidth));
			  var degAngle = angle * 180 / Math.PI;

			  this.blindsAngle = degAngle;
			  this.updateBlinds();
			
		  }
	  }  
	  ev.preventDefault();
	}

});	
