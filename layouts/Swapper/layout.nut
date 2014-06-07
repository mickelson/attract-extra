///////////////////////////////////////
///
///   Layout with multiple settings for dimensions, shaders, and rotation.
///     Feel free to use any part you like.
///        Various bits and pieces were flogged from other examples and twisted beyond recognition.
///    Luke Jones 4/6/14
///
///////////////////////////////////////

class UserConfig {
	</ label="Title Artwork", help="The artwork used for the title", 
	options="marquee,box,wheel" />
	title_art="marquee";

	</ label="Shaders Enabled", help="Enable Shaders on Artwork (requires shader support)", 
	options="Yes,No" />
	enable_shaders="Yes";
	
	</ label="Background Shader", help="Choose a shader for the background",
	options="Blur,Pixel,Scanlines,Bloom,None" />
	bgndShader="Blur";
	
	</ label="Video Shader", help="Choose a shader for the video",
	options="Blur,Pixel,Scanlines,Bloom,None" />
	vidShader="Blur";
	
	</ label="Title Shader", help="Choose a shader for the title",
	options="Blur,Pixel,Scanlines,Bloom,None" />
	titShader="Blur";

	</ label="Screen Size", help="Select the screen size", 
	options="1360x768,1280x1024,1280x768,1280x720" />
	screenSize="1280x720";
	
	</ label="Screen Rotate", help="Swap X/Y dimensions for rotated screens",
	options="Yes,No" />
	rotated="No";
}

local layoutSettings = fe.get_config();
if ( layoutSettings["screenSize"] == "1360x768" ){
	if ( layoutSettings["rotated"] == "Yes")	{
		fe.layout.width=768;
		fe.layout.height=1360;
	}
	else if ( layoutSettings["rotated"] == "No"){
		fe.layout.width=1360;
		fe.layout.height=768;
	}
}
else if ( layoutSettings["screenSize"] == "1280x1024" ){
	if ( layoutSettings["rotated"] == "Yes"){
		fe.layout.width=1024;
		fe.layout.height=1280;
	}
	else if ( layoutSettings["rotated"] == "No"){
		fe.layout.width=1280;
		fe.layout.height=1024;
	}
}
else if ( layoutSettings["screenSize"] == "1280x768" ){
	if ( layoutSettings["rotated"] == "Yes") {
		fe.layout.width=768;
		fe.layout.height=1280;
	}
	else if ( layoutSettings["rotated"] == "No"){
		fe.layout.width=1280;
		fe.layout.height=768;
	}
}
else if ( layoutSettings["screenSize"] == "1280x720" ){
	if ( layoutSettings["rotated"] == "Yes") {
		fe.layout.width=720;
		fe.layout.height=1280;
	}
	else if ( layoutSettings["rotated"] == "No"){
		fe.layout.width=1280;
		fe.layout.height=720;
	}
}

// Globals
listx <- 10;
title_X <- (fe.layout.width / 150);
title_Y <- 0;
titleSize <- 42;
wheel_Y <- 0;
wheelScale <- 1.5;
wheelShadowOffset <- 8;
wheelXDiviser <- 0;

if ( layoutSettings["rotated"] == "Yes") {
	title_Y = (fe.layout.height / 1.08);
	wheel_Y = (fe.layout.height / 1.20);
	wheelXDiviser = 2.8;
	}
else {
	title_Y = (fe.layout.height / 1.10);
	wheel_Y = (fe.layout.height / 1.33);
	wheelXDiviser = 2.4;
	}
	
// Shader Set Up
local noShader = fe.add_shader( Shader.Empty );
backGroundShader <- noShader;
videoShader <- noShader;
titleShader <- noShader;
// Local Settings
local bloom = noShader;
local blur = noShader;
local pixel = noShader;
local scanlines = noShader;

if ( layoutSettings["enable_shaders"] == "Yes" ){
	bloom = fe.add_shader( Shader.Fragment, "shaders/bloom_shader.frag" );
	blur = fe.add_shader( Shader.Fragment, "shaders/BlurH.frag","shaders/BlurV.frag" );
	pixel = fe.add_shader( Shader.Fragment, "shaders/pixel.frag" );
	scanlines = fe.add_shader( Shader.Fragment, "shaders/scanlines.frag" );
	} 
else if ( layoutSettings["enable_shaders"] == "No" ){
	bloom = noShader;
	blur = noShader;
	pixel = noShader;
	scanlines = noShader;
	backGroundShader = noShader;
}

if ( layoutSettings["bgndShader"] == "Blur" )
	backGroundShader = blur;
else if ( layoutSettings["bgndShader"] == "Pixel" )
	backGroundShader = pixel;
else if ( layoutSettings["bgndShader"] == "Scanlines" )
	backGroundShader = scanlines;
else if ( layoutSettings["bgndShader"] == "Bloom" )
	backGroundShader = bloom;
else if ( layoutSettings["bgndShader"] == "None" )
	backGroundShader = noShader;

if ( layoutSettings["vidShader"] == "Blur" )
	videoShader = blur;
else if ( layoutSettings["vidShader"] == "Pixel" )
	videoShader = pixel;
else if ( layoutSettings["vidShader"] == "Scanlines" )
	videoShader = scanlines;
else if ( layoutSettings["vidShader"] == "Bloom" )
	videoShader = bloom;
else if ( layoutSettings["vidShader"] == "None" )
	videoShader = noShader;
	
if ( layoutSettings["titShader"] == "Blur" )
	titleShader = blur;
else if ( layoutSettings["titShader"] == "Pixel" )
	titleShader = pixel;
else if ( layoutSettings["titShader"] == "Scanlines" )
	titleShader = scanlines;
else if ( layoutSettings["titShader"] == "Bloom" )
	titleShader = bloom;
else if ( layoutSettings["titShader"] == "None" )
	titleShader = noShader;

wheelArt <- (layoutSettings["title_art"]);

fe.do_nut("run.nut");