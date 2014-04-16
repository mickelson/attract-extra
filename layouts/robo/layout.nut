//
// Attract-Mode Front-End - "Robo" sample layout
//
// Robotron Model Copyright Andrew Kator & Jennifer Legaz
// http://3dmodels.katorlegaz.com/arcade_machines/248/index.php
//
fe.layout.width = 1024;
fe.layout.height = 768;

local marquee = fe.add_artwork( "marquee", 568, 25, 384, 110 );
marquee.skew_x = -22;
marquee.rotation = 1;
marquee.subimg_width=-marquee.texture_width;

local l = fe.add_listbox( 0, 0, 490, 768 );
l.charsize = 19;

l = fe.add_artwork( "", 719, 258, 220, 190 );
l.pinch_y = -10;
l.rotation = 7;

fe.add_image( "robo.png", 0, 0, 1024, 768 );
