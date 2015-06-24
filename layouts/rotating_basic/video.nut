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
    video.width = (overlay.width / 2.56);
    video.height = (overlay.height / 1.82);
    
    video.x = overlay.x + (overlay.width / 2)  + (overlay.width / 18);
    video.y = overlay.y +  (overlay.height / 3.15);
}

function videoUpdate_Horz()
{
    video.width = (overlay.width / 2.56);
    video.height = (overlay.height / 1.82);
    
    video.x = overlay.x + (overlay.width / 2)  + (overlay.width / 18);
    video.y = overlay.y +  (overlay.height / 3.15);
}