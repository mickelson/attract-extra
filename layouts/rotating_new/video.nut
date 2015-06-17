// Video overlay.
// Must be global
//
video <- fe.add_artwork( "movie", -1, -1, fe.layout.width, fe.layout.height);
video.set_rgb (255,255,255);
//video.preserve_aspect_ratio = true;
video.shader = videoShader;

// Functions are exactly the same, but are
// done this way to illustrate the purpose.
function videoUpdate_Vert()
{
    video.width = (overlay_vert.width / 1.38);
    video.height = (overlay_vert.height / 1.6);
    
    video.x = overlay_vert.x + (overlay_vert.width / 7.61);
    video.y = overlay_vert.y +  (overlay_vert.height / 3.15);
}

function videoUpdate_Horz()
{
    video.width = (overlay_horz.width / 2.56);
    video.height = (overlay_horz.height / 1.82);
    
    video.x = overlay_horz.x + (overlay_horz.width / 2)  + (overlay_horz.width / 18);
    video.y = overlay_horz.y +  (overlay_horz.height / 3.15);
}