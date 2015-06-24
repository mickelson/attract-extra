///////////////////////////////////////
///
///   Layout with multiple settings for dimensions, shaders, and rotation.
///     Feel free to use any part you like.
///        Various bits and pieces were flogged from other examples and twisted beyond recognition.
///    Luke Jones 4/6/14
///
///////////////////////////////////////

class UserConfig {
	</ label="Title Artwork", help="The artwork used for the title", options="marquee,box,wheel" />
	title_art="marquee";

	</ label="Shaders Enabled", help="Enable Shaders on Artwork (requires shader support)", options="Yes,No" />
	enable_shaders="Yes";
	
	</ label="Title Shader", help="Choose a shader for the title", options="Pixel,Scanlines,Bloom,None" />
	titShader="Bloom";
}

local layoutSettings = fe.get_config();

// Globals
titleSize <- 42;
wheel_Y <- 0;
wheelScale <- 1.5;
wheelShadowOffset <- 8;
wheelArt <- (layoutSettings["title_art"]);

function setDimensions(x,y)
{
    fe.layout.width = x;
    fe.layout.height = y;
}

orig_width <- fe.layout.width;
orig_height <- fe.layout.height;

// Shader Setup
local noShader = fe.add_shader( Shader.Empty );
videoShader <- noShader;
titleShader <- noShader;
local None = noShader;

if ( layoutSettings["enable_shaders"] == "Yes" )
{
    switch (layoutSettings["titShader"]){
            case "Pixel": titleShader=fe.add_shader(
                Shader.Fragment, "shaders/Pixel.frag" );
                titleShader.set_param("pixelDark", 1.2);
                break;
            case "Scanlines": titleShader=fe.add_shader(
                Shader.Fragment, "shaders/Scanlines.frag" )
                titleShader.set_param("scannerDarkly", 1.4);
                break;
            case "Bloom": titleShader=fe.add_shader(
                Shader.Fragment, "shaders/Bloom_shader.frag" );
                break;
            case "None": titleShader = noShader;
                break;
    }
    videoShader=fe.add_shader(
                Shader.VertexAndFragment, "shaders/CRT-halation.vsh","shaders/CRT-halation_rgb32_dir.fsh" );
                videoShader.set_param( "ATTRACTMODE", 1 );
                // aspect ratio
                videoShader.set_param( "aspect", 1.0, 0.9 );
                // Radius of curvature
                videoShader.set_param( "R", 4.0 );
                // Size of corners
                videoShader.set_param( "cornersize", 0.038 );
                // Smoothing corners (100-1000)
                videoShader.set_param( "cornersmooth", 400.0 );
                // Hardness of Scanline -8.0 = soft -16.0 = medium
                videoShader.set_param( "hardScan", -10.0 );
                // Hardness of pixels in scanline -2.0 = spoft, -4.0 = hard
                videoShader.set_param( "hardPix", -4.0 );
                //Sets how dark a "dark subpixel" is in the aperture pattern.
                videoShader.set_param( "maskDark", 0.4 );
                //Sets how dark a "bright subpixel" is in the aperture pattern
                videoShader.set_param( "maskLight", 1.8 );
                // BLOOM VARS //
                // Hardness of short vertical bloom.
                //  -1.0 = wide to the point of clipping (bad)
                //  -1.5 = wide
                //  -4.0 = not very wide at all
                videoShader.set_param( "hardBloomScan", -2.0 );
                // Hardness of short horizontal bloom.
                //  -0.5 = wide to the point of clipping (bad)
                //  -1.0 = wide
                //  -2.0 = not very wide at all
                videoShader.set_param( "hardBloomPix", -1.5 );
                // Amount of small bloom effect.
                //  1.0/1.0 = only bloom
                //  1.0/16.0 = what I think is a good amount of small bloom
                //  0.0     = no bloom
                videoShader.set_param( "bloomAmount", 1.0/6.0 );
                
                // Standard Shader stuff. Can probably send image.width to shader
                videoShader.set_param( "color_texture_sz", 640, 480 );
                videoShader.set_param( "color_texture_pow2_sz", 640, 480 );
                videoShader.set_texture_param( "mpass_texture" );
}
else
{
    videoShader = noShader;
    titleShader = noShader;
}

// Video overlay.
local videoShadow = fe.add_artwork( "movie", -1, -1, fe.layout.width, fe.layout.height);
videoShadow.set_rgb (0,0,0);
videoShadow.preserve_aspect_ratio = true;

local video = fe.add_artwork( "movie", (videoShadow.x +6), (videoShadow.y +6), (videoShadow.width -12), (videoShadow.height -12));
video.set_rgb (255,255,255);
video.preserve_aspect_ratio = true;
video.shader = videoShader;

fe.do_nut("text.nut");
fe.do_nut("wheel.nut");

function do_roll()
{
    videoShadow.width = (fe.layout.width - 20);
    videoShadow.x = (fe.layout.width / 2 - 5) - ( videoShadow.width / 2);
    videoShadow.y = (fe.layout.height / 2 - 5) - ( videoShadow.height / 2);
    video.width = videoShadow.width;
    video.set_pos(videoShadow.x+6,videoShadow.y+6);
    wheel_Y = (fe.layout.height / 1.20);
    wheelUpdate();
    gameTitleShadow.y = (fe.layout.height - 73);
    gameTitleShadow.x = (fe.layout.width / 2) - (gameTitleShadow.width / 2);
    gameTitle.y = (fe.layout.height - 70);
    gameTitle.x = (fe.layout.width / 2 - 5) - ( gameTitle.width / 2 - 5);
    romListSurf.y = 5;
    romListSurf.x = (fe.layout.width / 2 - 5) - ( gameTitle.width / 2 - 5);
}
function do_norm()
{
    videoShadow.width = (fe.layout.width - 20);
    videoShadow.x = (fe.layout.width / 2 - 5) - ( videoShadow.width / 2);
    videoShadow.y = (fe.layout.height / 2 - 5) - ( videoShadow.height / 2);
    video.width = videoShadow.width;
    video.set_pos(videoShadow.x+6,videoShadow.y+6);
    wheel_Y = (fe.layout.height / 1.33);
    wheelUpdate();
    gameTitleShadow.y = (fe.layout.height - 73);
    gameTitleShadow.x = (fe.layout.width / 2) - (gameTitleShadow.width / 2);
    gameTitle.y = (fe.layout.height - 70);
    gameTitle.x = (fe.layout.width / 2 - 5) - ( gameTitle.width / 2 - 5);
    romListSurf.y = 5;
    romListSurf.x = (fe.layout.width / 2 - 5) - ( gameTitle.width / 2 - 5);
}

function orientation( the_string )
{
    if (the_string == "toggle_rotate_right")
    {
        print("Switching layout rolled\n");
        fe.layout.height = orig_width;
        fe.layout.width = orig_height;
        fe.layout.toggle_rotation = RotateScreen.Right;
        do_roll();
        return true;
    }
    if (the_string == "toggle_rotate_left")
    {
        print("Switching layout rolled\n");
        fe.layout.height = orig_width;
        fe.layout.width = orig_height;
        fe.layout.toggle_rotation = RotateScreen.Left;
        do_roll();
        return true;
    }
    if (the_string == "toggle_flip")
    {
        print("Switching layout normal\n");
        fe.layout.height = orig_height;
        fe.layout.width = orig_width;
        fe.layout.toggle_rotation = RotateScreen.None;
        do_norm();
        return true;
    }
    return false;
}

do_norm();
fe.add_signal_handler("orientation");