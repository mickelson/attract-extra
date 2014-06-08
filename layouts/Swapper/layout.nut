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
	options="Blur,Pixel,None" />
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
	}	break;
	case "1280x1024":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=1024; 	fe.layout.height=1280;		break;
		case "No" :		fe.layout.width=1280;	fe.layout.height=1024;		break;
	}	break;
	case "1280x768":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=768; 	fe.layout.height=1280;		break;
		case "No" :		fe.layout.width=1280;	fe.layout.height=768;		break;
	}	break;
	case "1280x720":
	switch (layoutSettings["rotated"]){
		case "Yes": 	fe.layout.width=720; 	fe.layout.height=1280;		break;
		case "No" :		fe.layout.width=1280;	fe.layout.height=720;		break;
	}	break;
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
local None = noShader;

if ( layoutSettings["enable_shaders"] == "Yes" ){
	switch (layoutSettings["bgndShader"]){
		case "Blur": 		backGroundShader=fe.add_shader( Shader.Fragment, "shaders/BlurH.frag","shaders/BlurV.frag" );
								backGroundShader.set_param("blurDark", 1.6);								break;
		case "Pixel":		backGroundShader=fe.add_shader( Shader.Fragment, "shaders/Pixel.frag" );			
								backGroundShader.set_param("pixelDark", 0.4);								break;
		case "Scanlines": 	backGroundShader=fe.add_shader( Shader.Fragment, "shaders/Scanlines.frag" );
								backGroundShader.set_param("scannerDarkly", -0.5);							break;
		case "Bloom": 		backGroundShader=fe.add_shader( Shader.Fragment, "shaders/Bloom_shader.frag" );	break;
		case "None": 		backGroundShader = noShader; break;
	}
} else backGroundShader = noShader;
if ( layoutSettings["enable_shaders"] == "Yes" ){
	switch (layoutSettings["vidShader"]){
		case "Blur": 		videoShader=fe.add_shader( Shader.Fragment, "shaders/BlurH.frag","shaders/BlurV.frag" );
								videoShader.set_param("blurDark", 0.7);										break;
		case "Pixel":		videoShader=fe.add_shader( Shader.Fragment, "shaders/Pixel.frag" );			
								videoShader.set_param("pixelDark", 1.3);									break;
		case "Scanlines": 	videoShader=fe.add_shader( Shader.Fragment, "shaders/Scanlines.frag" );
								videoShader.set_param("scannerDarkly", 1.2);								break;
		case "Bloom": 		videoShader=fe.add_shader( Shader.Fragment, "shaders/Bloom_shader.frag" );		break;
		case "None": 		videoShader = noShader; break;
	}
} else videoShader = noShader;
if ( layoutSettings["enable_shaders"] == "Yes" ){
	switch (layoutSettings["titShader"]){
		case "Blur": 		titleShader=fe.add_shader( Shader.Fragment, "shaders/BlurH.frag","shaders/BlurV.frag" );
								titleShader.set_param("blurDark", 0.7);										break;
		case "Pixel":		titleShader=fe.add_shader( Shader.Fragment, "shaders/Pixel.frag" );			
								titleShader.set_param("pixelDark", 1.2);									break;
		case "Scanlines": 	titleShader=fe.add_shader( Shader.Fragment, "shaders/Scanlines.frag" );			break;
								titleShader.set_param("scannerDarkly", 1.4);								break;
		case "Bloom": 		titleShader=fe.add_shader( Shader.Fragment, "shaders/Bloom_shader.frag" );		break;
		case "None": 		titleShader = noShader; break;
	}
} else titleShader = noShader;

wheelArt <- (layoutSettings["title_art"]);

//Drwa order can be changed via reordering of running scripts.
fe.do_nut("video.nut");
fe.do_nut("run.nut");
fe.do_nut("text.nut");