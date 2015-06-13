//
// Attract-Mode Front-End - "Basic" sample layout
//
fe.layout.width=640;
fe.layout.height=480;

local surf = fe.add_surface( 640, 480 );

local shader = fe.add_shader( Shader.VertexAndFragment, "CRT-halation.vsh", "CRT-halation_rgb32_dir.fsh" );
                // APERATURE_TYPE
                // 0 = VGA style shadow mask.
                // 1.0 = Very compressed TV style shadow mask.
                // 2.0 = Aperture-grille.
                shader.set_param( "aperature_type", 1.0 );
                // aspect ratio
                shader.set_param( "aspect", 1.0, 0.9 );
                // Radius of curvature
                shader.set_param( "R", 4.0 );
                // Size of corners
                shader.set_param( "cornersize", 0.038 );
                // Smoothing corners (100-1000)
                shader.set_param( "cornersmooth", 400.0 );
                // Hardness of Scanline -8.0 = soft -16.0 = medium
                shader.set_param( "hardScan", -10.0 );
                // Hardness of pixels in scanline -2.0 = spoft, -4.0 = hard
                shader.set_param( "hardPix", -4.0 );
                //Sets how dark a "dark subpixel" is in the aperture pattern.
                shader.set_param( "maskDark", 0.4 );
                //Sets how dark a "bright subpixel" is in the aperture pattern
                shader.set_param( "maskLight", 1.8 );
                // BLOOM VARS //
                // Hardness of short vertical bloom.
                //  -1.0 = wide to the point of clipping (bad)
                //  -1.5 = wide
                //  -4.0 = not very wide at all
                shader.set_param( "hardBloomScan", -1.8 );
                // Hardness of short horizontal bloom.
                //  -0.5 = wide to the point of clipping (bad)
                //  -1.0 = wide
                //  -2.0 = not very wide at all
                shader.set_param( "hardBloomPix", -0.8 );
                // Amount of small bloom effect.
                //  1.0/1.0 = only bloom
                //  1.0/16.0 = what I think is a good amount of small bloom
                //  0.0     = no bloom
                shader.set_param( "bloomAmount", 1.0/6.0 );
                // Bloom Type -=- 0.0 = Normal, 1.0 = additive
                shader.set_param( "additive_bloom", 1.0 );
                
                // Standard Shader stuff. Can probably send image.width to shader
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

