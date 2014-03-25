//
// Starfield code adapted from: "Starfield" by Christophe Résigné
//
// http://www.chromeexperiments.com/detail/starfield/?f=`
// http://www.chiptune.com/starfield/starfield.html
//
class UserConfig {
	</ label="Controls: Up", help="Set controls for navigating the starfield", is_input="yes" />
	a_up="";

	</ label="Controls: Down", help="Set controls for navigating the starfield", is_input="yes" />
	b_down="";

	</ label="Controls: Left", help="Set controls for navigating the starfield", is_input="yes" />
	c_left="";

	</ label="Controls: Right", help="Set controls for navigating the starfield", is_input="yes" />
	d_right="";

	</ label="Speed", help="Speed of travel through starfield (-25 to 25, default=4)" />
	e_speed="4";

	</ label="Artwork Label", help="Set the artwork to display", options="snap,wheel,flyer,marquee" />
	f_artwork="snap";

	</ label="Artwork Size", help="Set the size of the displayed artwork", options="Small,Medium,Large" />
	g_art_size="Large";

	</ label="Transition", help="Set the artwork transition type", options="Fade,Navigate" />
	h_transition="Fade";
}

local my_config = fe.get_config();

fe.layout.width=640;
fe.layout.height=480;

const n=256;
local x=fe.layout.width/2;
local y=fe.layout.height/2;
local z=(fe.layout.width+fe.layout.height)/2;

local star_colour_ratio=1.0/z;
local mouse_x=x;
local mouse_y=y;
local star_ratio=256;
local base_speed = my_config["e_speed"].tofloat(); 
if ( abs( base_speed ) > 25 ) // speed limits...
	base_speed=25.0;

local star_speed=base_speed;

local star = array(n);

function my_rand()
{
	return ( rand() % 1000 ) / 1000.0;
}

function my_round( num )
{
	return ( num + 0.5 ).tointeger();
}

function my_set_colour( star, val )
{
	local temp = val * 255;
	if ( temp > 255 )
		temp = 255;

	star.set_rgb( temp, temp, temp );
}

local resource = fe.add_image( "dot.png", -1, -1, 1, 1 );

for(local i=0;i<n;i++)
{
	star[i]=array(7);
	star[i][0]=my_rand()*fe.layout.width*2-x*2;
	star[i][1]=my_rand()*fe.layout.height*2-y*2;
	star[i][2]=my_round( my_rand()*z );
	star[i][3]=0;
	star[i][4]=0;
	star[i][5]=fe.add_clone( resource );
	star[i][6]=fe.add_clone( resource );

	// make 10% of the stars a bit bigger
	if ( rand() % 10 == 0 )
	{
		star[i][5].width = star[i][5].height=2;
		star[i][6].width = star[i][6].height=2;
	}
}

local snap_width = 480;
local snap_height = 360;

if ( my_config["g_art_size"] == "Small" )
{
	snap_width = 240;
	snap_height = 180;
}
else if ( my_config["g_art_size"] == "Medium" )
{
	snap_width = 360;
	snap_height = 270;
}

local snap_x = ( fe.layout.width - snap_width ) / 2;
local snap_y = ( fe.layout.height - snap_height ) / 2;

local snap_back = fe.add_artwork( my_config["f_artwork"], snap_x, snap_y, snap_width, snap_height );
snap_back.alpha = 0;
snap_back.preserve_aspect_ratio=true;

local snap = fe.add_artwork( my_config["f_artwork"], snap_x, snap_y, snap_width, snap_height );
snap.preserve_aspect_ratio=true;

function anim()
{
	for(local i=0;i<n;i++)
	{
		local test=true;
		local star_x_save=star[i][3];
		local star_y_save=star[i][4];

		star[i][0]+=mouse_x>>4;

		if(star[i][0] > x <<1)
		{
			star[i][0]-=fe.layout.width<<1;
			test=false;
		}
		if(star[i][0] < -x<<1)
		{
			star[i][0]+=fe.layout.width<<1;
			test=false;
		}

		star[i][1]+=mouse_y>>4;

		if(star[i][1] > y<<1)
		{
			star[i][1]-=fe.layout.height<<1;
			test=false;
		}
		if(star[i][1] < -y<<1)
		{
			star[i][1]+=fe.layout.height<<1;
			test=false;
		}

		star[i][2]-=star_speed;

		if(star[i][2] > z)
		{
			star[i][2]-=z;
			test=false;
		}
		if(star[i][2] < 0)
		{
			star[i][2]+=z;
			test=false;
		}

		star[i][3]=x+(star[i][0]/star[i][2])*star_ratio;
		star[i][4]=y+(star[i][1]/star[i][2])*star_ratio;

		local temp = (1-star_colour_ratio*star[i][2])*2;
		my_set_colour( star[i][5], temp );

		if(star_x_save>0
			&&star_x_save<fe.layout.width
			&&star_y_save>0
			&&star_y_save<fe.layout.height
                        &&test)
		{
			star[i][6].visible = true;

			my_set_colour( star[i][6], temp );

			star[i][5].x = star[i][3];
			star[i][5].y = star[i][4];

			star[i][6].x = star_x_save;
			star[i][6].y = star_y_save;
		}
		else
		{
			star[i][5].x = star[i][3];
			star[i][5].y = star[i][4];
			star[i][6].visible = false;
		}
	}
}

