/////////////////////////////////////////////
// All settings/functions relating to
// orientation live here.
//
// Any Layout ART to be manipulated must
// be set GLOBAL in their related nuts.
/////////////////////////////////////////////

function do_roll()
{
    // Do overlay update first as all other functions
    // rely on it to get correct dimensions
    overlayUpdate_Vert();
    wheelUpdate_Vert();
    textUpdate_Vert();
    videoUpdate_Vert();
}
function do_norm()
{
    overlayUpdate_Horz();
    wheelUpdate_Horz();
    textUpdate_Horz();
    videoUpdate_Horz();
}

function orientation( the_string )
{
    if (the_string == "toggle_rotate_right")
    {
        fe.layout.height = orig_width;
        fe.layout.width = orig_height;
        fe.layout.toggle_rotation = RotateScreen.Right;
        do_roll();
        return true;
    }
    if (the_string == "toggle_rotate_left")
    {
        fe.layout.height = orig_width;
        fe.layout.width = orig_height;
        fe.layout.toggle_rotation = RotateScreen.Left;
        do_roll();
        return true;
    }
    if (the_string == "toggle_flip")
    {
        fe.layout.height = orig_height;
        fe.layout.width = orig_width;
        fe.layout.toggle_rotation = RotateScreen.None;
        do_norm();
        return true;
    }
    return false;
}

// Set orientation
do_norm();
fe.add_signal_handler("orientation");