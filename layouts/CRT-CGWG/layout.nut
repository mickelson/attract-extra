/********************************************
/
/ A demo theme cgwg's CRT shader + optional
/ bloom
/
/ 20/09/2018 - Luke Jones
/
/ See headers in shaders for credits
/
********************************************/

class UserConfig {	
    </ label="Bloom Shader", help="Bloom applied with CRT shaders",
	options="Yes,No" />
	bloom="No";
	
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
local noShader = fe.add_shader( Shader.Empty );

/************************************************************
/ Bloom, can be used for a first-pass on underlying surface
************************************************************/
local shader_bloom = null;
shader_bloom = fe.add_shader(Shader.Fragment, "shaders/bloom.fsh");
shader_bloom.set_param("bloom_spread", 0.000695);
shader_bloom.set_param("bloom_power", 0.128);
shader_bloom.set_texture_param("mpass_texture");

local None = noShader;

/********************************************************
/ Shader by cgwg, Themaister and DOLLS
********************************************************/
local shader_cgwg = null;
shader_cgwg=fe.add_shader(
    Shader.VertexAndFragment,
    "shaders/CRT-geom.vsh",
    "shaders/CRT-geom.fsh");
shader_cgwg.set_param("CRTgamma", 2.4);          // gamma of simulated CRT
shader_cgwg.set_param("monitorgamma", 2.2);      // gamma of display monitor (typically 2.2 is correct)
shader_cgwg.set_param("overscan", 0.99, 0.99);   // overscan (e.g. 1.02 for 2% overscan)
shader_cgwg.set_param("aspect", 1.0, 0.75);      // aspect ratio
shader_cgwg.set_param("d", 1.3);                 // distance from viewer
shader_cgwg.set_param("R", 2.5);                 // radius of curvature - 2.0 to 3.0?
shader_cgwg.set_param("cornersize", 0.02);       // size of curved corners
shader_cgwg.set_param("cornersmooth", 80);       // border smoothness parameter
                                                // decrease if borders are too aliased
shader_cgwg.set_texture_param("texture");

// Video overlay.
local vidSurf = fe.add_surface(fe.layout.width, fe.layout.height);
local video = vidSurf.add_artwork("snap", 0, 0, vidSurf.width, vidSurf.height);

video.set_rgb (255,255,255);
video.preserve_aspect_ratio = true;
video.shader = shader_cgwg;

switch (layoutSettings["bloom"]){
    case "Yes":
        vidSurf.shader = shader_bloom;
        break;
	case "No":
        vidSurf.shader = fe.add_shader(Shader.Empty);
        break;
}

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
        // Play with these settings to get a good final image
        video.shader.set_param("inputSize", vidSurf.width, vidSurf.height);  // size of input
        video.shader.set_param("outputSize", vidSurf.width, vidSurf.height); // size of mask
        video.shader.set_param("textureSize", vidSurf.width, vidSurf.height);// size drawing to
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
