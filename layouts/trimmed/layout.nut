// Attract mode example of a non-list based layout trimming brackets from game titles
fe.layout.width=640;
fe.layout.height=480;
// Use Coolvetica if found 
fe.layout.font="coolvetica rg";

// Trim functions
function trimmed_title( index_offset ) {
 local s = split( fe.game_info( Info.Title, index_offset ), "/(" );
 if ( s.len() > 0 )
  return s[0];
 return "";
}

function trimmed_man( index_offset ) {
 local s = split( fe.game_info( Info.Manufacturer, index_offset ), "(" );
 if ( s.len() > 0 )
  return s[0];
 return "";
}

// Gives us a nice high random number for the RGB levels
function brightrand() {
 return 255-(rand()/255);
}

local red = brightrand();
local green = brightrand();
local blue = brightrand();

// Game snapshot
local snap = fe.add_artwork( "screen", -80, -60, fe.layout.width + 160, fe.layout.height + 120);
snap.set_rgb (192,192,192);

// Game title bar
local titlebg = fe.add_image ("mask.png", 0, 300, fe.layout.width, 100)
titlebg.set_rgb (0,0,0);
local titlebg2 = fe.add_clone (titlebg);
titlebg2.rotation = 180;
titlebg2.height = titlebg2.height / 2;
titlebg2.x = fe.layout.width;
titlebg2.y = titlebg.y + titlebg.height;

// Game title text
local gametitleshadow = fe.add_text( trimmed_title( 0 ), 21, 335, fe.layout.width, 25 );
gametitleshadow.align = Align.Left;
gametitleshadow.style = Style.Bold;
gametitleshadow.set_rgb (0,0,0);
local gametitle = fe.add_text( trimmed_title( 0 ), 20, 334, fe.layout.width, 25 );
gametitle.align = Align.Left;
gametitle.style = Style.Bold;
local copy = fe.add_text( "©", 30, 360, 320, 20 );
copy.align = Align.Left;
local man = fe.add_text( trimmed_man( 0 ), 42, 360, 320, 20 );
man.align = Align.Left;
local year = fe.add_text( "[Year]", 20, 300, fe.layout.width, 90 );
year.align = Align.Right;
year.style = Style.Bold;

// Category
local cat = fe.add_text( "[Category]", 0, 450, fe.layout.width, 24 );
cat.set_rgb( 0, 0, 0 );
cat.align = Align.Centre;

// Filters
local romlist = fe.add_text( "[ListTitle]", 5, 20, fe.layout.width - 5, 20 );
romlist.align = Align.Left;
romlist.style = Style.Bold;
local filter = fe.add_text( "[ListFilterName]", 5, 20, fe.layout.width - 5, 20 );
filter.align = Align.Right;
filter.style = Style.Bold;
local details = fe.add_text( "[ListEntry]/[ListSize]", 0, 464, fe.layout.width, 16 );
details.align = Align.Right;
details.style = Style.Bold;
details.set_rgb (0,0,0);

// Game wheel image
local wheel = fe.add_artwork( "marquee", 120, 50, 400, 0);

// Loading text
local message = fe.add_text("Loading...",0,200,fe.layout.width,80)
message.alpha = 0;
message.style = Style.Bold;

// Transitions
fe.add_transition_callback( "fancy_transitions" );

function fancy_transitions( ttype, var, ttime ) {
 switch ( ttype )
 {
 case Transition.StartLayout:
 case Transition.ToNewList:
 case Transition.ToNewSelection:
 case Transition.EndLayout:
  gametitleshadow.msg = trimmed_title( var );
  gametitle.msg = trimmed_title( var );
  man.msg = trimmed_man ( var );
  red = brightrand();
  green = brightrand();
  blue = brightrand();
  year.set_rgb (red,green,blue);
  copy.set_rgb (red,green,blue);
  man.set_rgb (red,green,blue);
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