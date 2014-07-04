// Video overlay.
local backGround = fe.add_artwork( "snap", -5, -5, fe.layout.width, fe.layout.height);
backGround.set_rgb (30,30,30);
backGround.shader = backGroundShader;

local videoShadow = fe.add_artwork( "movie", -1, -1, fe.layout.width, fe.layout.height);
videoShadow.set_rgb (0,0,0);
videoShadow.preserve_aspect_ratio = true;

local video = fe.add_artwork( "movie", (videoShadow.x +6), (videoShadow.y +6), (videoShadow.width -12), (videoShadow.height -12));
video.set_rgb (255,255,255);
video.preserve_aspect_ratio = true;
video.shader = videoShader;