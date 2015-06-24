///////////////////////////////////////
///
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
wheelArt <- (layoutSettings["title_art"]);
orig_width <- fe.layout.width;
orig_height <- fe.layout.height;

function setDimensions(x,y)
{
    fe.layout.width = x;
    fe.layout.height = y;
}

// Shader Setup
noShader <- fe.add_shader( Shader.Empty );
videoShader <- noShader;
titleShader <- noShader;

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
                Shader.VertexAndFragment, "shaders/CRT_SIMPLE-halation.vsh","shaders/CRT_SIMPLE-halation_rgb32_dir.fsh" );
                videoShader.set_param( "color_texture_sz", 640, 480 );
                videoShader.set_param( "color_texture_pow2_sz", 640, 480 );
                videoShader.set_texture_param( "mpass_texture" );
}
else { videoShader = noShader; titleShader = noShader; } // <-- I try not to code like this

// Order of NUTS determines drawing order.
fe.do_nut("wheel.nut");
fe.do_nut("video.nut");
fe.do_nut("set_overlay.nut");
fe.do_nut("text.nut");
fe.do_nut("set_orientation.nut");