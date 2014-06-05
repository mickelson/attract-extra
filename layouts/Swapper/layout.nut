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
local title_Y = 0;
local wheel_Y = 0;
local wheelXDiviser = 0;
if (layoutSettings["rotated"] == "Yes"){
	title_Y = (fe.layout.height / 1.08);
	wheel_Y = (fe.layout.height / 1.20);
	wheelXDiviser = 2.8;
	}
else if (layoutSettings["rotated"] == "No"){
	title_Y = (fe.layout.height / 1.10);
	wheel_Y = (fe.layout.height / 1.33);
	wheelXDiviser = 2.4;
	}
	
local titleSize = 42;
local title_X = (fe.layout.width / 150);
local wheelScale = 1.5;
local wheelShadowOffset = 8;


local listx = 10;
// Image shadow/outline thickness

local bloom = fe.add_shader( Shader.Empty );
local blurSimple = fe.add_shader( Shader.Empty );
if ( layoutSettings["enable_shaders"] == "Yes" ){
	bloom = fe.add_shader( Shader.Fragment, "shaders/bloom_shader.frag" );
	blurSimple = fe.add_shader( Shader.Fragment, "shaders/BlurH.frag","shaders/BlurV.frag" );
	} 
	else if ( layoutSettings["enable_shaders"] == "No" ){
	bloom = fe.add_shader( Shader.Empty );
	blurSimple = fe.add_shader( Shader.Empty );
}

// Gives us a nice high random number for the RGB levels
function brightrand() {
	return 255-(rand()/222);
}
local red = brightrand();
local green = brightrand();
local blue = brightrand();

// Video overlay.
local backGround = fe.add_artwork( "snap", -5, -5, fe.layout.width, fe.layout.height);
backGround.set_rgb (30,30,30);
backGround.shader = blurSimple;
local videoShadow = fe.add_artwork( "movie", -1, -1, fe.layout.width, fe.layout.height);
videoShadow.set_rgb (0,0,0);
videoShadow.preserve_aspect_ratio = true;
local video = fe.add_artwork( "movie", (videoShadow.x +6), (videoShadow.y +6), (videoShadow.width -12), (videoShadow.height -12));
video.set_rgb (255,255,255);
video.preserve_aspect_ratio = true;

// Game wheel image
local wheelArt = (layoutSettings["title_art"]);
local wheelShadow = fe.add_artwork( wheelArt, 0, wheel_Y);
local wheel = fe.add_clone( wheelShadow);

// List Title
local romShadow = fe.add_text( "[ListFilterName]", listx + 5, 6, fe.layout.width - 2, 71.5 );
romShadow.align = Align.Left;
romShadow.style = Style.Bold;
romShadow.set_rgb (0,0,0);
local romList = fe.add_text( "[ListFilterName]", listx, 5, fe.layout.width - 5, 71 );
romList.align = Align.Left;
romList.style = Style.Bold;
romList.set_rgb (red,green,blue);

local detailShadow = fe.add_text( "[ListEntry]/[ListSize]", -1, 36, fe.layout.width, 33 );
detailShadow.align = Align.Right;
detailShadow.style = Style.Bold;
detailShadow.set_rgb (0,0,0);
local listPos = fe.add_text( "[ListEntry]/[ListSize]", 0, 35, fe.layout.width, 32 );
listPos.align = Align.Right;
listPos.style = Style.Bold;

// Game title block
local gameTitleShadow = fe.add_text( "[Title] ([Year])", title_X, title_Y, fe.layout.width, titleSize );
gameTitleShadow.align = Align.Centre;
gameTitleShadow.style = Style.Bold;
gameTitleShadow.set_rgb (0,0,0);
local gameTitle = fe.add_text( "[Title] ([Year])", (title_X - 2), (title_Y - 2), fe.layout.width, titleSize );
gameTitle.align = Align.Centre;
gameTitle.style = Style.Bold;
gameTitle.set_rgb (red,green,blue);

local message = fe.add_text("Player Ready...",0,200,fe.layout.width,80);
message.alpha = 0;
message.style = Style.Bold;

function wheelUpdate(){
	// Set wheel size.
	wheel.width = wheel.texture_width * wheelScale;
	wheel.height = wheel.texture_height * wheelScale;
	wheelShadow.width = wheel.width
	wheelShadow.height = wheel.height;
	// Set wheel position.
	wheel.x = (fe.layout.width /wheelXDiviser) - (wheel.texture_width /2);
	wheel.y = wheel_Y - wheel.texture_height;
	wheelShadow.x = wheel.x + wheelShadowOffset;
	wheelShadow.y = wheel.y + wheelShadowOffset;
	//
	wheelShadow.set_rgb (55,55,55);
	wheel.shader = bloom;
}

// Transitions
fe.add_transition_callback( "new_transitions" );

function new_transitions( ttype, var, ttime ) {
	switch ( ttype )
	{
	case Transition.ToNewList:	
	case Transition.FromOldSelection:
		wheelUpdate();
		break;
		
	case Transition.ToNewSelection:
		wheelUpdate();
			red = brightrand();
			green = brightrand();
            blue = brightrand();
		//romList.set_rgb (red,green,blue);
		//	red = brightrand();
		//	green = brightrand();
        //   blue = brightrand();
		gameTitle.set_rgb (red,green,blue);
			red = brightrand();
			green = brightrand();
            blue = brightrand();
		break;

	case Transition.FromGame:
		if ( ttime < 255 )
		{
			foreach (o in fe.obj)
				o.alpha = ttime;
			message.alpha = 0;
			return true;
		}
		else
		{
			foreach (o in fe.obj)
				o.alpha = 255;
			message.alpha = 0;
		}
		break;

	case Transition.EndLayout:
		if ( ttime < 255 )
		{
			foreach (o in fe.obj)
				o.alpha = 255 - ttime;
			message.alpha = 0;
			return true;
		}
		else
		{
			foreach (o in fe.obj)
				o.alpha = 255;
			message.alpha = 0;
		}
		break;

	case Transition.ToGame:
		if ( ttime < 255 )
		{
			foreach (o in fe.obj)
				o.alpha = 255 - ttime;
			message.alpha = ttime;
			return true;
		}
		break;
	}
	return false;
}
