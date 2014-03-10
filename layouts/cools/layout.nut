// Layout by cools / Arcade Otaku
// http://www.arcadeotaku.com
// Uses snap, wheel and flyer images. Will use title images if desired.
//
// Changes
// V1: Initial release.
// V2: Added shader to snapshot image. Added configuration options to disable onscreen text.
// V3: Allowed selection of background image.
///////////////////////////////////////////////////////// 
// Layout User Options
class UserConfig {
 </ label="Background Shader", help="Filter the background image with a shader (requires shader support)", options="Yes,No" /> enable_bg_shader="Yes";
 </ label="Background Image", help="Choose snap, title, or user image (bg.jpg in layout folder) for layout background", options="snap,title,user" /> bg_image = "snap";
 </ label="Title Flicker", help="Flicker the game title", options="Yes,No" /> enable_flicker="Yes";
 </ label="Display List Name", help="Show ROM list name", options="Yes,No" /> enable_list="Yes";
 </ label="Display Filter Name", help="Show filter name", options="Yes,No" /> enable_filter="Yes";
 </ label="Display Entries", help="Show quantity of ROMs in current filter", options="Yes,No" /> enable_entries="Yes";
 </ label="Display Category", help="Show game category", options="Yes,No" /> enable_category="Yes";
 </ label="Flyer Angle", help="Rotation of the game flyer in degrees (0-15)", options="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15" /> flyer_angle="5";
}
local my_config = fe.get_config();
// Layout Constants
fe.layout.width=640;
fe.layout.height=480;
fe.layout.font="Coolvetica";
//fe.layout.font="BorisBlackBloxx";
//fe.layout.font="Fava-black";
// Shaders
local no_shader = fe.add_shader( Shader.Empty );
local bg_shader;
if ( my_config["enable_bg_shader"] == "Yes" ) {
 bg_shader = fe.add_shader( Shader.Fragment, "bloom_shader.frag" );
 bg_shader.set_texture_param("bgl_RenderedTexture");
}
else {
 bg_shader = no_shader;
}
// Game name text. We do this in the layout as the frontend doesn't chop up titles with a forward slash
function gamename( index_offset ) {
 local s = split( fe.game_info( Info.Title, index_offset ), "(/[" );
 if ( s.len() > 0 ) return s[0];
 return "";
}
// Copyright text
function copyright( index_offset ) {
 local s = split( fe.game_info( Info.Manufacturer, index_offset ), "(" );
 if ( s.len() > 0 ) return "© " + fe.game_info( Info.Year, index_offset ) + " " + s[0];
 return "";
}
// Returns a random number below 255. Set randrange to higher values to hit closer to 255
function highrand( randrange ) {
 return 255-(rand()/randrange);
}
// Random high colour values
local red = highrand( 255 );
local green = highrand( 255 );
local blue = highrand( 255 );
local grey = highrand( 1024 );
// Image shadow/outline thickness
local offset = 4;
/////////////////////////////////////////////////////////
// On Screen Objects
// Game snapshot
if ( my_config["bg_image"] == "snap") {
 local bg = fe.add_artwork( "snap", -80, -60, 800, 600 );
 bg.shader = bg_shader;
}
if ( my_config["bg_image"] == "title") {
 local bg = fe.add_artwork( "title", -80, -60, 800, 600);
 bg.shader = bg_shader;
}
if ( my_config["bg_image"] == "user") {
 local bg = fe.add_artwork( "bg.jpg", 0, 0, fe.layout.width, fe.layout.height);
 bg.shader = bg_shader;
} 
local bgmask = fe.add_image ("mask.png", 0, 0, fe.layout.width, fe.layout.height);
bgmask.set_rgb (0,0,0);
// Flyer image
local flyeroutline = fe.add_artwork( "flyer", 315, 20, 300, 400);
flyeroutline.preserve_aspect_ratio = true;
flyeroutline.rotation = my_config["flyer_angle"].tofloat();
flyeroutline.x = flyeroutline.x + (my_config["flyer_angle"].tointeger()*5);
flyeroutline.y = flyeroutline.y - my_config["flyer_angle"].tointeger();  
local flyer = fe.add_clone( flyeroutline );
flyeroutline.x = flyeroutline.x - (offset / 2);
flyeroutline.y = flyeroutline.y - (offset / 2);
flyeroutline.width = flyeroutline.width + offset;
flyeroutline.height = flyeroutline.height + offset;
flyeroutline.set_rgb (32,32,32);
// Game title block
local copy = fe.add_text( copyright ( 0 ), 30, 435, fe.layout.width - 60, 20 );
copy.align = Align.Left;
local gametitleshadow = fe.add_text( "[Title]", 21, 411, fe.layout.width, 24 );
gametitleshadow.align = Align.Left;
gametitleshadow.set_rgb (0,0,0);
local gametitle = fe.add_text( gamename ( 0 ), 20, 410, fe.layout.width, 24 );
gametitle.align = Align.Left;
// Make the game title flicker. Added bonus - currently fixes graphical corruption and screen not refreshing bugs.
fe.add_ticks_callback("flickertitle");
function flickertitle( ttime ) {
 if ( my_config["enable_flicker"] == "Yes" ) {
  grey = highrand( 1024 );
  gametitle.set_rgb (grey,grey,grey);
 } else {
  gametitle.set_rgb (255,255,255);
 }
}
// Game wheel image
local wheelshadow = fe.add_artwork( "wheel", 14, 224, 0, 0);
wheelshadow.set_rgb(0,0,0);
local wheel = fe.add_clone( wheelshadow );
wheel.set_rgb (255,255,255);
wheel.x = wheel.x - offset;
wheel.y = wheel.y - offset; 
// Loading screen message.
local message = fe.add_text("Loading...",0,200,fe.layout.width,80);
message.alpha = 0;
// Optional game texts
local romlist = fe.add_text( "[ListTitle]", 5, 20, fe.layout.width - 5, 20 );
romlist.align = Align.Left;
local filter = fe.add_text( "[ListFilterName]", 5, 20, fe.layout.width - 5, 20 );
filter.align = Align.Right;
local cat = fe.add_text( fe.game_info (Info.Category), 30, 435, fe.layout.width - 60, 20 );
cat.align = Align.Right;
local entries = fe.add_text( "[ListEntry]/[ListSize]", 0, 0, fe.layout.width, 15 );
entries.align = Align.Right;
// Switch texts on and off
if ( my_config["enable_category"] == "Yes" ) { cat.visible = true; } else { cat.visible = false; }
if ( my_config["enable_list"] == "Yes" ) { romlist.visible = true; } else { romlist.visible = false; }
if ( my_config["enable_filter"] == "Yes" ) { filter.visible = true; } else { filter.visible = false; }
if ( my_config["enable_entries"] == "Yes" ) { entries.visible = true; } else { entries.visible = false; }
// Transitions
fe.add_transition_callback( "fade_transitions" );
function fade_transitions( ttype, var, ttime ) {
 switch ( ttype ) {
  case Transition.ToNewList:
  case Transition.ToNewSelection:
   gametitleshadow.msg = gamename ( var );
   gametitle.msg = gametitleshadow.msg;  
   red = highrand( 255 );
   green = highrand( 255 );
   blue = highrand( 255 );
   copy.msg = copyright ( var );
   copy.set_rgb (red,green,blue);
   cat.msg = fe.game_info (Info.Category, var);
   cat.set_rgb (red,green,blue);
   break;
  case Transition.FromGame:
   if ( ttime < 255 ) {
    foreach (o in fe.obj) o.alpha = ttime;
    message.alpha = 0;     
    return true;
   } else {
    foreach (o in fe.obj) o.alpha = 255;
    message.alpha = 0;
   }
   break;  
  case Transition.EndLayout:
   if ( ttime < 255 ) {
    foreach (o in fe.obj) o.alpha = 255 - ttime;
    message.alpha = 0; 
    return true;
   } else {
    foreach (o in fe.obj) o.alpha = 255;
    message.alpha = 0;
   }
   break;
  case Transition.ToGame:
   if ( ttime < 255 ) {
    foreach (o in fe.obj) o.alpha = 255 - ttime;
    message.alpha = ttime;
    return true;
   }   
   break; 
  }
 return false;
}
