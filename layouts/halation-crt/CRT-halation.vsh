/** Shader **/

varying float redBleed;
varying float maskDarker;

/// FOR CRT GEOM ///
varying float cornersize;
varying float cornersmooth;
varying vec2 aspect;
varying float R;
varying vec2 texCoord;

varying float hardScan;
varying float maskDark;
varying float maskLight;
varying float hardPix;

varying float hardBloomScan;
varying float hardBloomPix;
varying float bloomAmount;

void main()
{
    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = ftransform();
    
    /// CRT GEOMETRY ///
    // aspect ratio
    aspect = vec2(1.0, 0.9);
    // radius of curvature
    R = 4.0;
    // size of curved corners
    cornersize = 0.038;
    // border smoothness parameter
    // decrease if borders are too aliased
    cornersmooth = 400.0;
    /// CRT GEOMETRY END ///
    // Texture coords.
    texCoord = gl_TexCoord[0].xy;
    
    // FILTER VARS
    // Hardness of scanline.
    //  -8.0 = soft
    // -16.0 = medium
    hardScan = -10.0;
    // Hardness of pixels in scanline.
    // -2.0 = soft
    // -4.0 = hard
    hardPix = -4.0;

    maskDark = 0.4; //Sets how dark a "dark subpixel" is in the aperture pattern.
    maskLight = 1.8; //Sets how dark a "bright subpixel" is in the aperture pattern
    
    // BLOOM VARS //
    // Hardness of short vertical bloom.
    //  -1.0 = wide to the point of clipping (bad)
    //  -1.5 = wide
    //  -4.0 = not very wide at all
    hardBloomScan=-2.0;

    // Hardness of short horizontal bloom.
    //  -0.5 = wide to the point of clipping (bad)
    //  -1.0 = wide
    //  -2.0 = not very wide at all
    hardBloomPix=-1.5;

    // Amount of small bloom effect.
    //  1.0/1.0 = only bloom
    //  1.0/16.0 = what I think is a good amount of small bloom
    //  0.0     = no bloom
    bloomAmount=1.0/4.0;
}


