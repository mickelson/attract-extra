//
// Attract-Mode Front-End - "Reflect" sample layout
//
class UserConfig {
	</ label="Colour Scheme", help="Select the menu colour scheme.", options="Blue,Green,Red,Yellow,Purple,Brown,Grey" />
	colour="Blue";
};

local config = fe.get_config();

class Colour
{
	r = 0; g = 0; b = 0;

	constructor( rr, gg, bb )
	{
		r = rr; g = gg; b = bb;
	}
};

local bg_colour = Colour( 0, 0, 255 );
local fg_colour = Colour( 255, 255, 255 );
switch ( config[ "colour" ] )
{
	case "Blue":
		bg_colour = Colour( 0, 0, 255 );
		fg_colour = Colour( 200, 200, 200 );
		break;
	case "Green":
		bg_colour = Colour( 0, 100, 0 );
		fg_colour = Colour( 80, 255, 80 );
		break;
	case "Red":
		bg_colour = Colour( 180, 0, 0 );
		fg_colour = Colour( 255, 190, 190 );
		break;
	case "Yellow":
		bg_colour = Colour( 255, 255, 0 );
		fg_colour = Colour( 100, 100, 0 );
		break;
	case "Purple":
		bg_colour = Colour( 100, 0, 100 );
		fg_colour = Colour( 250, 100, 250 );
		break;
	case "Brown":
		bg_colour = Colour( 80, 80, 0 );
		fg_colour = Colour( 200, 200, 100 );
		break;
	case "Grey":
		bg_colour = Colour( 60, 60, 60 );
		fg_colour = Colour( 180, 180, 180 );
		break;
}

fe.layout.width=640;
fe.layout.height=480;

// fill an entire surface with our snap at a resolution of 480x360
//
local surface = fe.add_surface( 480, 360 );
local snap = surface.add_artwork( "snap", 0, 0, 480, 360 );
snap.preserve_aspect_ratio = true;

// position and pinch the surface
//
surface.set_pos( 330, 80, 300, 250 );
surface.pinch_y = -80;

// now create a reflection of the surface
//
local reflect = fe.add_clone( surface );
reflect.subimg_y = reflect.texture_height;
reflect.subimg_height = -reflect.texture_height;
reflect.set_rgb( 20, 20, 20 );

// position the reflection
//
reflect.set_pos( 325, 340, 300, 60 );
reflect.skew_y = 440;
reflect.skew_x = -400;

// store the background image used for listbox entries here:
//
local lb_bg_image=0;

// Class representing a listbox bubble
//
class LBEntry
{
	bg = 0;
	text = 0;
	texts = 0;
	index_offset = 0;

	constructor( io, x, y )
	{
		if ( lb_bg_image == 0 )
			bg = lb_bg_image = fe.add_image( "bubbleo.png" );
		else
			bg = fe.add_clone( lb_bg_image );

		bg.set_rgb( bg_colour.r, bg_colour.g, bg_colour.b );

		index_offset = io;
		if ( io == 0 )
		{
			// Setup for the bubble showing the current entry
			//
			bg.set_pos( -15, y - 3, 342, 32 );

			texts = fe.add_text( _get_name(), x + 1, y + 1, 320, 25 );
			texts.set_rgb( 0, 0, 0 );

			text = fe.add_text( _get_name(), x, y, 320, 25 );

			if ( config["colour"] == "Yellow" )
				text.set_rgb( 0, 0, 0 );
			else
				text.set_rgb( 255, 255, 0 );
		}
		else
		{
			bg.set_pos( x - 10, y - 3, 202, 27 );

			texts = fe.add_text( _get_name(), x + 1, y + 1, 190, 20 );
			texts.set_rgb( 0, 0, 0 );

			text = fe.add_text( _get_name(), x, y, 190, 20 );
			text.set_rgb( fg_colour.r, fg_colour.g, fg_colour.b );

			text.align = texts.align = Align.Right;
		}
	}

	function update()
	{
		text.msg = texts.msg = _get_name();
	}

