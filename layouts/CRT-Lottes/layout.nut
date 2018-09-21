/********************************************
/
/ A demo theme for basic Lottes shader +
/ optional bloom
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
/************************************************************
/ Bloom, can be used for a first-pass on underlying surface
************************************************************/
local shader_bloom = null;
shader_bloom = fe.add_shader(Shader.Fragment, "shaders/bloom.fsh");
shader_bloom.set_param("bloom_spread", 0.000695);
shader_bloom.set_param("bloom_power", 0.228);
shader_bloom.set_texture_param("mpass_texture");

/********************************************************
/ More complex Lottes shader with curvature and corners
********************************************************/
local shader_lottes = null;
shader_lottes=fe.add_shader(
    Shader.VertexAndFragment,
    "shaders/CRT-geom.vsh",
    "shaders/CRT-geom.fsh");
// APERATURE_TYPE
// 0 = VGA style shadow mask.
// 1.0 = Very compressed TV style shadow mask.
// 2.0 = Aperture-grille.
shader_lottes.set_param("aperature_type", 0.0);
shader_lottes.set_param("hardScan", -20.0);   // Hardness of Scanline -8.0 = soft -16.0 = medium
shader_lottes.set_param("hardPix", -5.0);     // Hardness of pixels in scanline -2.0 = soft, -4.0 = hard
shader_lottes.set_param("maskDark", 0.4);     // Sets how dark a "dark subpixel" is in the aperture pattern.
shader_lottes.set_param("maskLight", 1.5);    // Sets how dark a "bright subpixel" is in the aperture pattern
shader_lottes.set_param("saturation", 1.1);   // 1.0 is normal saturation. Increase as needed.
shader_lottes.set_param("tint", 0.0);         // 0.0 is 0.0 degrees of Tint. Adjust as needed.
shader_lottes.set_param("blackClip", 0.02);   // Drops the final color value by this amount
                                                    // if GAMMA_CONTRAST_BOOST is defined
shader_lottes.set_param("brightMult", 1.2);   // Multiplies the color values by this amount
                                                    // if GAMMA_CONTRAST_BOOST is defined
shader_lottes.set_param("distortion", 0.15);  // 0.0 to 0.2 seems right
shader_lottes.set_param("cornersize", 0.03);  // 0.0 to 0.1
shader_lottes.set_param("cornersmooth", 80);  // Reduce jagginess of corners
shader_lottes.set_texture_param("texture");

// Video overlay.
local vidSurf = fe.add_surface(fe.layout.width, fe.layout.height);
local video = vidSurf.add_artwork("snap", 0, 0, vidSurf.width, vidSurf.height);

video.set_rgb (255,255,255);
video.preserve_aspect_ratio = true;
video.shader = shader_lottes;

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
        video.shader.set_param("color_texture_sz", vidSurf.width/4, vidSurf.height/4);
        video.shader.set_param("color_texture_pow2_sz", vidSurf.width/4, vidSurf.height/4);
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
