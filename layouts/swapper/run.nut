
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
local redTime = 0;
local greenTime = 0;
local blueTime = 0;
	
function tick( ttime ) {
	
	if (redTime == 0)
		redTime = ttime;
	if (greenTime == 0)
		greenTime = ttime;
	if (blueTime == 0)
		blueTime = ttime;
/////////////////////////////////////////////////////////
	if (ttime - redTime > 0.15){
		if (swR==0){
			if (romListRed < 254)
				romListRed += 3;
			if (romListRed >= 254){
				swR = 1;
			}
		}
		else 
		if (swR==1){
			if (romListRed > 100)
				romListRed  -= 3;
			if (romListRed <= 100){
				swR = 0;
			}
		}
		redTime = 0;
	}
/////////////////////////////////////////////////////////
	if (ttime - greenTime > 0.1){
		if (swG==0){
			if (romListGreen < 254)
				romListGreen += 1;
			if (romListGreen >= 254){
				swG = 1;
			}
		}
		else 
		if (swR==1){
			if (romListGreen > 100)
				romListGreen  -= 1;
			if (romListGreen <= 100){
				swG = 0;
			}
		}
		greenTime = 0;
	}
/////////////////////////////////////////////////////////
	if (ttime - blueTime > 0.05){
		if (swR==0){
			if (romListBlue < 254)
				romListBlue += 1;
			if (romListBlue >= 254){
				swR = 1;
			}
		}
		else 
		if (swR==1){
			if (romListBlue > 100)
				romListBlue  -= 1;
			if (romListBlue <= 100){
				swR = 0;
			}
		}
		blueTime = 0;
	}
	set_bright( romListRed, romListGreen, romListBlue, romList );
	set_bright( romListRed, romListGreen, romListBlue, gameTitle );
	set_bright( romListRed, romListGreen, romListBlue, listPos );
}