
function set_bright( r, g, b, o ) {
	o.set_rgb( r, g, b );
}

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
		if ( ttime < 255 )
		{
			foreach (o in fe.obj)
				o.alpha = ttime;
			message.alpha = 0;
			return true;
		}
		else
		{
			foreach (o in fe.obj)
				o.alpha = 255;
			message.alpha = 0;
		}
		break;

	case Transition.EndLayout:
		if ( ttime < 255 )
		{
			foreach (o in fe.obj)
				o.alpha = 255 - ttime;
			message.alpha = 0;
			return true;
		}
		else
		{
			foreach (o in fe.obj)
				o.alpha = 255;
			message.alpha = 0;
		}
		break;

	case Transition.ToGame:
		if ( ttime < 255 )
		{
			foreach (o in fe.obj)
				o.alpha = 255 - ttime;
			message.alpha = ttime;
			return true;
		}
		break;
	}
	return false;
}

fe.add_ticks_callback( "tick" );
	//
local swR = 0;
local swG = 0;
local swB = 0;
local romListRed = 0;
local romListGreen = 0;
local romListBlue = 0;
local rgbTime = 0;
	
local pinchTime = 0;
local romListPinch = 0;
local swPinch = 0;

function tick( ttime ) {
	
	if (rgbTime == 0)
		rgbTime = ttime;
/////////////////////////////////////////////////////////
	if (ttime - rgbTime > 2){
		if (swR==0){
			if (romListRed < 254)
				romListRed += 1;
			if (romListRed >= 254)
				swR = 1;
		}
		else if (swR==1){
			if (romListRed > 100)
				romListRed  -= 2;
			if (romListRed <= 100)
				swR = 0;
		}
		///////////////////////////
		if (swG==0){
			if (romListGreen < 254)
				romListGreen += 2;
			if (romListGreen >= 254)
				swG = 1;
		}
		else if (swG==1){
			if (romListGreen > 100)
				romListGreen  -= 1;
			if (romListGreen <= 100)
				swG = 0;
		}
		///////////////////////////
		if (swB==0){
			if (romListBlue < 254)
				romListBlue += 1.5;
			if (romListBlue >= 254)
				swG = 1;
		}
		else if (swB==1){
			if (romListBlue > 100)
				romListBlue  -= 1.5;
			if (romListBlue <= 100)
				swG = 0;
		}
		rgbTime = 0;
	}
/////////////////////////////////////////////////////////
	set_bright( romListRed, romListGreen, romListBlue, romList );
	set_bright( romListRed, romListGreen, romListBlue, gameTitle );
	set_bright( romListRed, romListGreen, romListBlue, listPos );
	
	
	if (pinchTime == 0)
		pinchTime = ttime;
/////////////////////////////////////////////////////////
	if (ttime - pinchTime > 0.5){
		if (swPinch==0){
				romListPinch += 1;
			if (romListPinch >= 75){
				swPinch = 1;
			}
		}
		else 
		if (swPinch==1){
				romListPinch  -= 1;
			if (romListPinch <= 25)
				swPinch = 0;
		}
		pinchTime = 0;
	}
	romListSurf.pinch_x = -(romListPinch);	
}