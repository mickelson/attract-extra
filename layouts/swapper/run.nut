local message = fe.add_text("Player Ready...",0,200,fe.layout.width,80);
message.alpha = 0;
message.style = Style.Bold;

local wheelShadow = fe.add_artwork( wheelArt, 0, wheel_Y);
local wheel = fe.add_clone( wheelShadow);

function wheelUpdate(){
	// Set wheel size.
	wheel.width = wheel.texture_width * wheelScale;
	wheel.height = wheel.texture_height * wheelScale;
	wheelShadow.width = wheel.width
	wheelShadow.height = wheel.height;
	// Set wheel position.
	wheel.x = (fe.layout.width /wheelXDiviser) - (wheel.texture_width /2);
	wheel.y = wheel_Y - wheel.texture_height;
	wheelShadow.x = wheel.x + wheelShadowOffset;
	wheelShadow.y = wheel.y + wheelShadowOffset;
	//
	wheelShadow.set_rgb (55,55,55);
	wheel.shader = titleShader;
}

// Transitions
fe.add_transition_callback( "new_transitions" );

function new_transitions( ttype, var, ttime ) {
	switch ( ttype )
	{
	case Transition.ToNewList:	
	case Transition.FromOldSelection:
		wheelUpdate();
		break;
		
	case Transition.ToNewSelection:
		wheelUpdate();
		break;

	case Transition.FromGame:
		if ( ttime < 255 ){
			foreach (o in fe.obj)
				o.alpha = ttime;
			message.alpha = 0;
			return true;
		}
		else{
			foreach (o in fe.obj)
				o.alpha = 255;
			message.alpha = 0;
		}
		break;

	case Transition.EndLayout:
		if ( ttime < 255 ){
			foreach (o in fe.obj)
				o.alpha = 255 - ttime;
			message.alpha = 0;
			return true;
		}
		else{
			foreach (o in fe.obj)
				o.alpha = 255;
			message.alpha = 0;
		}
		break;

	case Transition.ToGame:
		if ( ttime < 255 ){
			foreach (o in fe.obj)
				o.alpha = 255 - ttime;
			message.alpha = ttime;
			return true;
		}
		break;
	}
	return false;
}

fe.add_ticks_callback( "colourCycle" );
	//
local swR = 0;
local swG = 0;
local swB = 0;
local ccRed = 0;
local ccGreen = 0;
local ccBlue = 0;
local rgbTime = 0;
	
local pinchTime = 0;
local romListPinch = 0;
local swPinch = 0;

function colourCycle( ttime ) {
	
	if (rgbTime == 0)
		rgbTime = ttime;
////////////// 1000 = 1 second //////////////
	if (ttime - rgbTime > 100){
		if (swR==0){
			if (ccRed < 254)
				ccRed += 1;
			if (ccRed >= 254)
				swR = 1;
		}
		else if (swR==1){
			if (ccRed > 100)
				ccRed  -= 2;
			if (ccRed <= 100)
				swR = 0;
		}
		///////////////////////////
		if (swG==0){
			if (ccGreen < 254)
				ccGreen += 2;
			if (ccGreen >= 254)
				swG = 1;
		}
		else if (swG==1){
			if (ccGreen > 100)
				ccGreen  -= 1;
			if (ccGreen <= 100)
				swG = 0;
		}
		///////////////////////////
		if (swB==0){
			if (ccBlue < 254)
				ccBlue += 1.5;
			if (ccBlue >= 254)
				swG = 1;
		}
		else if (swB==1){
			if (ccBlue > 100)
				ccBlue  -= 1.5;
			if (ccBlue <= 100)
				swG = 0;
		}
		rgbTime = 0;
	}
////////////////////////////////////////////
	romList.set_rgb(ccRed, ccGreen, ccBlue);
	gameTitle.set_rgb(ccRed, ccGreen, ccBlue);
	listPos.set_rgb(ccRed, ccGreen, ccBlue);	
}