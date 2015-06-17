/////////
/////////
local message = fe.add_text("LOADING",0,200,fe.layout.width,80);
message.alpha = 0;
message.style = Style.Bold;

local wheel = fe.add_artwork( wheelArt, 0, 0);

// Does the same as the **update_Horz and **update_Vert
// functions, but universal. Relies on the overlay for dimensions.
function wheelUpdate_Horz()
{
    // Set wheel size.
    //wheel.width = overlay_horz.width / 2.46 ;
    wheel.height = overlay_horz.height / 6.72;
    // This keeps the original ratio
    if (wheel.texture_height != 0 && wheel.texture_width != 0)
    {
        wheel.width = (wheel.height * (wheel.texture_height / wheel.texture_width));
    }            
    wheel.x = overlay_horz.x + (overlay_horz.width / 1.335) - (wheel.texture_width / 2);
    wheel.y = overlay_horz.y + (overlay_horz.height / 7.5);
    
    wheel.shader = titleShader;
}

function wheelUpdate_Vert()
{
    // Set wheel size.
    //wheel.width = overlay_vert.width / 1.36 ;
    wheel.height = overlay_vert.height / 5.25;
    // This keeps the original ratio
    if (wheel.texture_height != 0 && wheel.texture_width != 0)
    {
        wheel.width = (wheel.height * (wheel.texture_height / wheel.texture_width));
    }
    wheel.x = overlay_vert.x + (overlay_vert.width / 2) - (wheel.texture_width / 2);
    wheel.y = overlay_vert.y + (overlay_vert.height / 21.3);
    
    wheel.shader = titleShader;
}

function wheelFresh( ttype, var, ttime )
{
    local actual_rotation = (fe.layout.base_rotation + fe.layout.toggle_rotation)%4;    
    if (ttype == Transition.ToNewSelection || Transition.FromOldSelection)
    {
        if (( actual_rotation == RotateScreen.Left ) || ( actual_rotation == RotateScreen.Right ))
        {
            wheelUpdate_Vert();
        }
        else
        {
            wheelUpdate_Horz();
        }
    }
    return false;
}
fe.add_transition_callback( "wheelFresh" );