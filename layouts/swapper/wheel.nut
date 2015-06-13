local message = fe.add_text("LOADING",0,200,fe.layout.width,80);
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