fe.add_ticks_callback( "my_tick" );
fe.add_transition_callback( "my_transition" );

local accumulate_x=0;

function my_tick( ttime )
{
	local up = fe.get_input_pos( my_config["a_up"] );
	local down = fe.get_input_pos( my_config["b_down"] );
	local left = fe.get_input_pos( my_config["c_left"] );
	local right = fe.get_input_pos( my_config["d_right"] );
	local cursor_x=x;
	local cursor_y=y;
	if ( up > 0 )
	{
		cursor_y = ( y + ( up / 100.0 ) * y ).tointeger();
		snap.y = snap_y - ( up / 100.0 ) * 4;
	}
	if ( down > 0 )
	{
		cursor_y = ( y - ( down / 100.0 ) * y ).tointeger();
		snap.y = snap_y + ( down / 100.0 ) * 4;
	}

	if ( left > 0 )
	{
		cursor_x = ( x + ( left / 100.0 ) * x ).tointeger();
		snap.x = snap_x - ( left / 100.0 ) * 4;
		accumulate_x -= left / 10;
	}
	if ( right > 0 )
	{
		cursor_x = ( x - ( right / 100.0 ) * y ).tointeger();
		snap.x = snap_x + ( right / 100.0 ) * 4;
		accumulate_x += right / 10;
	}

	mouse_x=cursor_x-x;
	mouse_y=cursor_y-y;

	if ( my_config["h_transition"] == "Navigate" )
	{
		if ( accumulate_x > 0 )
		{
			snap_back.alpha=255;
			snap_back.index_offset = snap.index_offset + 1;
			snap_back.x = fe.layout.width - accumulate_x;

			if ( snap_back.x < fe.layout.width )
			{
				snap.x = snap_x - ( fe.layout.width - snap_back.x );
			}

			if ( snap_back.x <= snap_x )
			{
				fe.list.index++;
				snap_back.alpha=0;
				accumulate_x = 0;
			}
		}
		else
		{
			snap_back.alpha=255;
			snap_back.index_offset = snap.index_offset - 1;
			snap_back.x = -fe.layout.width - accumulate_x;

			if ( snap_back.x + snap_back.width > 0 )
			{
				snap.x = snap_x + ( snap_back.x + snap_back.width );
			}

			if ( snap_back.x >= snap_x )
			{
				fe.list.index--;
				snap_back.alpha=0;
				accumulate_x = 0;
			}
		}
	}

	anim();
}

function my_transition( ttype, var, ttime )
{
	switch ( ttype )
	{
	case Transition.ToGame:
		if ( ttime < 1500 )
		{
			snap_back.alpha=0;
			accumulate_x = 0;
			mouse_x=0;
			mouse_y=0;
			if ( ttime < 1000 )
			{
				snap.width = snap_width - snap_width * ( ttime / 1000.0 );
				snap.height = snap_height - snap_height * ( ttime / 1000.0 );
				snap.x = ( fe.layout.width - snap.width ) / 2;
				snap.y = ( fe.layout.height - snap.height ) / 2;
				star_speed= base_speed * 4;
			}
			else 
			{
				snap.visible=false;
				star_speed= base_speed * 5;
			}

			anim();
			return true;
		}
		star_speed= base_speed;
		snap.x = snap_x;
		snap.y = snap_y;
		snap.width = snap_width;
		snap.height = snap_height;
		snap.visible=true;
		break;

	case Transition.ToNewSelection:
		if ( my_config["h_transition"] == "Fade" )
		{
			if ( ttime < 125 )
			{
				snap_back.index_offset = var;

				snap.alpha = 255 - ttime * 2;
				snap_back.alpha = ttime * 2;
				anim();
				return true;
			}
			snap.alpha=255;
			snap_back.alpha = 0;
		}
		break;
	}

	return false;
}
