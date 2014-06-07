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
switch (layoutSettings["screenSize"]){
	case "1360x768":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=768; 	fe.layout.height=1360;		break;
		case "No" :		fe.layout.width=1360;	fe.layout.height=768;		break;
	}
	break;
	case "1280x1024":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=1024; 	fe.layout.height=1280;		break;
		case "No" :		fe.layout.width=1280;	fe.layout.height=1024;		break;
	}
	break;
	case "1280x768":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=768; 	fe.layout.height=1280;		break;
		case "No" :		fe.layout.width=1280;	fe.layout.height=768;		break;
	}
	break;
	case "1280x720":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=720; 	fe.layout.height=1280;		break;
		case "No" :		fe.layout.width=1280;	fe.layout.height=720;		break;
	}
	break;
}
// Globals
list_X <- 10;	
list_Y <- 0;
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
	
// Shader Setup
local noShader = fe.add_shader( Shader.Empty );
backGroundShader <- noShader;
videoShader <- noShader;
titleShader <- noShader;
// Local Settings
local Bloom = noShader;
local Blur = noShader;
local Pixel = noShader;
local Scanlines = noShader;
local None = noShader;

if ( layoutSettings["enable_shaders"] == "Yes" ){
	Bloom		= fe.add_shader( Shader.Fragment, "shaders/Bloom_shader.frag" );
	Blur 		= fe.add_shader( Shader.Fragment, "shaders/BlurH.frag","shaders/BlurV.frag" );
	Pixel		= fe.add_shader( Shader.Fragment, "shaders/Pixel.frag" );
	Scanlines 	= fe.add_shader( Shader.Fragment, "shaders/Scanlines.frag" );
} 
else if ( layoutSettings["enable_shaders"] == "No" ){
	Bloom = noShader;
	Blur = noShader;
	Pixel = noShader;
	Scanlines = noShader;
	backGroundShader = noShader;
}

switch (layoutSettings["bgndShader"]){
	case "Blur": 		backGroundShader = Blur;		break;
	case "Pixel":		backGroundShader = Pixel; 		break;
	case "Scanlines": 	backGroundShader = Scanlines;	break;
	case "Bloom": 		backGroundShader = Bloom;		break;
	case "None": 		backGroundShader = noShader;	break;
}
switch (layoutSettings["vidShader"]){
	case "Blur": 		videoShader = Blur;				break;
	case "Pixel":		videoShader = Pixel; 			break;
	case "Scanlines": 	videoShader = Scanlines; 		break;
	case "Bloom": 		videoShader = Bloom;			break;
	case "None": 		videoShader = noShader;			break;
}
switch (layoutSettings["titShader"]){
	case "Blur": 		titleShader = Blur;				break;
	case "Pixel":		titleShader = Pixel;			break;
	case "Scanlines": 	titleShader = Scanlines;		break;
	case "Bloom": 		titleShader = Bloom;			break;
	case "None": 		titleShader = noShader;			break;
}

wheelArt <- (layoutSettings["title_art"]);

fe.do_nut("video.nut");
fe.do_nut("run.nut");
fe.do_nut("text.nut");