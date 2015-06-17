///
//fe.add_image( "bg.png", 0, 0 );

// No need to be global if we call a function for updates.
overlay_horz <- fe.add_image( "bg_horz.png", 0, 0);
overlay_vert <- fe.add_image( "bg_vert.png", 0, 0);
// overlay_vert.rotation = 90;

function overlayUpdate_Horz()
{
    overlay_horz.height = fe.layout.height;
    // Get the ratio to scale width by.
    local ratio = fe.layout.height / overlay_horz.texture_height;
    // Set the width by scaling the original texture
    overlay_horz.width = ratio * overlay_horz.texture_width;
    // Now we can set the X pos accurately. 
    // overlay_horz.width will return 0 if we didn't do the above.
    overlay_horz.x = (fe.layout.width / 2) - (overlay_horz.width / 2);
    overlay_horz.y = 0;
    overlay_vert.alpha = 0;
    overlay_horz.alpha = 255;
}

function overlayUpdate_Vert()
{
    overlay_vert.width = fe.layout.width;
    // Get the ratio to scale width by.
    local ratio = overlay_vert.texture_height / overlay_vert.texture_width;
    // Set the width by scaling the original texture
    overlay_vert.height = overlay_vert.width * ratio;
    // Now we can set the X pos accurately. 
    // overlay_vert.width will return 0 if we didn't do the above.
    overlay_vert.x = (fe.layout.width / 2) - (overlay_vert.width / 2);
    overlay_vert.y = (fe.layout.height / 2) - (overlay_vert.height / 2);
    overlay_vert.alpha = 255;
    overlay_horz.alpha = 0;
}