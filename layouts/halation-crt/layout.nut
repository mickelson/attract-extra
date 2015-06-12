//
// Attract-Mode Front-End - "Basic" sample layout
//
fe.layout.width=640;
fe.layout.height=480;

local surf = fe.add_surface( 640, 480 );

local shader = fe.add_shader( Shader.VertexAndFragment, "CRT-halation.vsh", "CRT-halation_rgb32_dir.fsh" );
                shader.set_param( "color_texture_sz", 640, 480 );
                shader.set_param( "color_texture_pow2_sz", 640, 480 );
                shader.set_texture_param( "mpass_texture" );

surf.shader = shader;

surf.add_artwork( "snap", 348, 152, 262, 262 );
surf.add_artwork( "marquee", 348, 64, 262, 72 );

local l = surf.add_listbox( 32, 64, 262, 352 );
l.charsize = 16;
l.set_selbg_rgb( 255, 255, 255 );
l.set_sel_rgb( 0, 0, 0 );
l.sel_style = Style.Bold;

surf.add_image( "bg.png", 0, 0 );

l = surf.add_text( "[ListTitle]", 0, 15, 640, 30 );
l.set_rgb( 200, 200, 70 );
l.style = Style.Bold;

// Left side:

l = surf.add_text( "[Title]", 30, 424, 320, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Left;

l = surf.add_text( "[Year] [Manufacturer]", 30, 441, 320, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Left;

l = surf.add_text( "[Category]", 30, 458, 320, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Left;

// Right side:

l = surf.add_text( "[ListEntry]/[ListSize]", 320, 424, 290, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Right;

l = surf.add_text( "[ListFilterName]", 320, 441, 290, 16 );
l.set_rgb( 200, 200, 70 );
l.align = Align.Right;

