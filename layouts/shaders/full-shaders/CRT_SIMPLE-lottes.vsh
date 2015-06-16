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
varying float aperature_type;

void main()
{
    texCoord = gl_MultiTexCoord0.xy;
    gl_TexCoord[0]  =  gl_MultiTexCoord0;
    gl_Position     = ftransform();
    /// CRT GEOMETRY ///
    // APERATURE_TYPE
    // 0 = VGA style shadow mask.
    // 1.0 = Very compressed TV style shadow mask.
    // 2.0 = Aperture-grille.
    aperature_type = 0.0;
    // aspect ratio
    distortion = 0.1;
    // size of curved corners
    cornersize = 0.038;
    // border smoothness parameter
    // decrease if borders are too aliased
    cornersmooth = 400.0;
    /// CRT GEOMETRY END ///
    // FILTER VARS
    hardScan=-12.0; //-8,-12,-16, etc to make scalines more prominent.
    maskDark=0.4; //Sets how dark a "dark subpixel" is in the aperture pattern.
    maskLight=1.0; //Sets how dark a "bright subpixel" is in the aperture pattern.
    hardPix=-2.3; //-1,-2,-4, etc to make the upscaling sharper.
    // YUV VARS
    saturation = 1.25;  // 1.0 is normal saturation. Increase as needed.
    tint = 0.1;  //0.0 is 0.0 degrees of Tint. Adjust as needed.
    // GAMMA VARS
    blackClip = 0.08;  //Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
    brightMult = 1.25; //Multiplies the color values by this amount if GAMMA_CONTRAST_BOOST is defined
}
