/////////
/////////
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
	wheel.x = (fe.layout.width / 2) - (wheel.texture_width /2);
	wheel.y = wheel_Y - wheel.texture_height;
	wheelShadow.x = wheel.x + wheelShadowOffset;
	wheelShadow.y = wheel.y + wheelShadowOffset;
	//
	wheelShadow.set_rgb (55,55,55);
	wheel.shader = titleShader;
}

function wheelFresh( ttype, var, ttime )
{
    if (ttype == Transition.ToNewSelection || Transition.FromOldSelection)
    {
	// Set wheel size.
	wheel.width = wheel.texture_width * wheelScale;
	wheel.height = wheel.texture_height * wheelScale;
	wheelShadow.width = wheel.width
	wheelShadow.height = wheel.height;
	// Set wheel position.
	wheel.x = (fe.layout.width / 2) - (wheel.texture_width /2);
	wheel.y = wheel_Y - wheel.texture_height;
	wheelShadow.x = wheel.x + wheelShadowOffset;
	wheelShadow.y = wheel.y + wheelShadowOffset;
	//
	wheelShadow.set_rgb (55,55,55);
	wheel.shader = titleShader;
    }
    return false;
}
fe.add_transition_callback( "wheelFresh" );