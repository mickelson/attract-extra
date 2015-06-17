///
//fe.add_image( "bg.png", 0, 0 );

// No need to be global if we call a function for updates.
overlay <- fe.add_image( "bg.png", 0, 0);

function overlayUpdate_Horz()
{
    overlay.height = fe.layout.height;
    // Get the ratio to scale width by.
    local ratio = fe.layout.height / overlay.texture_height;
    // Set the width by scaling the original texture
    overlay.width = ratio * overlay.texture_width;
    // Now we can set the X pos accurately. 
    // overlay.width will return 0 if we didn't do the above.
    overlay.x = (fe.layout.width / 2) - (overlay.width / 2);
    overlay.y = 0;
}

function overlayUpdate_Vert()
{
    overlay.width = fe.layout.width;
    // Get the ratio to scale width by.
    local ratio = overlay.texture_width / overlay.texture_height;
    // Set the width by scaling the original texture
    overlay.height = overlay.width * ratio;
    // Now we can set the X pos accurately. 
    // overlay.width will return 0 if we didn't do the above.
    overlay.x = (fe.layout.width / 2) - (overlay.width / 2);
    overlay.y = (fe.layout.height / 2) - (overlay.height / 2);
}