	function _get_name() 
	{
		local s = split( fe.game_info( Info.Title, index_offset ), "(" );

		if ( s.len() > 0 )
			return s[0];

		return "";
	}
}

local lb = [];

local hyp = pow( 240, 2 );
function get_x( y )
{
	return 240 - sqrt( hyp - pow( ( 240 - y ), 2 ) );
}

lb.append( LBEntry( -7, get_x( 10 ), 10 ) );
lb.append( LBEntry( -6, get_x( 40 ), 40 ) );
lb.append( LBEntry( -5, get_x( 70 ),  70 ) );
lb.append( LBEntry( -4, get_x( 100 ), 100 ) );
lb.append( LBEntry( -3, get_x( 130 ), 130 ) );
lb.append( LBEntry( -2, get_x( 160 ), 160 ) );
lb.append( LBEntry( -1, get_x( 190 ), 190 ) );

lb.append( LBEntry( 0, get_x( 224 ), 224 ) );

lb.append( LBEntry( 1, get_x( 190 ), 270 ) );
lb.append( LBEntry( 2, get_x( 160 ), 300 ) );
lb.append( LBEntry( 3, get_x( 130 ), 330 ) );
lb.append( LBEntry( 4, get_x( 100 ), 360 ) );
lb.append( LBEntry( 5, get_x( 70 ),  390 ) );
lb.append( LBEntry( 6, get_x( 40 ), 420 ) );
lb.append( LBEntry( 7, get_x( 10 ), 450 ) );

class RedBubble
{
	bg = 0;
	text = 0;
	texts = 0;

	constructor( t, x, y, w, h, pad=0 )
	{
		if ( lb_bg_image == 0 )
			bg = lb_bg_image = fe.add_image( "bubbleo.png" );
		else
			bg = fe.add_clone( lb_bg_image );

		bg.set_pos( x - 15, y + 1 - pad, w + 15, h + 2 * pad );

		if ( config[ "colour" ] == "Red" )
			bg.set_rgb( 0, 0, 255 );
		else
			bg.set_rgb( 220, 0, 0 );

		texts = fe.add_text( t, x + 1, y + 1, w, h );
		texts.set_rgb( 0, 0, 0 );
		text = fe.add_text( t, x, y, w, h );
	}

	function set_msg( m )
	{
		text.msg = texts.msg = m;
	}

	function set_visible( f )
	{
		bg.visible = text.visible = texts.visible = f;
	}

	function get_visible()
	{
		return bg.visible;
	}
}

local info_bub = RedBubble( "", 0, 249, 295, 15 );

local l = fe.add_text( "[Title]", 370, 407, 240, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Right;

l = fe.add_text( "[Category]", 370, 424, 240, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Right;

l = fe.add_text( "[ListEntry]/[ListSize]", 470, 441, 140, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Right;

l = fe.add_text( "[ListTitle]", 4, 4, 140, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Left;

l = fe.add_text( "[ListFilterName]", 370, 4, 240, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Right;

local loading_bub = RedBubble( "Loading...", 195, 220, 250, 40, 5 );
loading_bub.set_visible( false );

fe.add_transition_callback( "update_lb" );
function update_lb( ttype, var, ttime )
{
	switch ( ttype )
	{
	case Transition.ToGame:
		if ( loading_bub.get_visible() == false )
		{
			loading_bub.set_visible( true );
			return true; // need a redraw
		}
		break;

	case Transition.FromGame:
		if ( loading_bub.get_visible() == true )
		{
			loading_bub.set_visible( false );
			return true; // need a redraw
		}
		break;

	case Transition.FromOldSelection:
	case Transition.ToNewList:
		foreach( l in lb )
			l.update();

		local year = fe.game_info( Info.Year, 0 );
		if ( year.len() > 0 )
		{
			info_bub.set_msg( "Copyright " + year + " " +
				fe.game_info( Info.Manufacturer, 0 ) );
		}
		else
		{
			info_bub.set_msg( "" );
		}
		break;
	}

	return false;
}

