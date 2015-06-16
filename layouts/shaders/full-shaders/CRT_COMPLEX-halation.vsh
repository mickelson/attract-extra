// PUBLIC DOMAIN CRT STYLED SCAN-LINE SHADER
//
//  modified a little by Luke-Nukem (admin@garagearcades.co.nz)
//  http://www.garagearcades.co.nz
/** Shader **/
/// FOR CRT GEOM ///
varying vec2 overscan;
varying vec2 aspect;

varying float d;
varying float R;

varying float cornersize;
varying float cornersmooth;

varying vec3 stretch;
varying vec2 sinangle;
varying vec2 cosangle;

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

#define FIX(c) max(abs(c), 1e-5);

float intersect(vec2 xy)
{
  float A = dot(xy,xy)+d*d;
  float B = 2.0*(R*(dot(xy,sinangle)-d*cosangle.x*cosangle.y)-d*d);
  float C = d*d + 2.0*R*d*cosangle.x*cosangle.y;
  return (-B-sqrt(B*B-4.0*A*C))/(2.0*A);
}

vec2 bkwtrans(vec2 xy)
{
  float c = intersect(xy);
  vec2 point = vec2(c)*xy;
  point -= vec2(-R)*sinangle;
  point /= vec2(R);
  vec2 tang = sinangle/cosangle;
  vec2 poc = point/cosangle;
  float A = dot(tang,tang)+1.0;
  float B = -2.0*dot(poc,tang);
  float C = dot(poc,poc)-1.0;
  float a = (-B+sqrt(B*B-4.0*A*C))/(2.0*A);
  vec2 uv = (point-a*sinangle)/cosangle;
  float r = R*acos(a);
  return uv*r/sin(r/R);
}

vec2 fwtrans(vec2 uv)
{
  float r = FIX(sqrt(dot(uv,uv)));
  uv *= sin(r/R)/r;
  float x = 1.0-cos(r/R);
  float D = d/R + x*cosangle.x*cosangle.y+dot(uv,sinangle);
  return d*(uv*cosangle-x*sinangle)/D;
}

vec3 maxscale()
{
  vec2 c = bkwtrans(-R * sinangle / (1.0 + R/d*cosangle.x*cosangle.y));
  vec2 a = vec2(0.5,0.5)*aspect;
  vec2 lo = vec2(fwtrans(vec2(-a.x,c.y)).x,
		 fwtrans(vec2(c.x,-a.y)).y)/aspect;
  vec2 hi = vec2(fwtrans(vec2(+a.x,c.y)).x,
		 fwtrans(vec2(c.x,+a.y)).y)/aspect;
  return vec3((hi+lo)*aspect*0.5,max(hi.x-lo.x,hi.y-lo.y));
}


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
    // overscan (e.g. 1.02 for 2% overscan)
    overscan = vec2(0.98, 0.98);
    // aspect ratio
    aspect = vec2(1.0, 0.9);
    // lengths are measured in units of (approximately) the width of the monitor
    // simulated distance from viewer to monitor
    d = 2.0;
    // radius of curvature
    R = 3.0;
    // tilt angle in radians
    // (behavior might be a bit wrong if both components are nonzero)
    const vec2 angle = vec2(0.0,0.0);
    // size of curved corners
    cornersize = 0.038;
    // border smoothness parameter
    // decrease if borders are too aliased
    cornersmooth = 400.0;
    
    // FILTER VARS
    // YUV VARS
    saturation = 1.25;  // 1.0 is normal saturation. Increase as needed.
    tint = 0.1;  //0.0 is 0.0 degrees of Tint. Adjust as needed.
    // GAMMA VARS
    //Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
    blackClip = 0.08;  
    //Multiplies the color values by this amount if GAMMA_CONTRAST_BOOST is defined
    brightMult = 1.1; 
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
    
    // Precalculate a bunch of useful values we'll need in the fragment
    // shader.
    sinangle = sin(angle);
    cosangle = cos(angle);
    stretch = maxscale();
}


