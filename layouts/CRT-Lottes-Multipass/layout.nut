/********************************************
/
/ A demo theme for a two-pass CRT shader
/
/ 20/09/2018 - Luke Jones
/
/ See headers in shaders for credits
/
********************************************/

class UserConfig {	
	</ label="Screen Rotate", help="Swap X/Y dimensions for rotated screens",
	options="Yes,No" />
	rotated="No";
}

// Globals
list_X <- 10;	
list_Y <- 0;
title_X <- (fe.layout.width / 150);
title_Y <- 0;
titleSize <- 42;

local layoutSettings = fe.get_config();

switch (layoutSettings["rotated"]){
	case "No": 
        fe.layout.width = ScreenWidth;
        fe.layout.height = ScreenHeight;
        title_Y = (fe.layout.height / 1.10);
        fe.layout.orient = RotateScreen.None;
        break;
	case "Yes" :
        fe.layout.width = ScreenHeight;
        fe.layout.height = ScreenWidth;
        title_Y = (fe.layout.height / 1.08);
    	fe.layout.orient = RotateScreen.Right;
        break;
};

// Shader Setup
local bloom_pass = null;
bloom_pass=fe.add_shader(
    Shader.VertexAndFragment,
    "shaders/bloompass.vs",
    "shaders/bloompass.fs");
bloom_pass.set_texture_param("source");

local scan_pass = null;
scan_pass=fe.add_shader(
    Shader.VertexAndFragment,
    "shaders/scanpass.vs",
    "shaders/scanpass.fs");
scan_pass.set_texture_param("source");

// Video overlay.
local vidSurf = fe.add_surface(fe.layout.width, fe.layout.height);
vidSurf.shader = bloom_pass;
local video = vidSurf.add_artwork("snap", 0, 0, vidSurf.width, vidSurf.height);
video.set_rgb (255,255,255);
video.preserve_aspect_ratio = true;
video.shader = scan_pass;

// Transitions
fe.add_transition_callback( "new_transitions" );

function new_transitions( ttype, var, ttime ) {
	switch ( ttype )
	{
	case Transition.ToNewList:	
	case Transition.FromOldSelection:
	case Transition.ToNewSelection:
		video.width = vidSurf.subimg_width;
        video.height = vidSurf.subimg_height;
        vidSurf.shader.set_param("sourceSize", video.width, video.height); // bloom
        // scanlines
        // Division of source dimensions controls scanline amount
        video.shader.set_param("sourceSize", video.width/8, video.height/8);
        // Divions of dimensions here controls sharpness
        video.shader.set_param("outputSize", video.width, video.height);
		break;
    }
	return false;
}


// List Title
romListSurf <- fe.add_surface ( fe.layout.width, 200);
romList <- romListSurf.add_text( "[ListFilterName]", 0, 5, fe.layout.width - 5, 82 );
romList.align = Align.Centre;
romList.style = Style.Bold;

// List Position
listPosition <- romListSurf.add_text( "[ListEntry]/[ListSize]", 0, 100, fe.layout.width, 32 );
listPosition.align = Align.Centre;
listPosition.style = Style.Bold;

// Game title block
gameTitle <- fe.add_text( "[Title] ([Year])", (title_X - 2), (title_Y - 2), fe.layout.width, titleSize );
gameTitle.align = Align.Centre;
gameTitle.style = Style.Bold;
