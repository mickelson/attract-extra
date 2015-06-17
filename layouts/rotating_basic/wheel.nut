/////////
/////////
local message = fe.add_text("LOADING",0,200,fe.layout.width,80);
message.alpha = 0;
message.style = Style.Bold;

local wheel = fe.add_artwork( wheelArt, 0, 0);

// Does the same as the **update_Horz and **update_Vert
// functions, but universal. Relies on the overlay for dimensions.
function wheelUpdate()
{
	// Set wheel size.
	wheel.width = overlay.width / 2.46 ;
        	
        wheel.x = overlay.x + (overlay.width / 1.83);
	wheel.y = overlay.y + (overlay.height / 7.5);
	
        wheel.shader = titleShader;
        if (wheel.texture_height != 0 && wheel.texture_width != 0)
        {
            wheel.height = (wheel.width * (wheel.texture_height / wheel.texture_width));
        }
}

function wheelFresh( ttype, var, ttime )
{
    if (ttype == Transition.ToNewSelection || Transition.FromOldSelection)
    {
        wheelUpdate();
    }
    return false;
}
fe.add_transition_callback( "wheelFresh" );