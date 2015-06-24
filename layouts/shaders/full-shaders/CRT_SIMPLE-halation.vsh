/** Shader **/

/// FOR CRT GEOM ///
varying float cornersize;
varying float cornersmooth;
varying float distortion;
varying vec2 texCoord;

varying float hardScan;
varying float maskDark;
varying float maskLight;
varying float hardPix;
varying float saturation;
varying float tint;
varying float blackClip;
varying float brightMult;

varying float hardBloomScan;
varying float bloomAmount;

varying float aperature_type;
varying float bloom_on;

void main()
{
    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = ftransform();
    // Texture coords.
    texCoord = gl_TexCoord[0].xy;

    // APERATURE_TYPE
    // 0 = VGA style shadow mask.
    // 1.0 = Very compressed TV style shadow mask.
    // 2.0 = Aperture-grille.
    aperature_type = 2.0;
    // size of curved corners
    cornersize = 0.038;
    // border smoothness parameter
    // decrease if borders are too aliased
    cornersmooth = 400.0;
    //
    distortion = 0.1;
    
    // FILTER VARS
    // YUV VARS
    saturation = 1.05;  // 1.0 is normal saturation. Increase as needed.
    tint = 0.1;  //0.0 is 0.0 degrees of Tint. Adjust as needed.
    // GAMMA VARS
    //Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
    blackClip = 0.08;  
    //Multiplies the color values by this amount if GAMMA_CONTRAST_BOOST is defined
    brightMult = 1.2; 
    // Hardness of scanline.
    //  -8.0 = soft
    // -16.0 = medium
    hardScan = -13.0;
    // Hardness of pixels in scanline.
    // -2.0 = soft
    // -4.0 = hard
    hardPix = -3.0;

    maskDark = 0.7; //Sets how dark a "dark subpixel" is in the aperture pattern.
    maskLight = 1.4; //Sets how dark a "bright subpixel" is in the aperture pattern
    // Hardness of short vertical bloom.
    //  -1.0 = wide to the point of clipping (bad)
    //  -1.5 = wide
    //  -4.0 = not very wide at all
    hardBloomScan = -2.7;

    // Amount of small bloom effect.
    //  1.0/1.0 = only bloom
    //  1.0/16.0 = what I think is a good amount of small bloom
    //  0.0     = no bloom
    bloomAmount = 1.0/2.0;
    
    // BLOOM ON/OFF SWITCH
    bloom_on = 0.0;
}


